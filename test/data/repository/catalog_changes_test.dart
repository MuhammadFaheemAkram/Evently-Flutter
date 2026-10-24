import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/result_matchers.dart';
import '../../helpers/test_dependencies.dart';

/// The real server, minus the events in [gone].
class _ForgetfulApi implements EventlyApi {
  _ForgetfulApi(this.real);

  final EventlyApi real;
  final gone = <String>{};

  @override
  Future<CatalogDto> fetchCatalog() async {
    final catalog = await real.fetchCatalog();
    return CatalogDto(
      organizers: catalog.organizers,
      events: [
        for (final event in catalog.events)
          if (!gone.contains(event.id)) event,
      ],
    );
  }

  @override
  Future<DemoUserDto> fetchDemoUser() => real.fetchDemoUser();

  @override
  Future<BookingDto> rsvp(RsvpRequestDto request) => real.rsvp(request);

  @override
  Future<EventDto> cancelRsvp(CancelRequestDto request) =>
      real.cancelRsvp(request);
}

// What a refresh notices: the demo user holds tickets for the design
// conference (which the update moves) and Dart Patterns Live (which it
// cancels), and saved the AI summit (which it edits).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<DataStack> demoStack({
    EventlyApi Function(EventlyApi real)? api,
  }) async {
    final stack = DataStack(api: api);
    addTearDown(stack.close);
    await stack.loadDemo();
    return stack;
  }

  Future<List<(String, EventChangeKind)>> recorded(DataStack stack) async => [
    for (final row in await stack.db.remindersDao.allChanges())
      (row.eventId, row.kind),
  ];

  test(
    'a published update: the move and the cancellation of ticketed '
    'events are recorded, at the time of the sync, not yet alerted',
    () async {
      final stack = await demoStack();
      await stack.server.publishUpdate();

      expect(await stack.catalog.refresh(), isOk(27));

      expect(await recorded(stack), [
        ('ev_design_conf', EventChangeKind.moved),
        ('ev_dart_patterns_live', EventChangeKind.cancelled),
      ]);
      final rows = await stack.db.remindersDao.allChanges();
      expect(rows.every((r) => r.detectedAt == stack.eventClock.now()), isTrue);
      expect(rows.every((r) => !r.seen), isTrue);
    },
  );

  test('recorded once: the next refresh compares with a cache that has '
      'it', () async {
    final stack = await demoStack();
    await stack.server.publishUpdate();

    await stack.catalog.refresh();
    await stack.catalog.refresh();

    expect(await recorded(stack), hasLength(2));
  });

  test('nothing published: nothing recorded', () async {
    final stack = await demoStack();

    await stack.catalog.refresh();

    expect(await recorded(stack), isEmpty);
  });

  test('a ticket you cancelled first: no record for its event', () async {
    final stack = await demoStack();
    final design = (await stack.watchTickets().first).firstWhere(
      (t) => t.event.id == 'ev_design_conf',
    );
    expect(await stack.cancelRsvp(design), isOk());
    await stack.server.publishUpdate();

    await stack.catalog.refresh();

    expect(await recorded(stack), [
      ('ev_dart_patterns_live', EventChangeKind.cancelled),
    ]);
  });

  test('an event gone from the server: kept, marked cancelled, and '
      'recorded for its ticket', () async {
    late _ForgetfulApi api;
    final stack = await demoStack(api: (real) => api = _ForgetfulApi(real));
    api.gone.add('ev_flutter_london_meetup');

    await stack.catalog.refresh();

    final meetup = (await stack.db.catalogDao.readAll()).events.singleWhere(
      (e) => e.id == 'ev_flutter_london_meetup',
    );
    expect(meetup.status, EventStatus.cancelled);
    expect(await recorded(stack), [
      ('ev_flutter_london_meetup', EventChangeKind.cancelled),
    ]);

    // Still gone next time: no second record.
    await stack.catalog.refresh();
    expect(await recorded(stack), hasLength(1));
  });

  test('a refresh that fails records nothing and changes nothing', () async {
    final stack = await demoStack();
    final before = await stack.db.catalogDao.readAll();
    await stack.server.publishUpdate();
    stack.network.failRequests = true;

    expect(await stack.catalog.refresh(), isErr<NetworkException>());

    expect(await recorded(stack), isEmpty);
    expect((await stack.db.catalogDao.readAll()).events, before.events);
  });

  test('a refresh the next day moves nothing: the server counts from its '
      'calendar, not from today', () async {
    final stack = await demoStack();
    final before = (await stack.db.catalogDao.readAll()).events;
    stack.now = demoNow.add(const Duration(days: 1));

    await stack.catalog.refresh();

    expect(await recorded(stack), isEmpty);
    expect((await stack.db.catalogDao.readAll()).events, before);
  });

  test('Reset demo data starts the calendar from today, and leaves no '
      'change behind', () async {
    final stack = await demoStack();
    final meetup =
        (await stack.watchEventDetails('ev_flutter_london_meetup').first)!
            .item
            .event
            .time
            .start;
    stack.now = demoNow.add(const Duration(days: 2));

    expect(await stack.resetDemoData(), isOk());

    final moved =
        (await stack.watchEventDetails('ev_flutter_london_meetup').first)!
            .item
            .event
            .time
            .start;
    expect(moved, meetup.add(const Duration(days: 2)));
    expect(await recorded(stack), isEmpty);
  });

  group('claiming the changes for their alerts', () {
    test('each change is claimed once, with its event and ticket', () async {
      final stack = await demoStack();
      await stack.server.publishUpdate();
      await stack.catalog.refresh();

      final claimed = await stack.reminders.claimUnalertedChanges();

      expect(
        [for (final c in claimed) (c.event.id, c.kind)],
        [
          ('ev_design_conf', EventChangeKind.moved),
          ('ev_dart_patterns_live', EventChangeKind.cancelled),
        ],
      );
      expect(claimed.first.event.status, EventStatus.moved);
      expect(claimed.first.event.previousStart, isNotNull);
      expect(claimed.every((c) => c.ticketId != null), isTrue);
      expect(await stack.reminders.claimUnalertedChanges(), isEmpty);
      expect(
        (await stack.db.remindersDao.allChanges()).every((r) => r.seen),
        isTrue,
      );
    });

    test('two claims at once share the changes, never both', () async {
      final stack = await demoStack();
      await stack.server.publishUpdate();
      await stack.catalog.refresh();

      final (a, b) = await (
        stack.reminders.claimUnalertedChanges(),
        stack.reminders.claimUnalertedChanges(),
      ).wait;

      expect(a.length + b.length, 2);
    });
  });

  group('the reminder toggle', () {
    test('a choice is kept per event, and joins every card', () async {
      final stack = await demoStack();

      expect(
        await stack.setEventReminder(
          (await stack.reminders.watchRemindable().first).firstWhere(
            (i) => i.event.id == 'ev_jazz_vaults',
          ),
          enabled: true,
        ),
        isOk(),
      );

      final jazz = (await stack.reminders.watchRemindable().first).firstWhere(
        (i) => i.event.id == 'ev_jazz_vaults',
      );
      expect(jazz.isSaved, isTrue);
      expect(jazz.reminderChoice, isTrue);
      expect(jazz.hasReminder, isTrue);

      final details = await stack.watchEventDetails('ev_jazz_vaults').first;
      expect(details!.item.reminderChoice, isTrue);
    });

    test('remindable: only the events you are going to or saved', () async {
      final stack = await demoStack();

      final items = await stack.reminders.watchRemindable().first;

      expect(items, isNotEmpty);
      expect(items.every((i) => i.isGoing || i.isSaved), isTrue);
      final all = await stack.watchEventCards().first;
      expect(items.length, all.where((i) => i.isGoing || i.isSaved).length);
    });

    test('not for an event you neither saved nor booked', () async {
      final stack = await demoStack();
      final stranger = (await stack.watchEventCards().first).firstWhere(
        (i) => !i.isGoing && !i.isSaved,
      );

      expect(
        await stack.setEventReminder(stranger, enabled: true),
        isErrSaying('Save the event or RSVP to get a reminder.'),
      );
    });
  });
}
