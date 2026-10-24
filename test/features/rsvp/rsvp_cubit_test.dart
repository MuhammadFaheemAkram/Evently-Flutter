import 'dart:async';

import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/calculation/rsvp_validation.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/rsvp/cubit/rsvp_cubit.dart';
import 'package:evently/features/rsvp/cubit/rsvp_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<RsvpCubit> opened(
    String eventId, {
    EventlyApi Function(EventlyApi real)? api,
  }) async {
    stack = DataStack(api: api);
    addTearDown(stack.close);
    await stack.loadDemo();
    final cubit = RsvpCubit(
      stack.watchEventDetails,
      stack.rsvpEvent,
      stack.eventClock,
    )..load(eventId);
    addTearDown(cubit.close);
    await waitFor(cubit, (s) => s.status != RsvpStatus.loading);
    return cubit;
  }

  test('the form opens on the event, no type chosen when there are '
      'several', () async {
    final cubit = await opened('ev_jazz_vaults');

    expect(cubit.state.status, RsvpStatus.editing);
    expect(cubit.state.event?.event.id, 'ev_jazz_vaults');
    expect(cubit.state.type, isNull);
  });

  test('a single ticket type on sale is chosen already', () async {
    final cubit = await opened('ev_thames_10k');

    expect(cubit.state.type, TicketType.free);
  });

  test('confirm without a type: the error shows, nothing is sent', () async {
    final cubit = await opened(
      'ev_jazz_vaults',
      api: (real) => ScriptedEventlyApi(real),
    );

    await cubit.confirm();

    expect(cubit.state.showErrors, isTrue);
    expect(cubit.state.problem, isA<RsvpNoType>());
    expect(cubit.state.status, RsvpStatus.editing);
    expect((stack.api as ScriptedEventlyApi).rsvpCalls, 0);
  });

  test('a note too long: the error shows, nothing is sent', () async {
    final cubit = await opened('ev_jazz_vaults')
      ..selectType(TicketType.vip)
      ..changeNote('a' * 201);

    await cubit.confirm();

    expect(cubit.state.problem, isA<RsvpNoteTooLong>());
    expect(cubit.state.ticketId, isNull);
  });

  test(
    'confirmed by the server: the ticket id, once, for the effect',
    () async {
      final cubit = await opened('ev_jazz_vaults')
        ..selectType(TicketType.vip)
        ..changeNote('Aisle seat');
      final effects = <String>[];
      final subscription = cubit.stream
          .map((s) => s.ticketId)
          .distinct()
          .listen((id) {
            if (id != null) effects.add(id);
          });
      addTearDown(subscription.cancel);

      await cubit.confirm();
      await waitFor(cubit, (s) => s.event?.isGoing ?? false);
      await pumpEventQueue();

      expect(effects, hasLength(1));
      final ticket = await stack.booking.watchTicket(effects.single).first;
      expect(ticket?.ticket.type, TicketType.vip);
      expect(ticket?.ticket.note, 'Aisle seat');
      // The form locks: nothing can be changed or sent again.
      cubit.selectType(TicketType.standard);
      await cubit.confirm();
      expect(cubit.state.type, TicketType.vip);
      expect(effects, hasLength(1));
    },
  );

  test('offline: the error, nothing written; Try again books', () async {
    final cubit =
        await opened(
            'ev_jazz_vaults',
            api: (real) =>
                ScriptedEventlyApi(real, rsvp: [const NetworkException()]),
          )
          ..selectType(TicketType.vip);

    await cubit.confirm();
    expect(cubit.state.status, RsvpStatus.failed);
    expect(cubit.state.error, const NetworkException().message);
    expect(cubit.state.ticketId, isNull);
    expect((await stack.booking.watchTickets().first), hasLength(4));

    (stack.api as ScriptedEventlyApi).recover();
    await cubit.confirm();
    expect(cubit.state.ticketId, isNotNull);
  });

  test('a second tap while waiting sends nothing more', () async {
    final gate = Completer<void>();
    final cubit =
        await opened(
            'ev_jazz_vaults',
            api: (real) => _GatedRsvp(real, gate.future),
          )
          ..selectType(TicketType.vip);

    final first = cubit.confirm();
    await waitFor(cubit, (s) => s.status == RsvpStatus.submitting);
    await cubit.confirm();
    gate.complete();
    await first;

    expect((stack.api as _GatedRsvp).calls, 1);
  });

  test('an event you are going to: closed, with the reason', () async {
    final cubit = await opened('ev_flutter_london_meetup');

    expect(cubit.state.block, RsvpBlock.going);
  });

  test('an event not cached: not found', () async {
    final cubit = await opened('ev_nowhere');

    expect(cubit.state.status, RsvpStatus.notFound);
  });
}

/// Holds every booking until [gate] completes.
class _GatedRsvp implements EventlyApi {
  _GatedRsvp(this.real, this.gate);

  final EventlyApi real;
  final Future<void> gate;
  var calls = 0;

  @override
  Future<BookingDto> rsvp(RsvpRequestDto request) async {
    calls++;
    await gate;
    return real.rsvp(request);
  }

  @override
  Future<EventDto> cancelRsvp(CancelRequestDto request) =>
      real.cancelRsvp(request);

  @override
  Future<CatalogDto> fetchCatalog() => real.fetchCatalog();

  @override
  Future<DemoUserDto> fetchDemoUser() => real.fetchDemoUser();
}
