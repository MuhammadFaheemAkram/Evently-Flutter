import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/result_matchers.dart';
import '../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<DataStack> loaded({EventlyApi Function(EventlyApi real)? api}) async {
    stack = DataStack(api: api);
    addTearDown(stack.close);
    await stack.loadDemo();
    return stack;
  }

  Future<List<TicketItem>> tickets() => stack.booking.watchTickets().first;

  Future<int> vipLeft() async {
    final details = await stack.catalog
        .watchEventDetails('ev_jazz_vaults')
        .first;
    return details!.item.event.offers
        .singleWhere((o) => o.type == TicketType.vip)
        .remaining;
  }

  group('rsvp', () {
    test(
      "the server's ticket and the event's new counts land together",
      () async {
        await loaded();

        final result = await stack.booking.rsvp(
          'ev_jazz_vaults',
          type: TicketType.vip,
          note: 'Aisle seat',
        );

        expect(result, isOk());
        final mine = (await tickets()).singleWhere(
          (t) => t.event.id == 'ev_jazz_vaults',
        );
        expect(mine.ticket.type, TicketType.vip);
        expect(mine.ticket.note, 'Aisle seat');
        expect(mine.status, TicketStatus.confirmed);
        expect(await vipLeft(), 5);
        expect(mine.event.attendeeCount, 125);
      },
    );

    test('offline: nothing written, the network error as is', () async {
      await loaded(
        api: (real) =>
            ScriptedEventlyApi(real, rsvp: [const NetworkException()]),
      );

      final result = await stack.booking.rsvp(
        'ev_jazz_vaults',
        type: TicketType.vip,
      );

      expect(result, isErr<NetworkException>());
      expect(await tickets(), hasLength(4));
      expect(await vipLeft(), 6);
    });

    test('refused by the server (sold out): nothing written', () async {
      await loaded();

      expect(
        await stack.booking.rsvp('ev_dart_workshop', type: TicketType.workshop),
        isErr<SoldOutException>(),
      );
      expect(await tickets(), hasLength(4));
    });

    test(
      'a damaged answer (a code that fails its check): nothing written',
      () async {
        await loaded();
        final real = await stack.realApi.rsvp(
          const RsvpRequestDto(eventId: 'ev_jazz_vaults', type: TicketType.vip),
        );
        final damaged = BookingDto.fromJson({
          'ticket': {
            'id': real.ticket.id,
            'eventId': 'ev_jazz_vaults',
            'code': 'EVT-AAAA-AAAB',
            'type': 'vip',
            'bookedAt': '2026-10-21T14:00:00Z',
          },
          'event': {
            'id': 'ev_jazz_vaults',
            'title': 'Late Jazz at the Vaults',
            'description': '',
            'category': 'music',
            'organizerId': 'org_soundwaves',
            'startsAt': '2026-10-26T20:00:00Z',
            'endsAt': '2026-10-26T23:30:00Z',
            'timeZone': 'Europe/London',
            'venue': {'name': 'Vaults', 'address': 'x', 'city': 'London'},
            'attendeeCount': 0,
            'capacity': 1,
            'offers': [
              {
                'type': 'vip',
                'priceMinor': 1,
                'currency': 'GBP',
                'capacity': 1,
                'remaining': 1,
              },
            ],
          },
        });
        stack = DataStack(api: (r) => ScriptedEventlyApi(r, rsvp: [damaged]));
        addTearDown(stack.close);
        await stack.loadDemo();

        expect(
          await stack.booking.rsvp('ev_jazz_vaults', type: TicketType.vip),
          isErr<DataFormatException>(),
        );
        expect(await tickets(), hasLength(4));
        expect(await vipLeft(), 6);
      },
    );

    test('a ticket the database refuses: something went wrong, and the '
        "event's counts aren't written either", () async {
      await loaded();
      // The server books, but a local active ticket for the event already
      // exists (the partial unique index refuses a second).
      await stack.db.customStatement(
        'INSERT INTO tickets (id, event_id, code, type, note, booked_at) '
        "VALUES ('t_local', 'ev_jazz_vaults', 'EVT-LOCL-0000', 'vip', '', "
        "'2026-10-20T09:00:00.000Z')",
      );

      expect(
        await stack.booking.rsvp('ev_jazz_vaults', type: TicketType.vip),
        isErr<UnknownException>(),
      );
      expect(await vipLeft(), 6);
    });
  });

  group('cancel', () {
    test(
      'marks the ticket cancelled and gives the place back, together',
      () async {
        await loaded();
        await stack.booking.rsvp('ev_jazz_vaults', type: TicketType.vip);
        final mine = (await tickets()).singleWhere(
          (t) => t.event.id == 'ev_jazz_vaults',
        );

        expect(await stack.booking.cancel(mine), isOk());

        final after = (await tickets()).singleWhere(
          (t) => t.ticket.id == mine.ticket.id,
        );
        expect(after.status, TicketStatus.cancelledByYou);
        expect(after.ticket.cancelledAt, demoNow);
        expect(await vipLeft(), 6);
      },
    );

    test('offline: the ticket stays as it was', () async {
      await loaded(
        api: (real) =>
            ScriptedEventlyApi(real, cancel: [const NetworkException()]),
      );
      final design = (await tickets()).singleWhere(
        (t) => t.event.id == 'ev_design_conf',
      );

      expect(await stack.booking.cancel(design), isErr<NetworkException>());

      final after = (await tickets()).singleWhere(
        (t) => t.ticket.id == design.ticket.id,
      );
      expect(after.status, TicketStatus.confirmed);
    });
  });

  test('one ticket, or none', () async {
    await loaded();

    final ticket = await stack.booking
        .watchTicket('tkt_demo_design_conf')
        .first;
    expect(ticket?.event.id, 'ev_design_conf');
    expect(ticket?.organizerName, 'Berlin Design Collective');
    expect(await stack.booking.watchTicket('tkt_nowhere').first, isNull);
  });
}
