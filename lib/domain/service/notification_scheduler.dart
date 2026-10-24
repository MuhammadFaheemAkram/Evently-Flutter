import 'package:evently/domain/model/planned_notification.dart';

/// The device's notifications. An interface, so the use cases are tested
/// against a fake and no plugin is reachable from a Cubit test.
abstract interface class NotificationScheduler {
  /// Whether notifications are allowed now.
  Future<bool> hasPermission();

  /// Asks for permission if the system still can (Android 13+, iOS); `true`
  /// if notifications are allowed afterwards. Once denied, only the system
  /// settings can change it: the app can't ask twice.
  Future<bool> requestPermission();

  /// What's scheduled and hasn't rung yet.
  Future<List<PendingNotification>> pending();

  /// Schedules [notification] at its instant, replacing any with its id.
  Future<void> schedule(PlannedNotification notification);

  /// Shows [notification] now.
  Future<void> show(InstantNotification notification);

  Future<void> cancel(int id);

  /// Cancels every pending notification (shown ones stay in the shade).
  Future<void> cancelAll();

  /// The app's notification settings, where a denied permission can be
  /// changed.
  Future<void> openSystemSettings();
}

/// Notification taps that reach the running app.
abstract interface class NotificationInteractions {
  /// The tap that launched the app (a cold start), if any.
  Future<NotificationTarget?> launchTarget();

  /// Taps while the app runs (a warm start).
  Stream<NotificationTarget> get taps;
}
