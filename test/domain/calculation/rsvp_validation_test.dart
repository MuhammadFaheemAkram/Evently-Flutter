import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/calculation/rsvp_validation.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';

void main() {
  final before = saturdayEvening.start.subtract(const Duration(days: 1));
  const vip = TicketOffer(
    type: TicketType.vip,
    priceMinor: 4500,
    currency: 'GBP',
    capacity: 10,
    remaining: 0,
  );
  final concert = event(offers: [freeOffer, vip]);

  RsvpProblem? validate({
    Event? shown,
    bool isGoing = false,
    TicketType? type = TicketType.free,
    String note = '',
    DateTime? now,
  }) => validateRsvp(
    event: shown ?? concert,
    isGoing: isGoing,
    type: type,
    note: note,
    now: now ?? before,
  );

  test('a type on sale, a short note: fine', () {
    expect(validate(note: 'Aisle seat, please'), isNull);
  });

  test('the event closed beats any form problem', () {
    expect(
      validate(isGoing: true, type: null),
      isA<RsvpClosed>().having((p) => p.block, 'block', RsvpBlock.going),
    );
    expect(
      validate(now: saturdayEvening.start),
      isA<RsvpClosed>().having((p) => p.block, 'block', RsvpBlock.started),
    );
  });

  test('no type chosen', () {
    expect(validate(type: null), isA<RsvpNoType>());
  });

  test('a type the event does not sell', () {
    expect(validate(type: TicketType.workshop), isA<RsvpTypeNotOffered>());
  });

  test('a type with no places left, while another has some', () {
    expect(validate(type: TicketType.vip), isA<RsvpTypeSoldOut>());
  });

  group('the note', () {
    test('200 characters is fine, 201 is too long', () {
      expect(validate(note: 'a' * 200), isNull);
      expect(
        validate(note: 'a' * 201),
        isA<RsvpNoteTooLong>().having((p) => p.length, 'length', 201),
      );
    });

    test('an emoji counts as one character, as a reader sees it', () {
      // 👩‍👩‍👧 is five code points and eight UTF-16 units.
      expect(validate(note: '👩‍👩‍👧' * 200), isNull);
      expect(RsvpRules.noteLength('👩‍👩‍👧'), 1);
    });

    test('surrounding spaces are not counted', () {
      expect(validate(note: '  ${'a' * 200}  '), isNull);
    });
  });
}
