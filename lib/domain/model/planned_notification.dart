import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_notification.freezed.dart';

enum NotificationKind {
  /// A lead time before an event you're going to (or saved with the
  /// reminder on).
  reminder('Reminder'),

  /// "Today: Flutter London at 18:30, and 1 more", at the summary time.
  summary('Daily summary'),

  /// "You're going", right after a booking.
  confirmation('RSVP confirmation'),

  /// An event you hold a ticket for moved or was cancelled.
  change('Change alert');

  const NotificationKind(this.label);

  final String label;
}

/// Where a notification's tap leads.
///
/// It travels as the notification's payload text (`event:<id>`,
/// `ticket:<id>` or `tickets`), so it survives the app being killed: a tap
/// that launches the app reads it back with [NotificationTarget.parse].
@freezed
sealed class NotificationTarget with _$NotificationTarget {
  /// An event's page: a reminder.
  const factory NotificationTarget.event(String eventId) = OpenEvent;

  /// A ticket: a confirmation, or a change alert.
  const factory NotificationTarget.ticket(String ticketId) = OpenTicket;

  /// The Tickets tab: the daily summary.
  const factory NotificationTarget.tickets() = OpenTickets;

  const NotificationTarget._();

  /// The target in [payload], or `null` for anything else (a payload from
  /// an older version, or none).
  static NotificationTarget? parse(String? payload) {
    final target = payload?.split(_fingerprintSeparator).first;
    if (target == null) return null;
    if (target == _tickets) return const NotificationTarget.tickets();
    String? idAfter(String prefix) {
      if (!target.startsWith(prefix)) return null;
      final id = target.substring(prefix.length);
      return id.isEmpty ? null : id;
    }

    if (idAfter(_eventPrefix) case final id?) {
      return NotificationTarget.event(id);
    }
    if (idAfter(_ticketPrefix) case final id?) {
      return NotificationTarget.ticket(id);
    }
    return null;
  }

  String encode() => switch (this) {
    OpenEvent(:final eventId) => '$_eventPrefix$eventId',
    OpenTicket(:final ticketId) => '$_ticketPrefix$ticketId',
    OpenTickets() => _tickets,
  };

  static const _eventPrefix = 'event:';
  static const _ticketPrefix = 'ticket:';
  static const _tickets = 'tickets';
}

const _fingerprintSeparator = '#';

/// One notification the app wants scheduled on the device: the planner's
/// output.
@freezed
abstract class PlannedNotification with _$PlannedNotification {
  const factory PlannedNotification({
    /// Stable from one plan to the next for the same kind and event (or
    /// day), so the scheduler can tell what changed (`notificationId`).
    required int id,
    required NotificationKind kind,

    /// When it rings: an instant (UTC). An event's reminder is a lead time
    /// before an instant; the summary's wall-clock time was turned into one
    /// with the user's zone when it was planned, and is planned again if
    /// the zone changes.
    required DateTime at,
    required String title,
    required String body,
    required NotificationTarget target,
  }) = _PlannedNotification;

  const PlannedNotification._();

  /// The payload stored with it: the [target], and the time it rings.
  ///
  /// The device's list of pending notifications gives back an id, a title,
  /// a body and a payload, but not the time. Keeping the time in the
  /// payload lets the sync see that a reminder moved with its event, and
  /// schedule it again.
  String get payload =>
      '${target.encode()}$_fingerprintSeparator'
      '${at.toUtc().toIso8601String()}';
}

/// A notification shown at once, never planned: the RSVP confirmation and
/// the change alerts. Nothing pending on the device stands for it, so no
/// sync ever cancels it.
@freezed
abstract class InstantNotification with _$InstantNotification {
  const factory InstantNotification({
    required int id,
    required NotificationKind kind,
    required String title,
    required String body,
    required NotificationTarget target,
  }) = _InstantNotification;

  const InstantNotification._();

  String get payload => target.encode();
}

/// A notification already on the device, as the system reports it.
@freezed
abstract class PendingNotification with _$PendingNotification {
  const factory PendingNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) = _PendingNotification;
}

extension PlannedNotificationMatch on PlannedNotification {
  /// Whether [pending] is this notification, unchanged.
  bool matches(PendingNotification pending) =>
      pending.id == id &&
      pending.title == title &&
      pending.body == body &&
      pending.payload == payload;
}

/// What a sync did to the device's notifications.
@freezed
abstract class NotificationSyncReport with _$NotificationSyncReport {
  const factory NotificationSyncReport({
    /// Whether notifications are on (and allowed).
    required bool enabled,

    /// The plan's size.
    @Default(0) int planned,
    @Default(0) int scheduled,
    @Default(0) int cancelled,

    /// Already on the device, unchanged: left alone.
    @Default(0) int kept,

    /// The system no longer allows notifications: the switch turned off.
    @Default(false) bool permissionRevoked,
  }) = _NotificationSyncReport;
}

/// The plan as Settings → Developer shows it.
@freezed
abstract class NotificationPlanPreview with _$NotificationPlanPreview {
  const factory NotificationPlanPreview({
    /// What the planner wants now (planned even while notifications are
    /// off, so it can be inspected).
    required List<PlannedNotification> plan,

    /// How many are pending on the device.
    required int pending,
    required bool enabled,
  }) = _NotificationPlanPreview;
}
