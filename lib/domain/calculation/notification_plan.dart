import 'dart:convert';

import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_change.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

/// How far ahead the plan reaches.
const notificationHorizon = Duration(days: 7);

/// The most notifications planned at once. iOS keeps only the 64 soonest
/// pending notifications per app and silently drops the rest; 60 leaves a
/// margin (the same limit on Android, to behave the same).
const maxPlannedNotifications = 60;

/// Every notification the app wants scheduled from [now] on, soonest
/// first: what `SyncNotificationsUseCase` makes the device match.
///
/// **Planned as data, applied as a diff** (the Momentum pattern): the plan
/// is a pure function of the events, the settings and the time, so it's
/// tested without a device, and recomputed after every change (a ticket, a
/// save, a reminder toggle, a sync, a setting; on resume and in the
/// background). The sync then cancels what's no longer wanted and schedules
/// only what's new or changed.
///
/// From [items] (the events you're going to or saved):
/// - a **reminder** [AppSettings.reminderLead] before each event that has
///   one (`EventCardItem.hasReminder`), unless it's cancelled;
/// - the **daily summary** at [AppSettings.summaryTime] (the user's clock,
///   in [userZone]) on each day with events you're going to that haven't
///   ended by then.
///
/// Times already past or beyond [horizon] are dropped, and at most [limit]
/// are kept, the soonest. The RSVP confirmation and the change alerts are
/// shown at once ([rsvpConfirmation], [changeAlert]), never planned.
List<PlannedNotification> planNotifications({
  required DateTime now,
  required Iterable<EventCardItem> items,
  required AppSettings settings,
  required tz.Location userZone,
  Duration horizon = notificationHorizon,
  int limit = maxPlannedNotifications,
}) {
  final end = now.add(horizon);
  bool inWindow(DateTime at) => at.isAfter(now) && !at.isAfter(end);
  final live = [
    for (final item in items)
      if (item.event.status != EventStatus.cancelled) item,
  ];
  final plan = <PlannedNotification>[];

  for (final item in live) {
    if (!item.hasReminder) continue;
    final event = item.event;
    final at = event.time.start.subtract(settings.reminderLead.duration);
    if (!inWindow(at)) continue;
    plan.add(
      PlannedNotification(
        id: notificationId(NotificationKind.reminder, event.id),
        kind: NotificationKind.reminder,
        at: at,
        title: event.title,
        body:
            'Starts in ${settings.reminderLead.label}, at '
            '${_clock(event.time.start, _zoneFor(event, userZone), userZone)}'
            ' · ${_place(event)}',
        target: NotificationTarget.event(event.id),
      ),
    );
  }

  if (settings.summaryEnabled) {
    final going = [
      for (final item in live)
        if (item.isGoing) item.event,
    ]..sort((a, b) => a.time.start.compareTo(b.time.start));
    final today = CalendarDate.fromDateTime(tz.TZDateTime.from(now, userZone));
    for (var offset = 0; offset <= horizon.inDays; offset++) {
      final day = today.addDays(offset);
      final time = settings.summaryTime;
      final at = tz.TZDateTime(
        userZone,
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      ).toUtc();
      if (!inWindow(at)) continue;
      final onDay = [
        for (final event in going)
          if (_dayIn(event.time.start, userZone) == day &&
              event.time.end.isAfter(at))
            event,
      ];
      if (onDay.isEmpty) continue;
      final first = onDay.first;
      final more = onDay.length - 1;
      plan.add(
        PlannedNotification(
          id: notificationId(NotificationKind.summary, '${day.yyyymmdd}'),
          kind: NotificationKind.summary,
          at: at,
          title: 'Today',
          body: [
            '${first.title} at '
                '${_clock(first.time.start, _zoneFor(first, userZone), userZone)}',
            if (more > 0) 'and $more more',
          ].join(', '),
          target: const NotificationTarget.tickets(),
        ),
      );
    }
  }

  plan.sort((a, b) {
    final byTime = a.at.compareTo(b.at);
    return byTime != 0 ? byTime : a.id.compareTo(b.id);
  });
  return plan.take(limit).toList();
}

/// "You're going": shown once the server confirmed [ticket] for [event].
InstantNotification rsvpConfirmation(
  Ticket ticket,
  Event event, {
  required tz.Location userZone,
}) => InstantNotification(
  id: notificationId(NotificationKind.confirmation, ticket.id),
  kind: NotificationKind.confirmation,
  title: "You're going to ${event.title}",
  body:
      '${_when(event.time.start, _zoneFor(event, userZone), userZone)} · '
      '${ticket.type.label} · ${ticket.code}',
  target: NotificationTarget.ticket(ticket.id),
);

/// The alert for a recorded [change]: once per record (its id is the
/// record's).
InstantNotification changeAlert(
  EventChange change, {
  required tz.Location userZone,
}) {
  final event = change.event;
  final zone = _zoneFor(event, userZone);
  final previous = event.previousStart;
  return InstantNotification(
    id: notificationId(NotificationKind.change, '${change.id}'),
    kind: NotificationKind.change,
    title: switch (change.kind) {
      EventChangeKind.moved => '${event.title} has moved',
      EventChangeKind.cancelled => '${event.title} is cancelled',
    },
    body: switch (change.kind) {
      EventChangeKind.moved =>
        'Now ${_when(event.time.start, zone, userZone)}'
            '${previous == null ? '' : ' (was ${_when(previous, zone, userZone)})'}'
            '. Your ticket still stands.',
      EventChangeKind.cancelled =>
        'The organizer called it off. Your ticket shows the details.',
    },
    target: switch (change.ticketId) {
      final ticketId? => NotificationTarget.ticket(ticketId),
      null => NotificationTarget.event(event.id),
    },
  );
}

/// A stable id for [kind] about [key] (an event's id, a day, a ticket's id,
/// a change record's id): the same in every plan, so an unchanged
/// notification is recognised and left alone.
///
/// The 32-bit FNV-1a hash of the two, kept positive: Android's
/// notification ids are 32-bit signed integers.
int notificationId(NotificationKind kind, String key) {
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode('${kind.name}|$key')) {
    hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

// A notification's words are part of the plan: the sync compares them with
// what's pending to tell what changed, and the background isolate has no
// widgets to format with. Times are told as the event's screens tell them
// (an in-person event on its venue's clock, an online one on the user's),
// 24-hour, with the zone's abbreviation when it isn't the user's.

tz.Location _zoneFor(Event event, tz.Location userZone) =>
    event.isOnline ? userZone : event.time.location;

CalendarDate _dayIn(DateTime instant, tz.Location zone) =>
    CalendarDate.fromDateTime(tz.TZDateTime.from(instant, zone));

/// "18:30", or "18:30 EDT" away from the user's zone.
String _clock(DateTime instant, tz.Location zone, tz.Location userZone) {
  final local = tz.TZDateTime.from(instant, zone);
  final mine = tz.TZDateTime.from(instant, userZone);
  final time = DateFormat('HH:mm').format(local);
  return local.timeZoneOffset == mine.timeZoneOffset
      ? time
      : '$time ${local.timeZoneName}';
}

/// "Thu 29 Oct at 18:30".
String _when(DateTime instant, tz.Location zone, tz.Location userZone) =>
    '${DateFormat('EEE d MMM').format(tz.TZDateTime.from(instant, zone))} '
    'at ${_clock(instant, zone, userZone)}';

String _place(Event event) => switch (event.location) {
  Venue(:final name) => name,
  Online() => 'Online',
};
