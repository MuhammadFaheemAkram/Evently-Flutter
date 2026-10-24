import 'dart:math';

import 'package:clock/clock.dart';
import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/domain/calculation/ticket_codes.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

// The fake server's own state: places taken and tickets issued, checked on
// every booking, as of Wednesday 21 October, 14:00 UTC.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NetworkSimulator network;
  late FakeEventlyApi server;

  setUp(() {
    network = NetworkSimulator(latency: Duration.zero);
    server = FakeEventlyApi(
      AssetJsonLoader(rootBundle),
      network,
      Clock.fixed(demoNow),
      random: Random(1),
    );
  });

  Future<int> remaining(String eventId, TicketType type) async {
    final catalog = await server.fetchCatalog();
    final event = catalog.events.singleWhere((e) => e.id == eventId);
    return event.offers.singleWhere((o) => o.type == type).remaining;
  }

  RsvpRequestDto request(String eventId, TicketType type) =>
      RsvpRequestDto(eventId: eventId, type: type, note: '  Aisle seat ');

  test('a booking: a ticket with a valid code, one place fewer, one more '
      'attendee', () async {
    final before = await remaining('ev_jazz_vaults', TicketType.vip);

    final booking = await server.rsvp(
      request('ev_jazz_vaults', TicketType.vip),
    );

    expect(TicketCodes.isValid(booking.ticket.code), isTrue);
    expect(booking.ticket.eventId, 'ev_jazz_vaults');
    expect(booking.ticket.note, 'Aisle seat');
    expect(booking.ticket.bookedAt, demoNow);
    final vip = booking.event.offers.singleWhere(
      (o) => o.type == TicketType.vip,
    );
    expect(vip.remaining, before - 1);
    expect(booking.event.attendeeCount, 125);
    // Every catalog it serves from now on counts the booking.
    expect(await remaining('ev_jazz_vaults', TicketType.vip), before - 1);
  });

  test('a second booking for the same event is refused', () async {
    await server.rsvp(request('ev_jazz_vaults', TicketType.standard));

    await expectLater(
      server.rsvp(request('ev_jazz_vaults', TicketType.vip)),
      throwsA(isA<AlreadyBookedException>()),
    );
  });

  test(
    "the demo user's tickets count, once the server has sent them",
    () async {
      await server.fetchDemoUser();

      await expectLater(
        server.rsvp(request('ev_flutter_london_meetup', TicketType.free)),
        throwsA(isA<AlreadyBookedException>()),
      );
    },
  );

  test('sold out: refused', () async {
    await expectLater(
      server.rsvp(request('ev_dart_workshop', TicketType.workshop)),
      throwsA(isA<SoldOutException>()),
    );
  });

  test('a type the event does not sell: refused as sold out', () async {
    await expectLater(
      server.rsvp(request('ev_jazz_vaults', TicketType.workshop)),
      throwsA(isA<SoldOutException>()),
    );
  });

  test('an event that has started or ended: closed', () async {
    await expectLater(
      server.rsvp(request('ev_accessibility_talk', TicketType.free)),
      throwsA(isA<BookingClosedException>()),
    );
  });

  test('an unknown event: closed', () async {
    await expectLater(
      server.rsvp(request('ev_nowhere', TicketType.free)),
      throwsA(isA<BookingClosedException>()),
    );
  });

  test('offline: nothing is booked', () async {
    network.failRequests = true;

    await expectLater(
      server.rsvp(request('ev_jazz_vaults', TicketType.vip)),
      throwsA(isA<NetworkException>()),
    );
    network.failRequests = false;
    expect(await remaining('ev_jazz_vaults', TicketType.vip), 6);
  });

  group('cancel', () {
    test('gives the place back, and allows booking again', () async {
      final booking = await server.rsvp(
        request('ev_jazz_vaults', TicketType.vip),
      );

      final event = await server.cancelRsvp(
        CancelRequestDto(
          ticketId: booking.ticket.id,
          eventId: 'ev_jazz_vaults',
          type: TicketType.vip,
        ),
      );

      expect(
        event.offers.singleWhere((o) => o.type == TicketType.vip).remaining,
        6,
      );
      await server.rsvp(request('ev_jazz_vaults', TicketType.vip));
    });

    test('a ticket the server forgot (it restarted) still gives its place '
        'back', () async {
      final event = await server.cancelRsvp(
        const CancelRequestDto(
          ticketId: 'tkt_from_before',
          eventId: 'ev_design_conf',
          type: TicketType.standard,
        ),
      );

      expect(
        event.offers
            .singleWhere((o) => o.type == TicketType.standard)
            .remaining,
        86,
      );
    });

    test('never more places than the offer has', () async {
      final event = await server.cancelRsvp(
        const CancelRequestDto(
          ticketId: 'tkt_x',
          eventId: 'ev_typography_walk',
          type: TicketType.free,
        ),
      );
      final free = event.offers.single;

      expect(free.remaining, lessThanOrEqualTo(free.capacity));
    });

    test('after the start: refused', () async {
      await expectLater(
        server.cancelRsvp(
          const CancelRequestDto(
            ticketId: 'tkt_demo_accessibility',
            eventId: 'ev_accessibility_talk',
            type: TicketType.free,
          ),
        ),
        throwsA(isA<BookingClosedException>()),
      );
    });
  });
}
