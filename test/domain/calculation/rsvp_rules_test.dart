import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';

void main() {
  // Saturday 24 October, 17:30–20:00 UTC.
  final before = saturdayEvening.start.subtract(const Duration(hours: 1));
  final during = saturdayEvening.start.add(const Duration(minutes: 1));
  final after = saturdayEvening.end;

  TicketOffer offer(TicketType type, {required int left}) => TicketOffer(
    type: type,
    priceMinor: 1000,
    currency: 'GBP',
    capacity: 10,
    remaining: left,
  );

  RsvpBlock? block(Event event, {bool isGoing = false, DateTime? now}) =>
      rsvpBlock(event, isGoing: isGoing, now: now ?? before);

  test('a scheduled event with places, before it starts: bookable', () {
    expect(block(event()), isNull);
    expect(canRsvp(event(), isGoing: false, now: before), isTrue);
  });

  test('a moved event is still bookable, at its new time', () {
    final moved = event(
      status: EventStatus.moved,
      previousStart: DateTime.utc(2026, 10, 23, 17, 30),
    );

    expect(block(moved), isNull);
  });

  test('going: you already hold a ticket', () {
    expect(block(event(), isGoing: true), RsvpBlock.going);
  });

  test('cancelled by the organizer', () {
    expect(block(event(status: EventStatus.cancelled)), RsvpBlock.cancelled);
  });

  test('started: bookings close at the first instant', () {
    expect(block(event(), now: saturdayEvening.start), RsvpBlock.started);
    expect(block(event(), now: during), RsvpBlock.started);
  });

  test('ended', () {
    expect(block(event(), now: after), RsvpBlock.ended);
  });

  test('sold out only when every offer is', () {
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

    expect(block(some), isNull);
    expect(block(none), RsvpBlock.soldOut);
  });

  group('the most decisive reason wins', () {
    final soldOutAndCancelled = event(
      status: EventStatus.cancelled,
      offers: [offer(TicketType.standard, left: 0)],
    );

    test('going beats everything (your ticket still stands)', () {
      expect(
        block(soldOutAndCancelled, isGoing: true, now: after),
        RsvpBlock.going,
      );
    });

    test('cancelled beats ended and sold out', () {
      expect(block(soldOutAndCancelled, now: after), RsvpBlock.cancelled);
    });

    test('ended beats sold out', () {
      final soldOut = event(offers: [offer(TicketType.standard, left: 0)]);
      expect(block(soldOut, now: after), RsvpBlock.ended);
    });
  });
}
