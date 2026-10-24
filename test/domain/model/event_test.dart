import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';

void main() {
  TicketOffer offer(TicketType type, {int price = 1000, int left = 5}) =>
      TicketOffer(
        type: type,
        priceMinor: price,
        currency: 'GBP',
        capacity: 10,
        remaining: left,
      );

  group('a ticket offer', () {
    test('is free at 0, sold out at 0 places left', () {
      expect(offer(TicketType.free, price: 0).isFree, isTrue);
      expect(offer(TicketType.standard).isFree, isFalse);
      expect(offer(TicketType.standard, left: 0).isSoldOut, isTrue);
      expect(offer(TicketType.standard, left: 1).isSoldOut, isFalse);
    });
  });

  group('an event', () {
    test('has the places left across its offers', () {
      final concert = event(
        offers: [
          offer(TicketType.standard, left: 4),
          offer(TicketType.vip, left: 2),
        ],
      );

      expect(concert.placesLeft, 6);
      expect(concert.isSoldOut, isFalse);
    });

    test('is sold out only when every offer is', () {
      final some = event(
        offers: [
          offer(TicketType.standard, left: 0),
          offer(TicketType.vip, left: 1),
        ],
      );
      final none = event(
        offers: [
          offer(TicketType.standard, left: 0),
          offer(TicketType.vip, left: 0),
        ],
      );

      expect(some.isSoldOut, isFalse);
      expect(none.isSoldOut, isTrue);
    });

    test('is free only when every offer is', () {
      final free = event(offers: [offer(TicketType.free, price: 0)]);
      final mixed = event(
        offers: [offer(TicketType.free, price: 0), offer(TicketType.vip)],
      );

      expect(free.isFree, isTrue);
      expect(mixed.isFree, isFalse);
    });

    test('is online when it has a join link, and the type says which', () {
      final online = event(location: onlineAt('https://meet.example/a'));
      final inPerson = event();

      expect(online.isOnline, isTrue);
      expect(inPerson.isOnline, isFalse);
      expect(switch (inPerson.location) {
        Venue(:final city) => city,
        Online() => null,
      }, 'London');
    });
  });
}
