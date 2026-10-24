import 'package:evently/app/evently_app.dart';
import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/calculation/notification_plan.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes/fake_notification_scheduler.dart';

// Notifications on the real DI graph, with the demo loaded (as of
// Wednesday 21 October, 15:00 in London), and a fake device.
void main() {
  tearDown(getIt.reset);

  const notificationsOn = {'settings.notificationsEnabled': true};

  int reminderFor(String eventId) =>
      notificationId(NotificationKind.reminder, eventId);

  /// The device's notifications, allowed already.
  FakeNotificationScheduler allowed() =>
      FakeNotificationScheduler(permitted: true);

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tapAndSettle(destination('Profile'));
    await tester.tapAndSettle(find.byTooltip('Settings'));
  }

  Future<void> tapInSettings(WidgetTester tester, String label) async {
    await tester.scrollUntilVisible(find.text(label), 300);
    await tester.ensureVisible(find.text(label));
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.text(label));
  }

  testWidgets('turned on in Settings: the system asks, and the reminders '
      'are scheduled', (tester) async {
    final device = FakeNotificationScheduler();
    await pumpEvently(tester, withDemo: true, notifications: device);
    await openSettings(tester);
    expect(device.scheduled, isEmpty);

    await tester.tapAndSettle(find.text('Notifications').last);
    await tester.settleRealAsync();
    await tester.settleRealAsync();

    expect(device.calls.first, 'request');
    expect(find.text('Reminder lead time'), findsOneWidget);
    // Tonight's meetup, an hour before.
    expect(
      device.scheduled.keys,
      contains(reminderFor('ev_flutter_london_meetup')),
    );
  });

  testWidgets('denied: off, and a card to the system settings', (tester) async {
    final device = FakeNotificationScheduler(grantsWhenAsked: false);
    await pumpEvently(tester, withDemo: true, notifications: device);
    await openSettings(tester);

    await tester.tapAndSettle(find.text('Notifications').last);
    await tester.pumpUntilFound(find.text('Open settings'));
    await tester.tapAndSettle(find.text('Open settings'));

    expect(device.calls, ['request', 'openSettings']);
    expect(device.scheduled, isEmpty);
  });

  testWidgets("a saved event's reminder, turned on from its page", (
    tester,
  ) async {
    final device = allowed();
    await pumpEvently(
      tester,
      withDemo: true,
      preferences: notificationsOn,
      notifications: device,
      initialLocation: '/events/ev_jazz_vaults',
    );
    await tester.pumpUntilFound(find.byType(ReminderToggle));
    expect(
      device.scheduled.keys,
      isNot(contains(reminderFor('ev_jazz_vaults'))),
    );

    await tester.ensureVisible(find.byType(ReminderToggle));
    await tester.tapAndSettle(find.byType(ReminderToggle));
    await tester.settleRealAsync();
    await tester.settleRealAsync();

    expect(find.text('1 hour before it starts'), findsOneWidget);
    expect(device.scheduled.keys, contains(reminderFor('ev_jazz_vaults')));
  });

  testWidgets('RSVP: the confirmation, which opens the ticket', (tester) async {
    final device = allowed();
    await pumpEvently(
      tester,
      withDemo: true,
      preferences: notificationsOn,
      notifications: device,
      initialLocation: '/events/ev_jazz_vaults',
    );
    await tester.pumpUntilFound(appBarTitled('Event'));
    final rsvp = find.widgetWithText(FilledButton, 'RSVP');
    await tester.ensureVisible(rsvp);
    await tester.pumpAndSettle();
    await tester.tap(rsvp);
    final vip = find.widgetWithText(RadioListTile<TicketType>, 'VIP');
    await tester.pumpUntilFound(vip);
    await tester.tap(vip);
    await tester.pump();
    await tester.ensureVisible(find.text('Confirm · £45'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm · £45'));
    await tester.pumpUntilFound(appBarTitled('Ticket'));

    final confirmation = device.shown.single;
    expect(confirmation.title, "You're going to Late Jazz at the Vaults");
    expect(confirmation.target, isA<OpenTicket>());
  });

  testWidgets('a catalog update, synced now: alerted once, and the alert '
      'opens the moved ticket', (tester) async {
    final device = allowed();
    await pumpEvently(
      tester,
      withDemo: true,
      preferences: notificationsOn,
      notifications: device,
    );
    await openSettings(tester);
    await tapInSettings(tester, 'Publish a catalog update');
    await tester.pumpUntilFound(find.textContaining('Published:'));

    await tapInSettings(tester, 'Run background sync now');
    await tester.pumpUntilFound(find.textContaining('Synced.'));
    expect(find.textContaining('2 change alerts.'), findsOneWidget);

    await tapInSettings(tester, 'Run background sync now');
    await tester.pumpUntilFound(find.textContaining('No change alerts.'));
    expect(device.shown, hasLength(2));

    final moved = device.shown.firstWhere((n) => n.title.endsWith('has moved'));
    device.tap(moved.target);
    await tester.pumpUntilFound(appBarTitled('Ticket'));
    expect(find.text('Moved'), findsWidgets);
    // Pushed: Back returns to Settings.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(appBarTitled('Settings'), findsOneWidget);
  });

  testWidgets('a reminder tapped while the app runs opens the event; Back '
      'returns', (tester) async {
    final device = allowed();
    await pumpEvently(tester, withDemo: true, notifications: device);

    device.tap(const NotificationTarget.event('ev_jazz_vaults'));
    await tester.pumpUntilFound(appBarTitled('Event'));
    expect(find.text('Late Jazz at the Vaults'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(appBarTitled('Discover'), findsOneWidget);
  });

  testWidgets('the summary tapped opens Tickets', (tester) async {
    final device = allowed();
    await pumpEvently(tester, withDemo: true, notifications: device);

    device.tap(const NotificationTarget.tickets());
    await tester.pumpAndSettle();

    expect(appBarTitled('Tickets'), findsOneWidget);
  });

  testWidgets('a cold start from a change alert opens on the ticket', (
    tester,
  ) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: EventlyApp.locationFor(
        const NotificationTarget.ticket('tkt_demo_design_conf'),
      ),
    );

    await tester.pumpUntilFound(appBarTitled('Ticket'));
    expect(find.text('EVT-H4TW-8RCU'), findsOneWidget);
  });

  test('cold-start locations for every target', () {
    expect(
      EventlyApp.locationFor(const NotificationTarget.event('ev_1')),
      '/events/ev_1',
    );
    expect(
      EventlyApp.locationFor(const NotificationTarget.ticket('t1')),
      '/tickets/t1',
    );
    expect(
      EventlyApp.locationFor(const NotificationTarget.tickets()),
      '/tickets',
    );
    expect(EventlyApp.locationFor(null), isNull);
  });

  testWidgets('permission revoked while away: on resume the switch reads '
      'off, and nothing stays scheduled', (tester) async {
    final device = allowed();
    await pumpEvently(
      tester,
      withDemo: true,
      preferences: notificationsOn,
      notifications: device,
    );
    await tester.settleRealAsync();
    await tester.settleRealAsync();
    expect(device.scheduled, isNotEmpty);
    await openSettings(tester);
    expect(find.text('Reminder lead time'), findsOneWidget);

    device.permitted = false;
    // Away and back, one step at a time, as the system reports it.
    for (final state in const [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.settleRealAsync();
    await tester.settleRealAsync();

    expect(device.scheduled, isEmpty);
    expect(find.text('Reminder lead time'), findsNothing);
  });
}
