import 'package:evently/core/common/app_exception.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:evently/features/event_detail/cubit/event_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/user_data_fixtures.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<EventDetailCubit> opened(String eventId, {bool demo = true}) async {
    stack = DataStack();
    addTearDown(stack.close);
    demo ? await stack.loadDemo() : await stack.catalog.refresh();
    final cubit = EventDetailCubit(
      stack.watchEventDetails,
      stack.setEventSaved,
      stack.openLink,
      stack.eventClock,
    )..load(eventId);
    addTearDown(cubit.close);
    await waitFor(cubit, (s) => s.status != EventDetailStatus.loading);
    return cubit;
  }

  test('a cached event: ready, with what stands between you and a '
      'booking', () async {
    final cubit = await opened('ev_jazz_vaults');

    expect(cubit.state.status, EventDetailStatus.ready);
    expect(cubit.state.details?.item.event.title, isNotEmpty);
    expect(cubit.state.now, stack.eventClock.now());
    expect(cubit.state.rsvpBlock, isNull);
    expect(cubit.state.hasEnded, isFalse);
  });

  test('sold out, past, going: each says why', () async {
    expect(
      (await opened('ev_dart_workshop')).state.rsvpBlock,
      RsvpBlock.soldOut,
    );
    final past = await opened('ev_design_critique');
    expect(past.state.rsvpBlock, RsvpBlock.ended);
    expect(past.state.hasEnded, isTrue);
    expect(
      (await opened('ev_flutter_london_meetup')).state.rsvpBlock,
      RsvpBlock.going,
    );
  });

  test('an event that isn\'t cached: not found', () async {
    final cubit = await opened('ev_nowhere');

    expect(cubit.state.status, EventDetailStatus.notFound);
    expect(cubit.state.details, isNull);
  });

  test('save and unsave', () async {
    final cubit = await opened('ev_thames_10k');

    await cubit.toggleSaved();
    await waitFor(cubit, (s) => s.details!.item.isSaved);
    await cubit.toggleSaved();
    await waitFor(cubit, (s) => !s.details!.item.isSaved);
  });

  test(
    'follows a booking made elsewhere: now going, with the ticket',
    () async {
      final cubit = await opened('ev_jazz_vaults');

      await stack.db
          .into(stack.db.tickets)
          .insert(
            ticket(
              id: 't_new',
              eventId: 'ev_jazz_vaults',
              code: 'EVT-ZZZZ-ZZZZ',
            ).toRow(),
          );

      final going = await waitFor(cubit, (s) => s.details!.item.isGoing);
      expect(going.details!.ticketId, 't_new');
      expect(going.rsvpBlock, RsvpBlock.going);
    },
  );

  group('links', () {
    test('directions: Apple Maps on iOS, Google Maps elsewhere', () async {
      final cubit = await opened('ev_jazz_vaults');

      await cubit.openDirections(appleMaps: true);
      await cubit.openDirections(appleMaps: false);

      expect(
        [for (final url in stack.links.opened) url.host],
        ['maps.apple.com', 'www.google.com'],
      );
    });

    test('an online event has no directions', () async {
      final cubit = await opened('ev_dart_patterns_live');

      await cubit.openDirections(appleMaps: true);

      expect(stack.links.opened, isEmpty);
    });

    test('the join link opens for someone going, not before', () async {
      final notGoing = await opened('ev_burnout_proof');
      await notGoing.openJoinLink();
      expect(stack.links.opened, isEmpty);

      final going = await opened('ev_dart_patterns_live');
      await going.openJoinLink();
      expect(stack.links.opened, [
        Uri.parse('https://meet.example.com/dart3-patterns'),
      ]);
    });

    test("a link the system can't open says so", () async {
      final cubit = await opened('ev_jazz_vaults');
      stack.links.succeeds = false;

      await cubit.openDirections(appleMaps: false);

      expect(cubit.state.message, const LinkOpenFailedException().message);
      expect(cubit.state.messageSerial, 1);
    });
  });
}
