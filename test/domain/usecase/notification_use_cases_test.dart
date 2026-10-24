import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/notification_plan.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/fake_notification_scheduler.dart';
import '../../helpers/result_matchers.dart';

/// A device whose notifications can't be shown.
class _BrokenScheduler extends FakeNotificationScheduler {
  _BrokenScheduler() : super(permitted: true);

  @override
  Future<void> show(InstantNotification notification) =>
      Future.error(StateError('no notification service'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;
  late FakeNotificationScheduler device;

  /// The demo, with notifications on and allowed.
  Future<void> demoWithNotifications({bool on = true}) async {
    stack = DataStack();
    addTearDown(stack.close);
    device = stack.notifications..permitted = on;
    await stack.loadDemo();
    await stack.settings.update((s) => s.copyWith(notificationsEnabled: on));
  }

  NotificationSyncReport synced(Result<NotificationSyncReport> result) =>
      (result as Ok<NotificationSyncReport>).value;

  int reminderFor(String eventId) =>
      notificationId(NotificationKind.reminder, eventId);

  group('SyncNotifications: plan, diff, apply', () {
    test('on: the plan is scheduled, the same as the planner makes '
        'it', () async {
      await demoWithNotifications();

      final report = synced(await stack.syncNotifications());

      final expected = planNotifications(
        now: stack.eventClock.now(),
        items: await stack.reminders.watchRemindable().first,
        settings: stack.settings.current,
        userZone: stack.eventClock.local,
      );
      expect(expected, isNotEmpty);
      expect(device.scheduled.values, unorderedEquals(expected));
      expect(report.enabled, isTrue);
      expect(report.planned, expected.length);
      expect(report.scheduled, expected.length);
      expect(report.kept, 0);
      // The demo is going to the Flutter London meetup this week.
      expect(
        device.scheduled.keys,
        contains(reminderFor('ev_flutter_london_meetup')),
      );
    });

    test('nothing changed: everything kept, no calls', () async {
      await demoWithNotifications();
      await stack.syncNotifications();
      device.calls.clear();

      final report = synced(await stack.syncNotifications());

      expect(device.calls, isEmpty);
      expect(report.kept, report.planned);
      expect(report.scheduled, 0);
    });

    test('a reminder turned off is cancelled; the rest stay', () async {
      await demoWithNotifications();
      await stack.syncNotifications();
      device.calls.clear();
      final meetup = (await stack.reminders.watchRemindable().first).firstWhere(
        (i) => i.event.id == 'ev_flutter_london_meetup',
      );

      await stack.setEventReminder(meetup, enabled: false);
      final report = synced(await stack.syncNotifications());

      expect(device.calls, [
        'cancel ${reminderFor('ev_flutter_london_meetup')}',
      ]);
      expect(report.cancelled, 1);
    });

    test('a new lead time moves the reminders (same ids) and drops one '
        'now past; the summary stays', () async {
      await demoWithNotifications();
      await stack.syncNotifications();
      device.calls.clear();
      final meetup = reminderFor('ev_flutter_london_meetup');
      final dart = reminderFor('ev_dart_patterns_live');

      await stack.updateReminderLead(ReminderLead.oneDay);
      final report = synced(await stack.syncNotifications());

      // The meetup is tonight: a day before was yesterday.
      expect(
        device.calls,
        unorderedEquals(['cancel $meetup', 'schedule $dart']),
      );
      // Dart Patterns Live: tomorrow 19:00 in London, a day before.
      expect(device.scheduled[dart]!.at, DateTime.utc(2026, 10, 21, 18));
      expect(report.kept, 1);
    });

    test('a stale pending notification (an older plan) is cancelled', () async {
      await demoWithNotifications();
      device.pendingById[42] = const PendingNotification(id: 42, title: 'Old');

      final report = synced(await stack.syncNotifications());

      expect(device.calls.first, 'cancel 42');
      expect(device.pendingById, isNot(contains(42)));
      expect(report.cancelled, 1);
    });

    test('off: whatever is pending is cancelled, nothing planned', () async {
      await demoWithNotifications(on: false);
      device.pendingById[42] = const PendingNotification(id: 42);

      final report = synced(await stack.syncNotifications());

      expect(device.calls, ['cancelAll']);
      expect(report.enabled, isFalse);
      expect(report.cancelled, 1);
      expect(report.permissionRevoked, isFalse);
    });

    test('permission revoked in the system settings: the switch turns off, '
        'and everything is cancelled', () async {
      await demoWithNotifications();
      await stack.syncNotifications();
      device.permitted = false;

      final report = synced(await stack.syncNotifications());

      expect(report.permissionRevoked, isTrue);
      expect(report.enabled, isFalse);
      expect(stack.settings.current.notificationsEnabled, isFalse);
      expect(device.pendingById, isEmpty);
    });

    test('two syncs at once run one after the other', () async {
      await demoWithNotifications();

      final (first, second) = await (
        stack.syncNotifications(),
        stack.syncNotifications(),
      ).wait;

      expect(synced(first).scheduled, synced(first).planned);
      expect(synced(second).scheduled, 0);
      expect(synced(second).kept, synced(first).planned);
    });
  });

  group('the switch', () {
    test('turning on asks; allowed, it is on', () async {
      await demoWithNotifications(on: false);
      device.grantsWhenAsked = true;

      expect(await stack.setNotificationsEnabled(enabled: true), isTrue);

      expect(device.calls, ['request']);
      expect(stack.settings.current.notificationsEnabled, isTrue);
    });

    test('denied: it stays off', () async {
      await demoWithNotifications(on: false);
      device.grantsWhenAsked = false;

      expect(await stack.setNotificationsEnabled(enabled: true), isFalse);

      expect(stack.settings.current.notificationsEnabled, isFalse);
    });

    test('turning off asks nothing', () async {
      await demoWithNotifications();

      expect(await stack.setNotificationsEnabled(enabled: false), isTrue);

      expect(device.calls, isEmpty);
      expect(stack.settings.current.notificationsEnabled, isFalse);
    });

    test('the summary and the lead time are saved', () async {
      await demoWithNotifications();

      await stack.updateSummary(enabled: false);
      await stack.updateReminderLead(ReminderLead.fifteenMinutes);

      expect(stack.settings.current.summaryEnabled, isFalse);
      expect(stack.settings.current.reminderLead, ReminderLead.fifteenMinutes);
    });

    test('the system settings open for a denied permission', () async {
      await demoWithNotifications(on: false);

      await stack.openNotificationSettings();

      expect(device.calls, ['openSettings']);
    });
  });

  group('change alerts', () {
    Future<void> updatePublishedAndSynced() async {
      await stack.server.publishUpdate();
      await stack.catalog.refresh();
    }

    test('each recorded change is alerted once, opening its ticket', () async {
      await demoWithNotifications();
      await updatePublishedAndSynced();

      expect(await stack.alertChanges(), 2);
      expect(await stack.alertChanges(), 0);

      expect(
        [for (final n in device.shown) n.title],
        [
          'Form & Function: Berlin Design Conference has moved',
          'Dart 3 Patterns Live Coding is cancelled',
        ],
      );
      expect(device.shown.every((n) => n.target is OpenTicket), isTrue);
    });

    test('with notifications off they are claimed all the same: no stale '
        'news when they are turned on', () async {
      await demoWithNotifications(on: false);
      await updatePublishedAndSynced();

      expect(await stack.alertChanges(), 0);
      device.permitted = true;
      await stack.settings.update(
        (s) => s.copyWith(notificationsEnabled: true),
      );

      expect(await stack.alertChanges(), 0);
      expect(device.shown, isEmpty);
    });

    test('a refresh alerts what it recorded, at once', () async {
      await demoWithNotifications();
      await stack.server.publishUpdate();

      expect(await stack.refreshCatalog(), isOk(27));

      expect(device.shown, hasLength(2));
    });
  });

  group('the RSVP confirmation', () {
    Future<String> bookable() async => (await stack.watchEventCards().first)
        .firstWhere(
          (i) =>
              !i.isGoing &&
              !i.event.isSoldOut &&
              i.event.status == EventStatus.scheduled &&
              !i.event.time.hasStarted(stack.eventClock.now()),
        )
        .event
        .id;

    test('shown once the server confirms, opening the ticket', () async {
      await demoWithNotifications();
      final eventId = await bookable();
      final offer = (await stack.watchEventDetails(eventId).first)!
          .item
          .event
          .offers
          .first;

      final result = await stack.rsvpEvent(eventId, type: offer.type);

      final ticket = (result as Ok<Ticket>).value;
      expect(device.shown.single.kind, NotificationKind.confirmation);
      expect(device.shown.single.title, startsWith("You're going to "));
      expect(device.shown.single.target, NotificationTarget.ticket(ticket.id));
    });

    test('not with notifications off, nor when the booking fails', () async {
      await demoWithNotifications(on: false);
      final eventId = await bookable();
      final offer = (await stack.watchEventDetails(eventId).first)!
          .item
          .event
          .offers
          .first;

      expect(await stack.rsvpEvent(eventId, type: offer.type), isOk());
      expect(device.shown, isEmpty);

      device.permitted = true;
      await stack.settings.update(
        (s) => s.copyWith(notificationsEnabled: true),
      );
      stack.network.failRequests = true;
      final other = await bookable();
      expect(
        await stack.rsvpEvent(other, type: offer.type),
        isA<Err<Object?>>(),
      );
      expect(device.shown, isEmpty);
    });

    test(
      "a confirmation that can't be shown doesn't fail the booking",
      () async {
        await demoWithNotifications();
        final broken = _BrokenScheduler();
        final confirm = ShowRsvpConfirmationUseCase(
          stack.settings,
          broken,
          stack.eventClock,
        );
        final eventId = await bookable();
        final event =
            (await stack.watchEventDetails(eventId).first)!.item.event;
        final ticket = (await stack.booking.rsvp(
          eventId,
          type: event.offers.first.type,
        ) as Ok<Ticket>).value;

        await expectLater(confirm(ticket, event), completes);
      },
    );
  });

  group('the background sync', () {
    test('refresh, alert, re-plan', () async {
      await demoWithNotifications();
      await stack.server.publishUpdate();

      final report = await stack.runBackgroundSync();

      expect(report.refresh, isOk(27));
      expect(report.alerted, 2);
      expect(synced(report.notifications).planned, greaterThan(0));
      expect(device.scheduled, isNotEmpty);
    });

    test('offline: the refresh fails, but changes recorded earlier are '
        'alerted and the plan still rolls on', () async {
      await demoWithNotifications();
      await stack.server.publishUpdate();
      await stack.catalog.refresh();
      stack.network.failRequests = true;

      final report = await stack.runBackgroundSync();

      expect(report.refresh, isA<Err<int>>());
      expect(report.alerted, 2);
      expect(synced(report.notifications).enabled, isTrue);
    });

    test(
      "a cancelled event's reminder goes; so does its day's summary",
      () async {
        await demoWithNotifications();
        await stack.syncNotifications();
        final dart = reminderFor('ev_dart_patterns_live');
        final thursday = notificationId(NotificationKind.summary, '20261022');
        expect(device.scheduled.keys, containsAll([dart, thursday]));
        await stack.server.publishUpdate();

        await stack.runBackgroundSync();

        expect(device.scheduled.keys, isNot(contains(dart)));
        expect(device.scheduled.keys, isNot(contains(thursday)));
        expect(
          device.scheduled.keys,
          contains(reminderFor('ev_flutter_london_meetup')),
        );
      },
    );
  });

  test('keeping in sync: a change to the data syncs again', () async {
    await demoWithNotifications();
    final keep = KeepNotificationsInSyncUseCase(
      stack.syncNotifications,
      stack.reminders,
      stack.settings,
      settle: Duration.zero,
    );
    final reports = <NotificationSyncReport>[];
    final subscription = keep().listen((r) => reports.add(synced(r)));
    addTearDown(subscription.cancel);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(reports, hasLength(1));

    await stack.updateSummary(enabled: false);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(reports, hasLength(2));
    expect(reports.last.cancelled, 1);
  });

  test('the preview plans even while notifications are off', () async {
    await demoWithNotifications(on: false);

    final preview = await stack.previewPlan();

    expect(preview.enabled, isFalse);
    expect(preview.plan, isNotEmpty);
    expect(preview.pending, 0);
  });
}
