import 'dart:async';
import 'dart:developer';

import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/common/settled_stream.dart';
import 'package:evently/domain/calculation/notification_plan.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:evently/domain/repository/reminder_repository.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';

/// The plan for now, from the events a reminder can be for and [settings].
Future<List<PlannedNotification>> _plan(
  ReminderRepository reminders,
  AppSettings settings,
  EventClock clock,
) async => planNotifications(
  now: clock.now(),
  items: await reminders.watchRemindable().first,
  settings: settings,
  userZone: clock.local,
);

/// Whether a notification may be shown now: on in Settings, and allowed by
/// the system.
Future<bool> _canNotify(
  SettingsRepository settings,
  NotificationScheduler scheduler,
) async =>
    settings.current.notificationsEnabled && await scheduler.hasPermission();

/// Makes the device's notifications match the plan: plan → compare with
/// what's pending → cancel what's stale, schedule what's new or changed,
/// leave the rest.
///
/// - **Off** (or permission revoked): everything pending is cancelled. A
///   revoked permission also turns the switch off, so it never reads "on"
///   while nothing can ring (correctness rule 11).
/// - **One sync at a time:** calls queue up, so two syncs never interleave
///   their cancels and schedules. A singleton, so the app's watcher, a
///   resume, Settings and the developer tools share the queue.
@lazySingleton
class SyncNotificationsUseCase {
  SyncNotificationsUseCase(
    this._settings,
    this._reminders,
    this._scheduler,
    this._clock,
  );

  final SettingsRepository _settings;
  final ReminderRepository _reminders;
  final NotificationScheduler _scheduler;
  final EventClock _clock;

  Future<void> _queue = Future.value();

  Future<Result<NotificationSyncReport>> call() {
    final run = _queue.then((_) => _sync());
    _queue = run;
    return run;
  }

  Future<Result<NotificationSyncReport>> _sync() async {
    try {
      var settings = _settings.current;
      var revoked = false;
      if (settings.notificationsEnabled && !await _scheduler.hasPermission()) {
        await _settings.update((s) => s.copyWith(notificationsEnabled: false));
        settings = _settings.current;
        revoked = true;
      }
      final pending = await _scheduler.pending();
      if (!settings.notificationsEnabled) {
        if (pending.isNotEmpty) await _scheduler.cancelAll();
        return Ok(
          NotificationSyncReport(
            enabled: false,
            cancelled: pending.length,
            permissionRevoked: revoked,
          ),
        );
      }
      final plan = await _plan(_reminders, settings, _clock);
      final wanted = {for (final n in plan) n.id};
      final pendingById = {for (final p in pending) p.id: p};
      var cancelled = 0;
      for (final stale in pending.where((p) => !wanted.contains(p.id))) {
        await _scheduler.cancel(stale.id);
        cancelled++;
      }
      var scheduled = 0;
      for (final notification in plan) {
        final current = pendingById[notification.id];
        if (current != null && notification.matches(current)) continue;
        // Scheduling an id again replaces it: no cancel first.
        await _scheduler.schedule(notification);
        scheduled++;
      }
      return Ok(
        NotificationSyncReport(
          enabled: true,
          planned: plan.length,
          scheduled: scheduled,
          cancelled: cancelled,
          kept: plan.length - scheduled,
        ),
      );
    } on Object catch (error, stackTrace) {
      log('Syncing notifications failed', error: error, stackTrace: stackTrace);
      return const Err(UnknownException());
    }
  }
}

/// While the app runs: the plan applied again after every change to the
/// events a reminder can be for (a ticket, a save, a toggle, a refresh) and
/// to the settings.
///
/// Debounced ([settle], cancelled with the subscription, conventions
/// §11.63): a write that touches many rows (the demo, a reset,
/// a refresh) syncs once, when it settles. Each sync runs to the end before
/// the next (`asyncMap`). There's no midnight tick: the seven-day window
/// rolls on at every launch, resume and background sync, days before its
/// end could matter.
@injectable
class KeepNotificationsInSyncUseCase {
  const KeepNotificationsInSyncUseCase(
    this._sync,
    this._reminders,
    this._settings, {
    @ignoreParam this.settle = const Duration(milliseconds: 300),
  });

  final SyncNotificationsUseCase _sync;
  final ReminderRepository _reminders;
  final SettingsRepository _settings;
  final Duration settle;

  Stream<Result<NotificationSyncReport>> call() => _reminders
      .watchRemindable()
      .combineLatest(_settings.watch(), (items, settings) => (items, settings))
      .settled(settle)
      .asyncMap((_) => _sync());
}

/// Turns notifications on (asking for permission) or off. `true` when the
/// switch ends up where the user put it; `false` when permission was
/// denied, and it stays off.
@injectable
class SetNotificationsEnabledUseCase {
  const SetNotificationsEnabledUseCase(this._settings, this._scheduler);

  final SettingsRepository _settings;
  final NotificationScheduler _scheduler;

  Future<bool> call({required bool enabled}) async {
    if (enabled) {
      try {
        if (!await _scheduler.requestPermission()) return false;
      } on Object catch (error, stackTrace) {
        log(
          'Asking for permission failed',
          error: error,
          stackTrace: stackTrace,
        );
        return false;
      }
    }
    await _settings.update((s) => s.copyWith(notificationsEnabled: enabled));
    return true;
  }
}

@injectable
class UpdateReminderLeadUseCase {
  const UpdateReminderLeadUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call(ReminderLead lead) =>
      _settings.update((s) => s.copyWith(reminderLead: lead));
}

/// The daily summary on or off, and its time.
@injectable
class UpdateSummaryUseCase {
  const UpdateSummaryUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call({bool? enabled, TimeOfDayValue? time}) => _settings.update(
    (s) => s.copyWith(
      summaryEnabled: enabled ?? s.summaryEnabled,
      summaryTime: time ?? s.summaryTime,
    ),
  );
}

/// Event detail's reminder toggle. Only for an event you're going to or
/// saved (the planner ignores the rest).
@injectable
class SetEventReminderUseCase {
  const SetEventReminderUseCase(this._reminders);

  final ReminderRepository _reminders;

  Future<Result<void>> call(EventCardItem item, {required bool enabled}) {
    if (!item.canHaveReminder) {
      return Future.value(
        const Err(
          InvalidInputException('Save the event or RSVP to get a reminder.'),
        ),
      );
    }
    return _reminders.setReminder(item.event.id, enabled: enabled);
  }
}

/// "You're going": shown at once after a booking, when notifications are
/// on. Never fails the booking: a notification that can't be shown is
/// logged and forgotten.
@injectable
class ShowRsvpConfirmationUseCase {
  const ShowRsvpConfirmationUseCase(
    this._settings,
    this._scheduler,
    this._clock,
  );

  final SettingsRepository _settings;
  final NotificationScheduler _scheduler;
  final EventClock _clock;

  Future<void> call(Ticket ticket, Event event) async {
    try {
      if (!await _canNotify(_settings, _scheduler)) return;
      await _scheduler.show(
        rsvpConfirmation(ticket, event, userZone: _clock.local),
      );
    } on Object catch (error, stackTrace) {
      log(
        'Showing the RSVP confirmation failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Alerts the changes a sync recorded, once each: they are claimed (marked
/// alerted) first, then shown. With notifications off they are claimed all
/// the same, so turning notifications on later doesn't bring back stale
/// news. How many were alerted.
@injectable
class AlertCatalogChangesUseCase {
  const AlertCatalogChangesUseCase(
    this._reminders,
    this._settings,
    this._scheduler,
    this._clock,
  );

  final ReminderRepository _reminders;
  final SettingsRepository _settings;
  final NotificationScheduler _scheduler;
  final EventClock _clock;

  Future<int> call() async {
    try {
      final changes = await _reminders.claimUnalertedChanges();
      if (changes.isEmpty || !await _canNotify(_settings, _scheduler)) {
        return 0;
      }
      for (final change in changes) {
        await _scheduler.show(changeAlert(change, userZone: _clock.local));
      }
      return changes.length;
    } on Object catch (error, stackTrace) {
      log('Alerting changes failed', error: error, stackTrace: stackTrace);
      return 0;
    }
  }
}

/// The plan as it stands, and what the device holds: Settings → Developer.
@injectable
class PreviewNotificationPlanUseCase {
  const PreviewNotificationPlanUseCase(
    this._settings,
    this._reminders,
    this._scheduler,
    this._clock,
  );

  final SettingsRepository _settings;
  final ReminderRepository _reminders;
  final NotificationScheduler _scheduler;
  final EventClock _clock;

  Future<NotificationPlanPreview> call() async {
    final settings = _settings.current;
    return NotificationPlanPreview(
      plan: await _plan(_reminders, settings, _clock),
      pending: (await _scheduler.pending()).length,
      enabled: settings.notificationsEnabled,
    );
  }
}

/// Opens the system settings, where a denied permission can be changed.
@injectable
class OpenNotificationSettingsUseCase {
  const OpenNotificationSettingsUseCase(this._scheduler);

  final NotificationScheduler _scheduler;

  Future<void> call() => _scheduler.openSystemSettings();
}
