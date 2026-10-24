import 'package:drift/native.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';

void main() {
  late AppDatabase db;
  late CatalogDao dao;
  final at = DateTime.utc(2026, 10, 20, 9);

  setUp(() {
    db = newTestDatabase();
    dao = db.catalogDao;
  });

  tearDown(() => db.close());

  Future<void> write(Catalog catalog) => dao.upsertCatalog(catalog.toRows());

  Future<Catalog> cached() async => (await dao.readAll()).toCatalog();

  test('what goes in comes back out, the same', () async {
    final catalog = catalogOf(
      [
        event(
          offers: [
            freeOffer,
            const TicketOffer(
              type: TicketType.vip,
              priceMinor: 4500,
              currency: 'GBP',
              capacity: 20,
              remaining: 6,
            ),
          ],
        ),
        event(id: 'ev_2', location: onlineAt('https://meet.example/a')),
        event(
          id: 'ev_3',
          status: EventStatus.moved,
          previousStart: DateTime.utc(2026, 10, 23, 17, 30),
        ),
      ],
      sessions: [
        session(),
        session(id: 'ses_2'),
      ],
    );

    await write(catalog);

    expect(await cached(), catalog);
  });

  test('offers come back in the server\'s order, not the type\'s', () async {
    const vip = TicketOffer(
      type: TicketType.vip,
      priceMinor: 4500,
      currency: 'GBP',
      capacity: 20,
      remaining: 6,
    );
    await write(
      catalogOf([
        event(offers: [vip, freeOffer]),
      ]),
    );

    expect((await cached()).events.single.offers, [vip, freeOffer]);
  });

  group('a refresh', () {
    test('updates rows in place, and keeps every row of the user\'s', () async {
      await write(catalogOf([event()], sessions: [session()]));
      await db
          .into(db.savedEvents)
          .insert(SavedEventRow(eventId: 'ev_1', savedAt: at));
      await db
          .into(db.tickets)
          .insert(
            TicketsCompanion.insert(
              id: 't1',
              eventId: 'ev_1',
              code: 'EVT-7KQ2-M9XX',
              type: TicketType.free,
              bookedAt: at,
            ),
          );
      await db
          .into(db.sessionBookmarks)
          .insert(SessionBookmarkRow(sessionId: 'ses_1', createdAt: at));
      await db
          .into(db.followedOrganizers)
          .insert(FollowRow(organizerId: 'org_1', followedAt: at));

      await write(
        catalogOf(
          [event(title: 'Renamed')],
          sessions: [session(title: 'Moved talk')],
        ),
      );

      expect((await cached()).events.single.title, 'Renamed');
      expect((await cached()).sessions.single.title, 'Moved talk');
      expect(await db.select(db.savedEvents).get(), hasLength(1));
      expect(await db.select(db.tickets).get(), hasLength(1));
      expect(await db.select(db.sessionBookmarks).get(), hasLength(1));
      expect(await db.select(db.followedOrganizers).get(), hasLength(1));
    });

    test(
      'writes nulls too: an event that moved online loses its venue',
      () async {
        await write(catalogOf([event()]));

        await write(
          catalogOf([event(location: onlineAt('https://meet.example/a'))]),
        );

        final row = (await db.select(db.events).get()).single;
        expect(row.venueName, isNull);
        expect(row.city, isNull);
        expect(row.joinUrl, Uri.parse('https://meet.example/a'));
      },
    );

    test(
      'writes nulls too: an event no longer moved forgets when it was',
      () async {
        await write(
          catalogOf([
            event(
              status: EventStatus.moved,
              previousStart: DateTime.utc(2026, 10, 23, 17, 30),
            ),
          ]),
        );

        await write(catalogOf([event()]));

        expect((await cached()).events.single.previousStart, isNull);
      },
    );

    test(
      'never deletes an event, even one the server stopped sending',
      () async {
        await write(catalogOf([event(), event(id: 'ev_2')]));

        await write(catalogOf([event()]));

        expect((await cached()).events.map((e) => e.id), ['ev_1', 'ev_2']);
      },
    );

    test(
      "rewrites an event's offers: one the server dropped is gone",
      () async {
        const vip = TicketOffer(
          type: TicketType.vip,
          priceMinor: 4500,
          currency: 'GBP',
          capacity: 20,
          remaining: 6,
        );
        await write(
          catalogOf([
            event(offers: [freeOffer, vip]),
          ]),
        );

        await write(
          catalogOf([
            event(offers: [vip]),
          ]),
        );

        expect((await cached()).events.single.offers, [vip]);
      },
    );

    test("leaves the offers of events it doesn't carry", () async {
      await write(catalogOf([event(), event(id: 'ev_2')]));

      await write(catalogOf([event(id: 'ev_2')]));

      final offers = await db.select(db.ticketOffers).get();
      expect(offers.map((o) => o.eventId), unorderedEquals(['ev_1', 'ev_2']));
    });

    test('lands completely or not at all', () async {
      await write(catalogOf([event(title: 'Before')]));
      final rows = catalogOf([event(title: 'After'), event(id: 'ev_2')])
          .toRows();
      final broken = CatalogRows(
        organizers: rows.organizers,
        events: [
          rows.events.first,
          // Ends as it starts: the CHECK refuses it, after the first event
          // was already written in the same transaction.
          rows.events.last.copyWith(endsAt: rows.events.last.startsAt),
        ],
        offers: rows.offers,
      );

      await expectLater(
        dao.upsertCatalog(broken),
        throwsA(isA<SqliteException>()),
      );

      final catalog = await cached();
      expect(catalog.events.map((e) => (e.id, e.title)), [('ev_1', 'Before')]);
    });
  });

  test('cities: in-person events only, each once, A to Z', () async {
    await write(
      catalogOf([
        event(location: venueIn('London')),
        event(id: 'ev_2', location: venueIn('Berlin')),
        event(id: 'ev_3', location: venueIn('London')),
        event(id: 'ev_4', location: onlineAt('https://meet.example/a')),
        event(id: 'ev_5', location: venueIn('New York')),
      ]),
    );

    expect(await dao.cities(), ['Berlin', 'London', 'New York']);
  });

  test('cities of an empty cache: none', () async {
    expect(await dao.cities(), isEmpty);
  });
}
