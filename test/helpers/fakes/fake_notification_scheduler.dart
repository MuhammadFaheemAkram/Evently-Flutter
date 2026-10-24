import 'dart:async';

import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/service/notification_scheduler.dart';

/// The device's notifications in memory: what's pending, what was shown,
/// the permission, and a log of every call, in order (`schedule 123`,
/// `show 45`, `cancel 67`, `cancelAll`, `request`, `openSettings`).
///
/// [tap] plays the user's side.
class FakeNotificationScheduler
    implements NotificationScheduler, NotificationInteractions {
  FakeNotificationScheduler({
    this.permitted = false,
    this.grantsWhenAsked = true,
    this.launch,
  });

  /// Whether notifications are allowed now.
  bool permitted;

  /// What the system prompt answers.
  bool grantsWhenAsked;

  /// The tap that launched the app.
  NotificationTarget? launch;

  final pendingById = <int, PendingNotification>{};
  final scheduled = <int, PlannedNotification>{};
  final shown = <InstantNotification>[];
  final calls = <String>[];
  final _taps = StreamController<NotificationTarget>.broadcast(sync: true);

  void tap(NotificationTarget target) => _taps.add(target);

  @override
  Future<bool> hasPermission() async => permitted;

  @override
  Future<bool> requestPermission() async {
    calls.add('request');
    if (grantsWhenAsked) permitted = true;
    return permitted;
  }

  @override
  Future<List<PendingNotification>> pending() async => [...pendingById.values];

  @override
  Future<void> schedule(PlannedNotification notification) async {
    calls.add('schedule ${notification.id}');
    scheduled[notification.id] = notification;
    pendingById[notification.id] = PendingNotification(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
    );
  }

  @override
  Future<void> show(InstantNotification notification) async {
    calls.add('show ${notification.id}');
    shown.add(notification);
  }

  @override
  Future<void> cancel(int id) async {
    calls.add('cancel $id');
    scheduled.remove(id);
    pendingById.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    calls.add('cancelAll');
    scheduled.clear();
    pendingById.clear();
  }

  @override
  Future<void> openSystemSettings() async => calls.add('openSettings');

  @override
  Future<NotificationTarget?> launchTarget() async => launch;

  @override
  Stream<NotificationTarget> get taps => _taps.stream;
}
