import 'dart:async';

import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;
import 'package:timezone/timezone.dart' as tz;

/// The device's notifications, with `flutter_local_notifications`: the
/// planned ones, the ones shown at once, and taps.
///
/// - **One notification per planned instant**, not repeating ones: the
///   plan already says when each rings (see `planNotifications`). An
///   instant needs no device zone: a reminder an hour before an event
///   rings an hour before it wherever the phone is.
/// - **Inexact on Android:** exact alarms need a permission that is denied
///   by default from Android 14 (granted in the system settings, and
///   reviewed by Google Play for apps that aren't alarm clocks or
///   calendars). Android then picks a delivery window: up to an hour for a
///   reminder set hours ahead (seen on the emulator). Exact alarms where the
///   user grants them are a roadmap item. Scheduled notifications survive a
///   reboot through the plugin's boot receiver (in the manifest).
/// - **Three channels** on Android, so the user can silence one kind (the
///   daily summary, say) and keep the others.
/// - **Taps only:** Evently's notifications have no actions, so nothing
///   runs in a background isolate on a tap; a tap opens the app on the
///   right screen ([launchTarget] on a cold start, [taps] on a warm one).
///
/// Not injectable itself: `AppModule` and the background graph each build
/// one. `main` loads the time-zone database before anything schedules.
class LocalNotifications
    implements NotificationScheduler, NotificationInteractions {
  final _plugin = fln.FlutterLocalNotificationsPlugin();
  final _taps = StreamController<NotificationTarget>.broadcast();
  Future<void>? _initialized;

  /// Sets the plugin up once. Permission isn't requested here: only when
  /// the user turns notifications on, so the system prompt has a reason.
  Future<void> _initialize() => _initialized ??= _plugin.initialize(
    settings: const fln.InitializationSettings(
      android: fln.AndroidInitializationSettings('ic_notification'),
      iOS: fln.DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
    onDidReceiveNotificationResponse: (response) {
      if (NotificationTarget.parse(response.payload) case final target?) {
        _taps.add(target);
      }
    },
  );

  fln.AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin
      >();

  fln.IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        fln.IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Stream<NotificationTarget> get taps {
    unawaited(_initialize());
    return _taps.stream;
  }

  @override
  Future<NotificationTarget?> launchTarget() async {
    await _initialize();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return NotificationTarget.parse(details.notificationResponse?.payload);
  }

  @override
  Future<bool> hasPermission() async {
    await _initialize();
    final android = _android;
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    final options = await _ios?.checkPermissions();
    return options?.isEnabled ?? false;
  }

  @override
  Future<bool> requestPermission() async {
    await _initialize();
    final android = _android;
    if (android != null) {
      // Android 13+ shows the prompt (twice at most); older versions allow
      // by default, unless the user turned notifications off.
      await android.requestNotificationsPermission();
      return hasPermission();
    }
    return await _ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<List<PendingNotification>> pending() async {
    await _initialize();
    return [
      for (final request in await _plugin.pendingNotificationRequests())
        PendingNotification(
          id: request.id,
          title: request.title,
          body: request.body,
          payload: request.payload,
        ),
    ];
  }

  @override
  Future<void> schedule(PlannedNotification notification) async {
    await _initialize();
    final at = tz.TZDateTime.from(notification.at, tz.UTC);
    // The plan dropped past times, but a sync can straddle the moment.
    if (!at.isAfter(tz.TZDateTime.now(tz.UTC))) return;
    await _plugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
      scheduledDate: at,
      notificationDetails: _details(notification.kind),
      androidScheduleMode: fln.AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> show(InstantNotification notification) async {
    await _initialize();
    await _plugin.show(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
      notificationDetails: _details(notification.kind),
    );
  }

  @override
  Future<void> cancel(int id) async {
    await _initialize();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() async {
    await _initialize();
    await _plugin.cancelAllPendingNotifications();
  }

  @override
  Future<void> openSystemSettings() async {
    await _initialize();
    await _plugin.openAppNotificationSettings();
  }

  static fln.NotificationDetails _details(NotificationKind kind) =>
      switch (kind) {
        NotificationKind.reminder => const fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            'event_reminders',
            'Event reminders',
            channelDescription:
                "Before events you're going to, or saved with a reminder",
            importance: fln.Importance.high,
            priority: fln.Priority.high,
          ),
          iOS: fln.DarwinNotificationDetails(),
        ),
        NotificationKind.summary => const fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            'daily_summary',
            'Daily summary',
            channelDescription: "The day's events, in the morning",
          ),
          iOS: fln.DarwinNotificationDetails(),
        ),
        NotificationKind.confirmation ||
        NotificationKind.change => const fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            'bookings',
            'Bookings and changes',
            channelDescription:
                'RSVP confirmations, and events of yours that moved or were '
                'cancelled',
            importance: fln.Importance.high,
            priority: fln.Priority.high,
          ),
          iOS: fln.DarwinNotificationDetails(),
        ),
      };
}
