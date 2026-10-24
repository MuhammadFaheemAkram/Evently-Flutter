import 'package:drift/native.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';
import '../../helpers/user_data_fixtures.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = newTestDatabase();
    await db.catalogDao.upsertCatalog(catalogOf([event()]).toRows());
  });

  tearDown(() => db.close());

  CatalogRows eventWith({required int remaining}) => catalogOf([
    event(offers: [freeOffer.copyWith(remaining: remaining)]),
  ]).toRows();

  Future<int> remaining() async =>
      (await db.select(db.ticketOffers).getSingle()).remaining;

  test('a booking writes the ticket and the new counts', () async {
    await db.ticketsDao.book(ticket().toRow(), eventWith(remaining: 89));

    expect(await db.select(db.tickets).get(), hasLength(1));
    expect(await remaining(), 89);
  });

  test(
    'when the counts are refused, the ticket goes too: one transaction',
    () async {
      final rows = eventWith(remaining: 89);
      final broken = CatalogRows(
        events: [
          rows.events.single.copyWith(endsAt: rows.events.single.startsAt),
        ],
        offers: rows.offers,
      );

      await expectLater(
        db.ticketsDao.book(ticket().toRow(), broken),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.tickets).get(), isEmpty);
      expect(await remaining(), 90);
    },
  );

  test('a cancellation marks the ticket and gives the place back', () async {
    await db.ticketsDao.book(ticket().toRow(), eventWith(remaining: 89));
    final at = DateTime.utc(2026, 10, 21, 14);

    await db.ticketsDao.cancel('t1', at, eventWith(remaining: 90));

    final row = await db.select(db.tickets).getSingle();
    expect(row.cancelledAt, at);
    expect(await remaining(), 90);
  });

  test('cancelling twice keeps the first time', () async {
    await db.ticketsDao.book(ticket().toRow(), eventWith(remaining: 89));
    final first = DateTime.utc(2026, 10, 21, 14);

    await db.ticketsDao.cancel('t1', first, eventWith(remaining: 90));
    await db.ticketsDao.cancel(
      't1',
      first.add(const Duration(hours: 1)),
      eventWith(remaining: 90),
    );

    expect((await db.select(db.tickets).getSingle()).cancelledAt, first);
  });

  test('tickets come with their event, by its start', () async {
    await db.ticketsDao.book(ticket().toRow(), eventWith(remaining: 89));

    final rows = await db.ticketsDao.watchAll().first;

    expect(rows.single.event.id, 'ev_1');
    expect(rows.single.offers.single.remaining, 89);
    expect(rows.single.organizerName, 'Organizer org_1');
    expect(rows.single.event.toDomain(rows.single.offers), isA<Event>());
  });
}
