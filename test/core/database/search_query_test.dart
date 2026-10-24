import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/search_criteria.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';
import '../../helpers/test_dependencies.dart';
import '../../helpers/user_data_fixtures.dart';

// The search query, one filter at a time and combined, on a small catalog
// as of Wednesday 21 October, 14:00 UTC.
void main() {
  late AppDatabase db;
  late EventsDao dao;

  EventTime between(DateTime start, DateTime end) =>
      EventTime(start: start, end: end, zone: 'Europe/London');

  const paid = TicketOffer(
    type: TicketType.standard,
    priceMinor: 1800,
    currency: 'GBP',
    capacity: 100,
    remaining: 50,
  );

  final catalog = Catalog(
    organizers: [
      organizer(),
      organizer('org_music').copyWith(name: 'Soundwaves Live'),
    ],
    events: [
      event(
        id: 'jazz',
        title: 'Late Jazz',
        organizerId: 'org_music',
        category: EventCategory.music,
        location: const EventLocation.venue(
          name: 'The Vaults',
          address: '1 Old Street',
          city: 'London',
        ),
        time: between(
          DateTime.utc(2026, 10, 24, 18),
          DateTime.utc(2026, 10, 24, 21),
        ),
        offers: [paid],
      ),
      event(
        id: 'online',
        title: 'Dart 3 live',
        location: onlineAt('https://meet.example/a'),
        time: between(
          DateTime.utc(2026, 10, 21, 19),
          DateTime.utc(2026, 10, 21, 20),
        ),
      ),
      event(
        id: 'ongoing',
        title: 'Design week',
        category: EventCategory.design,
        location: const EventLocation.venue(
          name: 'Kühlhaus',
          address: 'Luckenwalder Str. 3',
          city: 'Berlin',
        ),
        time: between(
          DateTime.utc(2026, 10, 20, 9),
          DateTime.utc(2026, 10, 22, 18),
        ),
      ),
      event(
        id: 'past',
        title: 'Old jazz meetup',
        time: between(
          DateTime.utc(2026, 10, 19, 18),
          DateTime.utc(2026, 10, 19, 20),
        ),
      ),
      event(
        id: 'percent',
        title: '50% off: pricing workshop',
        category: EventCategory.business,
        time: between(
          DateTime.utc(2026, 10, 23, 9),
          DateTime.utc(2026, 10, 23, 12),
        ),
        offers: [
          freeOffer,
          paid.copyWith(type: TicketType.vip, priceMinor: 4500),
        ],
      ),
      event(
        id: 'snake',
        title: 'snake_case talk',
        time: between(
          DateTime.utc(2026, 10, 25, 9),
          DateTime.utc(2026, 10, 25, 10),
        ),
      ),
    ],
  );

  setUp(() async {
    db = newTestDatabase();
    dao = db.eventsDao;
    await db.catalogDao.upsertCatalog(catalog.toRows());
  });

  tearDown(() => db.close());

  Future<List<String>> search({
    String text = '',
    Set<EventCategory> categories = const {},
    DateTime? from,
    DateTime? until,
    PriceFilter price = PriceFilter.any,
    FormatFilter format = FormatFilter.any,
    RsvpFilter rsvp = RsvpFilter.any,
  }) async => [
    for (final row
        in await dao
            .watchSearch(
              SearchCriteria(
                text: text,
                categories: categories,
                from: from,
                until: until,
                price: price,
                format: format,
                rsvp: rsvp,
                now: demoNow,
              ),
            )
            .first)
      row.event.id,
  ];

  test('no filter: every event still to come, soonest first', () async {
    expect(await search(), ['ongoing', 'online', 'percent', 'jazz', 'snake']);
  });

  group('text', () {
    test('matches the title, ignoring case', () async {
      expect(await search(text: 'JAZZ'), ['jazz']);
    });

    test("matches the organizer's name", () async {
      expect(await search(text: 'soundwaves'), ['jazz']);
    });

    test('matches the venue and the city', () async {
      expect(await search(text: 'vaults'), ['jazz']);
      expect(await search(text: 'berlin'), ['ongoing']);
    });

    test('a past event is never found', () async {
      expect(await search(text: 'meetup'), isEmpty);
    });

    test("the user's % and _ are matched literally", () async {
      expect(await search(text: '50%'), ['percent']);
      expect(await search(text: '%'), ['percent']);
      // A literal underscore: in snake_case, and in "Organizer org_1" (all
      // but Jazz). As a wildcard it would match Jazz too.
      expect(await search(text: '_'), [
        'ongoing',
        'online',
        'percent',
        'snake',
      ]);
      expect(await search(text: 'snake_case'), ['snake']);
      expect(await search(text: r'\'), isEmpty);
    });
  });

  test('categories: any of those chosen', () async {
    expect(
      await search(categories: {EventCategory.music, EventCategory.design}),
      ['ongoing', 'jazz'],
    );
  });

  group('dates: events overlapping the window', () {
    test('an ongoing event counts for today', () async {
      expect(
        await search(
          from: DateTime.utc(2026, 10, 20, 23),
          until: DateTime.utc(2026, 10, 21, 23),
        ),
        ['ongoing', 'online'],
      );
    });

    test('an event ending as the window opens is out', () async {
      expect(
        await search(
          from: DateTime.utc(2026, 10, 21, 20),
          until: DateTime.utc(2026, 10, 22, 9),
        ),
        ['ongoing'],
      );
    });

    test('an event starting as the window closes is out', () async {
      expect(
        await search(
          from: DateTime.utc(2026, 10, 24),
          until: DateTime.utc(2026, 10, 25, 9),
        ),
        ['jazz'],
      );
    });
  });

  group('price', () {
    test('free: no offer has a price', () async {
      expect(await search(price: PriceFilter.free), [
        'ongoing',
        'online',
        'snake',
      ]);
    });

    test('paid: some offer has one (a free tier too is still paid)', () async {
      expect(await search(price: PriceFilter.paid), ['percent', 'jazz']);
    });
  });

  test('format: online, or in person', () async {
    expect(await search(format: FormatFilter.online), ['online']);
    expect(await search(format: FormatFilter.inPerson), [
      'ongoing',
      'percent',
      'jazz',
      'snake',
    ]);
  });

  test(
    'your RSVP: an active ticket is going, a cancelled one is not',
    () async {
      final at = DateTime.utc(2026, 10, 20);
      await db.into(db.tickets).insert(ticket(eventId: 'jazz').toRow());
      await db
          .into(db.tickets)
          .insert(
            ticket(
              id: 't2',
              eventId: 'online',
              code: 'EVT-H4TW-8RCW',
              cancelledAt: at,
            ).toRow(),
          );

      expect(await search(rsvp: RsvpFilter.going), ['jazz']);
      expect(await search(rsvp: RsvpFilter.notGoing), [
        'ongoing',
        'online',
        'percent',
        'snake',
      ]);
    },
  );

  test('every filter at once narrows to what fits them all', () async {
    expect(
      await search(
        text: 'l',
        categories: {EventCategory.music, EventCategory.technology},
        price: PriceFilter.paid,
        format: FormatFilter.inPerson,
        rsvp: RsvpFilter.notGoing,
        from: DateTime.utc(2026, 10, 23),
        until: DateTime.utc(2026, 10, 26),
      ),
      ['jazz'],
    );
  });

  test('results follow a save, like every list', () async {
    final stream = dao.watchSearch(SearchCriteria(text: 'jazz', now: demoNow));
    final emitted = <bool>[];
    final subscription = stream.listen(
      (rows) => emitted.add(rows.single.isSaved),
    );
    addTearDown(subscription.cancel);
    await pumpEventQueue();

    await db.savedEventsDao.save('jazz', DateTime.utc(2026, 10, 20));
    await pumpEventQueue();

    expect(emitted, [false, true]);
  });

  test('saved cards: only those saved, soonest first', () async {
    final at = DateTime.utc(2026, 10, 20);
    await db.savedEventsDao.save('snake', at);
    await db.savedEventsDao.save('past', at);

    final saved = await dao.watchSavedCards().first;

    expect([for (final row in saved) row.event.id], ['past', 'snake']);
    expect(saved.every((row) => row.isSaved), isTrue);
  });

  test('escaping: the escape character itself is escaped', () {
    expect(EventsDao.escapeLike(r'50%_\'), r'50\%\_\\');
  });
}
