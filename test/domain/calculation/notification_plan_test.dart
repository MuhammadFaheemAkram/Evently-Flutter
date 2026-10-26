import 'package:evently/domain/calculation/notification_plan.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_change.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/test_dependencies.dart';
import '../../helpers/user_data_fixtures.dart';

// "Now" is Wednesday 21 October 2026, 15:00 in London (14:00 UTC). London
// leaves summer time on Sunday the 25th.
void main() {
  final london = tz.getLocation('Europe/London');
  const settings = AppSettings(notificationsEnabled: true);

  List<PlannedNotification> plan(
    List<EventCardItem> items, {
    AppSettings settings = settings,
    DateTime? now,
    tz.Location? userZone,
    int limit = maxPlannedNotifications,
  }) => planNotifications(
    now: now ?? demoNow,
    items: items,
    settings: settings,
    userZone: userZone ?? london,
    limit: limit,
  );

  List<PlannedNotification> reminders(Iterable<PlannedNotification> plan) => [
    for (final n in plan)
      if (n.kind == NotificationKind.reminder) n,
  ];

  List<PlannedNotification> summaries(Iterable<PlannedNotification> plan) => [
    for (final n in plan)
      if (n.kind == NotificationKind.summary) n,
  ];

  /// An event [start]ing (UTC) and lasting two hours, in London.
  Event at(DateTime start, {String id = 'ev_1', String title = 'An event'}) =>
      event(
        id: id,
        title: title,
        time: EventTime(
          start: start,
          end: start.add(const Duration(hours: 2)),
          zone: 'Europe/London',
        ),
      );

  // Saturday 24 October, 18:30 in London (17:30 UTC).
  final saturday = event();
  final noSummary = settings.copyWith(summaryEnabled: false);

  group('reminders', () {
    test('the lead time before an event you are going to, to its '
        'page', () {
      final reminder = plan([
        card(saturday, isGoing: true),
      ], settings: noSummary).single;

      expect(reminder.kind, NotificationKind.reminder);
      expect(reminder.at, DateTime.utc(2026, 10, 24, 16, 30));
      expect(reminder.title, 'An event');
      expect(reminder.body, 'Starts in 1 hour, at 18:30 · Hall');
      expect(reminder.target, const NotificationTarget.event('ev_1'));
      expect(reminder.id, notificationId(NotificationKind.reminder, 'ev_1'));
    });

    test('every lead time', () {
      for (final lead in ReminderLead.values) {
        final reminder = plan([
          card(saturday, isGoing: true),
        ], settings: noSummary.copyWith(reminderLead: lead)).single;
        expect(
          reminder.at,
          DateTime.utc(2026, 10, 24, 17, 30).subtract(lead.duration),
          reason: lead.name,
        );
        expect(reminder.body, startsWith('Starts in ${lead.label}, '));
      }
    });

    test('going: on unless turned off; saved: off unless turned on', () {
      expect(plan([card(saturday, isGoing: true)], settings: noSummary), [
        isA<PlannedNotification>(),
      ]);
      expect(
        plan([
          card(saturday, isGoing: true, reminderChoice: false),
        ], settings: noSummary),
        isEmpty,
      );
      expect(
        plan([card(saturday, isSaved: true)], settings: noSummary),
        isEmpty,
      );
      expect(
        plan([
          card(saturday, isSaved: true, reminderChoice: true),
        ], settings: noSummary),
        hasLength(1),
      );
      // A choice left behind on an event no longer saved or booked.
      expect(
        plan([card(saturday, reminderChoice: true)], settings: noSummary),
        isEmpty,
      );
    });

    test('none for a cancelled event, in reminders or the summary', () {
      final cancelled = event(status: EventStatus.cancelled);

      expect(plan([card(cancelled, isGoing: true)]), isEmpty);
    });

    test('a moved event is reminded at its new time', () {
      final moved = at(DateTime.utc(2026, 10, 25, 18, 30))
          .copyWith(status: EventStatus.moved);

      expect(
        reminders(plan([card(moved, isGoing: true)])).single.at,
        DateTime.utc(2026, 10, 25, 17, 30),
      );
    });

    test('past times are dropped: a lead time already gone, an event '
        'over', () {
      // Starts in 30 minutes: an hour before was half an hour ago.
      final soon = at(demoNow.add(const Duration(minutes: 30)));
      final over = at(DateTime.utc(2026, 10, 20, 18), id: 'ev_2');

      expect(
        plan([
          card(soon, isGoing: true),
          card(over, isGoing: true),
        ], settings: noSummary),
        isEmpty,
      );
      // One minute later than the lead time still rings.
      final justInTime = at(demoNow.add(const Duration(hours: 1, minutes: 1)));
      expect(
        plan([card(justInTime, isGoing: true)], settings: noSummary),
        hasLength(1),
      );
    });

    test('the seven-day horizon: up to and including its last moment', () {
      final edge = at(demoNow.add(const Duration(days: 7, hours: 1)));
      final beyond = at(
        demoNow.add(const Duration(days: 7, hours: 1, minutes: 1)),
        id: 'ev_2',
      );

      final planned = plan([
        card(edge, isGoing: true),
        card(beyond, isGoing: true),
      ], settings: noSummary);

      expect(planned.single.target, const NotificationTarget.event('ev_1'));
    });

    test('times are the venue\'s, with its zone when it isn\'t yours; '
        'online events are on your clock', () {
      final newYork = event(
        id: 'ev_ny',
        location: venueIn('New York'),
        time: EventTime(
          start: DateTime.utc(2026, 10, 24, 22, 30),
          end: DateTime.utc(2026, 10, 25, 1),
          zone: 'America/New_York',
        ),
      );
      final online = event(
        id: 'ev_online',
        location: onlineAt('https://meet.example.com/x'),
        time: EventTime(
          start: DateTime.utc(2026, 10, 24, 22, 30),
          end: DateTime.utc(2026, 10, 25, 1),
          zone: 'America/New_York',
        ),
      );

      final bodies = {
        for (final n in plan([
          card(newYork, isGoing: true),
          card(online, isGoing: true),
        ], settings: noSummary))
          n.target: n.body,
      };

      expect(
        bodies[const NotificationTarget.event('ev_ny')],
        'Starts in 1 hour, at 18:30 EDT · Hall',
      );
      expect(
        bodies[const NotificationTarget.event('ev_online')],
        'Starts in 1 hour, at 23:30 · Online',
      );
    });
  });

  group('the daily summary', () {
    test('at the summary time on a day with events you are going to, to '
        'Tickets', () {
      final summary = summaries(plan([card(saturday, isGoing: true)])).single;

      // 08:00 in London, still summer time: 07:00 UTC.
      expect(summary.at, DateTime.utc(2026, 10, 24, 7));
      expect(summary.title, 'Today');
      expect(summary.body, 'An event at 18:30');
      expect(summary.target, const NotificationTarget.tickets());
      expect(summary.id, notificationId(NotificationKind.summary, '20261024'));
    });

    test('after the clocks go back, 08:00 is 08:00 UTC', () {
      // Monday 26 October, 18:30 in London: GMT now.
      final monday = at(DateTime.utc(2026, 10, 26, 18, 30));

      final summary = summaries(plan([card(monday, isGoing: true)])).single;

      expect(summary.at, DateTime.utc(2026, 10, 26, 8));
      expect(summary.body, 'An event at 18:30');
    });

    test('several events: the first, and how many more', () {
      final morning = at(DateTime.utc(2026, 10, 24, 9), title: 'Morning');
      final evening = event(id: 'ev_2', title: 'Evening');
      final late = at(
        DateTime.utc(2026, 10, 24, 20),
        id: 'ev_3',
        title: 'Late',
      );

      expect(
        summaries(
          plan([
            card(evening, isGoing: true),
            card(late, isGoing: true),
            card(morning, isGoing: true),
          ]),
        ).single.body,
        'Morning at 10:00, and 2 more',
      );
      expect(
        summaries(
          plan([card(evening, isGoing: true), card(morning, isGoing: true)]),
        ).single.body,
        'Morning at 10:00, and 1 more',
      );
    });

    test('only events you are going to, still on by the summary time', () {
      // Over at 07:00, before the 08:00 summary.
      final dawn = at(DateTime.utc(2026, 10, 24, 4), title: 'Dawn');
      // Started at 06:00, still on at 08:00.
      final allDay = event(
        id: 'ev_2',
        title: 'All day',
        time: EventTime(
          start: DateTime.utc(2026, 10, 24, 5),
          end: DateTime.utc(2026, 10, 24, 16),
          zone: 'Europe/London',
        ),
      );

      expect(
        summaries(
          plan([
            card(dawn, isGoing: true),
            card(event(id: 'ev_3'), isSaved: true, reminderChoice: true),
          ]),
        ),
        isEmpty,
      );
      expect(
        summaries(plan([card(allDay, isGoing: true)])).single.body,
        'All day at 06:00',
      );
    });

    test('the day is yours: 03:00 on Saturday in London is Friday '
        'evening in New York', () {
      final nightOwl = event(
        time: EventTime(
          start: DateTime.utc(2026, 10, 24, 2),
          end: DateTime.utc(2026, 10, 24, 4),
          zone: 'Europe/London',
        ),
      );

      final summary = summaries(
        plan([
          card(nightOwl, isGoing: true),
        ], userZone: tz.getLocation('America/New_York')),
      ).single;

      // 08:00 on Friday in New York (EDT): 12:00 UTC.
      expect(summary.at, DateTime.utc(2026, 10, 23, 12));
      expect(summary.body, 'An event at 03:00 BST');
    });

    test("today's summary time has passed: today gets none", () {
      final tonight = at(DateTime.utc(2026, 10, 21, 18));

      expect(summaries(plan([card(tonight, isGoing: true)])), isEmpty);
      // Before 08:00, today's comes.
      expect(
        summaries(
          plan([
            card(tonight, isGoing: true),
          ], now: DateTime.utc(2026, 10, 21, 6)),
        ).single.at,
        DateTime.utc(2026, 10, 21, 7),
      );
    });

    test('its own time, or none when it is off', () {
      final early = settings.copyWith(summaryTime: TimeOfDayValue(7, 15));

      expect(
        summaries(plan([card(saturday, isGoing: true)], settings: early))
            .single
            .at,
        DateTime.utc(2026, 10, 24, 6, 15),
      );
      expect(
        summaries(plan([card(saturday, isGoing: true)], settings: noSummary)),
        isEmpty,
      );
    });
  });

  group('the plan', () {
    test('soonest first, at most the limit', () {
      final many = [
        for (var day = 1; day <= 6; day++)
          for (var hour = 9; hour < 21; hour++)
            card(
              at(DateTime.utc(2026, 10, 21 + day, hour), id: 'ev_${day}_$hour'),
              isGoing: true,
            ),
      ];

      final planned = plan(many);

      expect(planned, hasLength(maxPlannedNotifications));
      for (var i = 1; i < planned.length; i++) {
        expect(planned[i].at.isBefore(planned[i - 1].at), isFalse);
      }
      expect(plan(many, limit: 3), planned.take(3));
    });

    test('ids are stable: the same event keeps its id when it moves; the '
        'payload says when it rings', () {
      final before = reminders(plan([card(saturday, isGoing: true)])).single;
      final moved = reminders(
        plan([
          card(
            saturday.copyWith(
              time: saturday.time.copyWith(
                start: DateTime.utc(2026, 10, 25, 18, 30),
                end: DateTime.utc(2026, 10, 25, 21),
              ),
            ),
            isGoing: true,
          ),
        ]),
      ).single;

      expect(moved.id, before.id);
      expect(before.payload, 'event:ev_1#2026-10-24T16:30:00.000Z');
      expect(moved.payload, isNot(before.payload));
    });

    test('ids are positive 32-bit integers, distinct across kinds', () {
      final ids = {
        for (final kind in NotificationKind.values)
          notificationId(kind, 'ev_1'),
      };

      expect(ids, hasLength(NotificationKind.values.length));
      expect(ids.every((id) => id >= 0 && id <= 0x7fffffff), isTrue);
      expect(
        notificationId(NotificationKind.reminder, 'ev_1'),
        notificationId(NotificationKind.reminder, 'ev_1'),
      );
    });
  });

  group('shown at once', () {
    test('the RSVP confirmation opens the ticket', () {
      final confirmation = rsvpConfirmation(
        ticket(id: 'tkt_1', code: 'EVT-H4TW-8RCU'),
        saturday,
        userZone: london,
      );

      expect(confirmation.title, "You're going to An event");
      expect(confirmation.body, 'Sat 24 Oct at 18:30 · Free · EVT-H4TW-8RCU');
      expect(confirmation.target, const NotificationTarget.ticket('tkt_1'));
      expect(confirmation.kind, NotificationKind.confirmation);
    });

    test('a move says when, and when it was', () {
      final alert = changeAlert(
        EventChange(
          id: 7,
          kind: EventChangeKind.moved,
          event: at(DateTime.utc(2026, 10, 25, 18, 30)).copyWith(
            status: EventStatus.moved,
            previousStart: DateTime.utc(2026, 10, 24, 17, 30),
          ),
          ticketId: 'tkt_1',
        ),
        userZone: london,
      );

      expect(alert.title, 'An event has moved');
      expect(
        alert.body,
        'Now Sun 25 Oct at 18:30 (was Sat 24 Oct at 18:30). Your ticket '
        'still stands.',
      );
      expect(alert.target, const NotificationTarget.ticket('tkt_1'));
      expect(alert.id, notificationId(NotificationKind.change, '7'));
    });

    test('a cancellation; with no active ticket, the tap opens the '
        'event', () {
      final alert = changeAlert(
        EventChange(
          id: 8,
          kind: EventChangeKind.cancelled,
          event: saturday.copyWith(status: EventStatus.cancelled),
        ),
        userZone: london,
      );

      expect(alert.title, 'An event is cancelled');
      expect(
        alert.body,
        'The organizer called it off. Your ticket shows the details.',
      );
      expect(alert.target, const NotificationTarget.event('ev_1'));
    });
  });

  group('targets', () {
    test('travel as payload text and come back', () {
      for (final target in const [
        NotificationTarget.event('ev_1'),
        NotificationTarget.ticket('tkt_1'),
        NotificationTarget.tickets(),
      ]) {
        expect(NotificationTarget.parse(target.encode()), target);
        expect(
          NotificationTarget.parse('${target.encode()}#2026-10-24T16:30Z'),
          target,
        );
      }
    });

    test('anything else is no target', () {
      for (final payload in [null, '', 'event:', 'ticket:', 'habit:h1', 'x']) {
        expect(NotificationTarget.parse(payload), isNull, reason: payload);
      }
    });
  });
}
