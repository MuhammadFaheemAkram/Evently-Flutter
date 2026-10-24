import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../helpers/catalog_fixtures.dart';

void main() {
  // intl's 12-hour format puts a narrow no-break space before AM/PM.
  String plain(String text) => text.replaceAll(' ', ' ');

  final london = tz.getLocation('Europe/London');
  final lahore = tz.getLocation('Asia/Karachi');

  group('day headings, in the user\'s calendar', () {
    final today = CalendarDate(2026, 10, 21);

    test('today, tomorrow, then the date', () {
      expect(EventFormats.day(today, today: today), 'Today');
      expect(EventFormats.day(today.addDays(1), today: today), 'Tomorrow');
      expect(EventFormats.day(today.addDays(3), today: today), 'Sat, 24 Oct');
    });

    test('with the year when it is not this one', () {
      expect(
        EventFormats.day(CalendarDate(2027, 1, 2), today: today),
        'Sat, 2 Jan 2027',
      );
    });
  });

  group('times on a clock', () {
    final evening = saturdayEvening; // 18:30–21:00 BST.

    test("the start, on the venue's clock", () {
      expect(
        EventFormats.start(evening, use24HourFormat: true),
        'Sat 24 Oct, 18:30 BST',
      );
      expect(
        plain(EventFormats.start(evening, use24HourFormat: false)),
        'Sat 24 Oct, 6:30 PM BST',
      );
    });

    test('the start, on another zone\'s clock', () {
      expect(
        EventFormats.start(evening, use24HourFormat: true, zone: lahore),
        'Sat 24 Oct, 22:30 PKT',
      );
    });

    test('a range on one day', () {
      expect(
        EventFormats.range(evening, use24HourFormat: true),
        'Sat 24 Oct, 18:30–21:00 BST',
      );
    });

    test('a range across days names both', () {
      final jam = EventTime(
        start: DateTime.utc(2026, 10, 22, 3, 30),
        end: DateTime.utc(2026, 10, 22, 7),
        zone: 'America/New_York',
      );

      expect(
        EventFormats.range(jam, use24HourFormat: true),
        'Wed 21 Oct, 23:30 – Thu 22 Oct, 03:00 EDT',
      );
    });

    test('in the user\'s zone, a London evening ends after midnight in '
        'Lahore', () {
      expect(
        EventFormats.range(evening, use24HourFormat: true, zone: lahore),
        'Sat 24 Oct, 22:30 – Sun 25 Oct, 01:00 PKT',
      );
    });

    test('the zone changes its name with the season', () {
      final winter = EventTime(
        start: DateTime.utc(2026, 11, 7, 18, 30),
        end: DateTime.utc(2026, 11, 7, 21),
        zone: 'Europe/London',
      );

      expect(
        EventFormats.range(winter, use24HourFormat: true),
        'Sat 7 Nov, 18:30–21:00 GMT',
      );
    });

    test('a screen reader hears it in full words', () {
      expect(
        plain(EventFormats.spokenRange(evening, use24HourFormat: false)),
        'Saturday 24 October, 6:30 PM to 9:00 PM, BST',
      );
    });

    test("whether the user's clock reads differently", () {
      expect(EventFormats.differsIn(evening, london), isFalse);
      expect(EventFormats.differsIn(evening, lahore), isTrue);
      // Lisbon shares London's offset all year.
      expect(
        EventFormats.differsIn(evening, tz.getLocation('Europe/Lisbon')),
        isFalse,
      );
    });

    test('a session slot', () {
      expect(EventFormats.slot(evening, use24HourFormat: true), '18:30–21:00');
    });

    test('an in-person event is told in its venue\'s zone, an online one in '
        'the user\'s', () {
      expect(EventFormats.zoneFor(event(), lahore), london);
      expect(
        EventFormats.zoneFor(
          event(location: onlineAt('https://meet.example/a')),
          lahore,
        ),
        lahore,
      );
    });
  });

  group('prices', () {
    test('whole amounts without decimals, others with', () {
      expect(EventFormats.price(1800, 'GBP'), '£18');
      expect(EventFormats.price(1850, 'GBP'), '£18.50');
      expect(EventFormats.price(12000, 'EUR'), '€120');
      expect(EventFormats.price(19900, 'USD'), r'$199');
      expect(EventFormats.price(300000, 'PKR'), 'Rs3,000');
    });

    test('zero is free', () {
      expect(EventFormats.price(0, 'GBP'), 'Free');
    });

    TicketOffer offer(TicketType type, int price) => TicketOffer(
      type: type,
      priceMinor: price,
      currency: 'GBP',
      capacity: 10,
      remaining: 5,
    );

    test("a card's summary", () {
      expect(EventFormats.priceSummary(event()), 'Free');
      expect(
        EventFormats.priceSummary(
          event(offers: [offer(TicketType.standard, 1800)]),
        ),
        '£18',
      );
      expect(
        EventFormats.priceSummary(
          event(
            offers: [
              offer(TicketType.vip, 4500),
              offer(TicketType.standard, 1800),
            ],
          ),
        ),
        'From £18',
      );
      expect(
        EventFormats.priceSummary(
          event(offers: [freeOffer, offer(TicketType.vip, 4500)]),
        ),
        'From £45',
      );
    });
  });

  test('counts and their words', () {
    expect(EventFormats.count(950), '950');
    expect(EventFormats.count(2400), '2.4k');
    expect(EventFormats.followers(1), '1 follower');
    expect(EventFormats.followers(8900), '8.9k followers');
    expect(EventFormats.placesLeft(1), '1 place left');
    expect(EventFormats.placesLeft(26), '26 places left');
  });

  test('a place, briefly', () {
    expect(EventFormats.place(londonHall), 'Hall, London');
    expect(EventFormats.place(onlineAt('https://meet.example/a')), 'Online');
  });

  test('every reason the RSVP button is off has words', () {
    for (final block in RsvpBlock.values) {
      expect(EventFormats.rsvpBlock(block), isNotEmpty);
    }
    expect(EventFormats.rsvpBlock(RsvpBlock.soldOut), 'Sold out');
  });
}
