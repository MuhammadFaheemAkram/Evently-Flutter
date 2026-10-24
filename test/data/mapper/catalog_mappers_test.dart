import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helpers/catalog_fixtures.dart';

void main() {
  Catalog map(Map<String, dynamic> json) =>
      CatalogDto.fromJson(json).toCatalog();

  /// The default catalog with its one event changed by [change].
  Catalog mapEvent(void Function(Map<String, dynamic> event) change) {
    final event = eventJson();
    change(event);
    return map(catalogJson(events: [event]));
  }

  Matcher refused(String problem) => throwsA(
    isA<FormatException>().having(
      (e) => e.message,
      'message',
      'Catalog: $problem',
    ),
  );

  group('maps', () {
    test('an in-person event, its instants in UTC', () {
      final event = map(catalogJson()).events.single;

      expect(event.time.start, DateTime.utc(2026, 10, 24, 17, 30));
      expect(event.time.end, DateTime.utc(2026, 10, 24, 20));
      expect(event.time.start.isUtc, isTrue);
      expect(event.time.zone, 'Europe/London');
      expect(event.location, londonHall);
      expect(event.status, EventStatus.scheduled);
      expect(event.featured, isFalse);
      expect(event.offers.single, freeOffer);
    });

    test('an online event', () {
      final event = mapEvent((e) {
        e
          ..remove('venue')
          ..['joinUrl'] = 'https://meet.example/a';
      }).events.single;

      expect(event.location, onlineAt('https://meet.example/a'));
    });

    test('a moved event, with when it was', () {
      final event = mapEvent((e) {
        e
          ..['status'] = 'moved'
          ..['previousStartsAt'] = '2026-10-23T18:30:00.000+0100';
      }).events.single;

      expect(event.status, EventStatus.moved);
      expect(event.previousStart, DateTime.utc(2026, 10, 23, 17, 30));
    });

    test('sessions, under their event', () {
      final catalog = mapEvent((e) => e['sessions'] = [sessionJson()]);

      final session = catalog.sessions.single;
      expect(session.eventId, 'ev_1');
      expect(session.start, DateTime.utc(2026, 10, 24, 17, 30));
      expect(session.end, DateTime.utc(2026, 10, 24, 18, 15));
    });

    test('organizers', () {
      final organizer = map(catalogJson()).organizers.single;

      expect(organizer.id, 'org_1');
      expect(organizer.followers, 10);
    });
  });

  group('the DTOs refuse a missing or mistyped field', () {
    test('a missing title', () {
      expect(
        () => mapEvent((e) => e.remove('title')),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('an unknown category', () {
      expect(
        () => mapEvent((e) => e['category'] = 'gardening'),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('a date that is no date', () {
      expect(
        () => mapEvent((e) => e['startsAt'] = 'Saturday evening'),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });

  group('the mapper refuses', () {
    test('an organizer twice, or without a name, or with a negative count', () {
      expect(
        () => map(catalogJson(organizers: [organizerJson(), organizerJson()])),
        refused('organizer org_1 twice'),
      );
      expect(
        () => map(catalogJson(organizers: [organizerJson()..['name'] = ' '])),
        refused('org_1 has no name'),
      );
      expect(
        () =>
            map(catalogJson(organizers: [organizerJson()..['followers'] = -1])),
        refused('org_1 has a negative count'),
      );
    });

    test('an event twice', () {
      expect(
        () => map(catalogJson(events: [eventJson(), eventJson()])),
        refused('event ev_1 twice'),
      );
    });

    test('an event without a title', () {
      expect(
        () => mapEvent((e) => e['title'] = ''),
        refused('ev_1 has no title'),
      );
    });

    test('an unknown organizer', () {
      expect(
        () => mapEvent((e) => e['organizerId'] = 'org_9'),
        refused('ev_1 names an unknown organizer'),
      );
    });

    test('an unknown time zone', () {
      expect(
        () => mapEvent((e) => e['timeZone'] = 'Europe/Atlantis'),
        refused('ev_1 is in an unknown time zone, Europe/Atlantis'),
      );
    });

    test('an event that ends as it starts', () {
      expect(
        () => mapEvent((e) => e['endsAt'] = e['startsAt']),
        refused('ev_1 ends before it starts'),
      );
    });

    test('a venue and a link, or neither', () {
      expect(
        () => mapEvent((e) => e['joinUrl'] = 'https://meet.example/a'),
        refused('ev_1 needs a venue or a join link, not both'),
      );
      expect(
        () => mapEvent((e) => e.remove('venue')),
        refused('ev_1 needs a venue or a join link, not both'),
      );
    });

    test('a venue without a city', () {
      expect(
        () => mapEvent(
          (e) => e['venue'] = {'name': 'Hall', 'address': '1 Road', 'city': ''},
        ),
        refused("ev_1's venue needs a name and a city"),
      );
    });

    test('a link that is not https', () {
      for (final link in [
        'http://meet.example/a',
        'meet.example',
        'https://',
      ]) {
        expect(
          () => mapEvent((e) {
            e
              ..remove('venue')
              ..['joinUrl'] = link;
          }),
          refused("ev_1's join link isn't an https address"),
          reason: link,
        );
      }
    });

    test('no places, or more attendees than places', () {
      expect(
        () => mapEvent((e) => e['capacity'] = 0),
        refused('ev_1 has no places'),
      );
      expect(
        () => mapEvent((e) => e['attendeeCount'] = 101),
        refused('ev_1 has more attendees than places'),
      );
    });

    test('no tickets for sale', () {
      expect(
        () => mapEvent((e) => e['offers'] = <Object>[]),
        refused('ev_1 sells no tickets'),
      );
    });

    test('a ticket type twice', () {
      expect(
        () => mapEvent((e) => e['offers'] = [offerJson(), offerJson()]),
        refused('ev_1 sells free twice'),
      );
    });

    test('a price below zero, or no currency code', () {
      expect(
        () => mapEvent(
          (e) => e['offers'] = [offerJson(type: 'standard', priceMinor: -1)],
        ),
        refused("ev_1's standard costs < 0"),
      );
      expect(
        () => mapEvent((e) => e['offers'] = [offerJson(currency: 'gbp')]),
        refused("ev_1's free has no currency code"),
      );
    });

    test('impossible places', () {
      for (final (capacity, remaining) in [(0, 0), (10, 11), (10, -1)]) {
        expect(
          () => mapEvent(
            (e) => e['offers'] = [
              offerJson(capacity: capacity, remaining: remaining),
            ],
          ),
          refused("ev_1's free has impossible places"),
          reason: '$remaining of $capacity',
        );
      }
    });

    test('a moved event without when it was, or the reverse', () {
      expect(
        () => mapEvent((e) => e['status'] = 'moved'),
        refused('ev_1: only a moved event has a previous start'),
      );
      expect(
        () => mapEvent(
          (e) => e['previousStartsAt'] = '2026-10-23T18:30:00.000+0100',
        ),
        refused('ev_1: only a moved event has a previous start'),
      );
    });

    test('a session twice, or without a title', () {
      expect(
        () => mapEvent((e) => e['sessions'] = [sessionJson(), sessionJson()]),
        refused('session ses_1 twice'),
      );
      expect(
        () => mapEvent((e) => e['sessions'] = [sessionJson()..['title'] = '']),
        refused('ses_1 has no title'),
      );
    });

    test('a session twice across events', () {
      expect(
        () => map(
          catalogJson(
            events: [
              eventJson()..['sessions'] = [sessionJson()],
              eventJson(id: 'ev_2')..['sessions'] = [sessionJson()],
            ],
          ),
        ),
        refused('session ses_1 twice'),
      );
    });

    test('a session that ends as it starts', () {
      expect(
        () => mapEvent(
          (e) => e['sessions'] = [
            sessionJson(endsAt: '2026-10-24T18:30:00.000+0100'),
          ],
        ),
        refused('ses_1 ends before it starts'),
      );
    });

    test('a session outside its event, by a minute either side', () {
      expect(
        () => mapEvent(
          (e) => e['sessions'] = [
            sessionJson(startsAt: '2026-10-24T18:29:00.000+0100'),
          ],
        ),
        refused('ses_1 falls outside ev_1'),
      );
      expect(
        () => mapEvent(
          (e) => e['sessions'] = [
            sessionJson(endsAt: '2026-10-24T21:01:00.000+0100'),
          ],
        ),
        refused('ses_1 falls outside ev_1'),
      );
    });

    test('but a session filling its event exactly is fine', () {
      final catalog = mapEvent(
        (e) => e['sessions'] = [
          sessionJson(endsAt: '2026-10-24T21:00:00.000+0100'),
        ],
      );
      expect(catalog.sessions, hasLength(1));
    });
  });

  test('instants with any offset are the same instant', () {
    final bst = map(catalogJson()).events.single.time;
    final utc = mapEvent((e) {
      e
        ..['startsAt'] = '2026-10-24T17:30:00Z'
        ..['endsAt'] = '2026-10-24T20:00:00Z';
    }).events.single.time;

    expect(utc, bst);
  });

  test('a free event and a paid one keep their offers in order', () {
    final event = mapEvent(
      (e) => e['offers'] = [
        offerJson(type: 'vip', priceMinor: 4500, capacity: 20, remaining: 6),
        offerJson(),
      ],
    ).events.single;

    expect(event.offers.map((o) => o.type), [TicketType.vip, TicketType.free]);
  });
}
