import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';
import '../../helpers/user_data_fixtures.dart';

void main() {
  late AppDatabase db;
  late EventsDao dao;
  final at = DateTime.utc(2026, 10, 20, 9);

  EventTime startingAt(int hourUtc) => EventTime(
    start: DateTime.utc(2026, 10, 24, hourUtc),
    end: DateTime.utc(2026, 10, 24, hourUtc + 1),
    zone: 'Europe/London',
  );

  setUp(() async {
    db = newTestDatabase();
    dao = db.eventsDao;
    await db.catalogDao.upsertCatalog(
      catalogOf(
        [
          event(id: 'ev_late', time: startingAt(20)),
          event(
            id: 'ev_early',
            time: startingAt(9),
            offers: [
              const TicketOffer(
                type: TicketType.vip,
                priceMinor: 4500,
                currency: 'GBP',
                capacity: 20,
                remaining: 6,
              ),
              freeOffer,
            ],
          ),
        ],
        sessions: [
          for (var i = 0; i < 5; i++)
            session(id: 'ses_$i', eventId: 'ev_early').copyWith(
              start: DateTime.utc(2026, 10, 24, 9, i * 10),
              end: DateTime.utc(2026, 10, 24, 9, i * 10 + 10),
            ),
        ],
      ).toRows(),
    );
  });

  tearDown(() => db.close());

  test('every event, soonest first, with its organizer and offers in the '
      "server's order", () async {
    final cards = await dao.watchCards().first;

    expect([for (final c in cards) c.event.id], ['ev_early', 'ev_late']);
    expect(cards.first.organizerName, 'Organizer org_1');
    expect(
      [for (final o in cards.first.offers) o.type],
      [TicketType.vip, TicketType.free],
    );
    expect(cards.first.isSaved, isFalse);
    expect(cards.first.activeTicketId, isNull);
  });

  test('saved and going are joins over your own rows', () async {
    await db
        .into(db.savedEvents)
        .insert(SavedEventRow(eventId: 'ev_late', savedAt: at));
    await db.into(db.tickets).insert(ticket(eventId: 'ev_late').toRow());

    final late = (await dao.watchCards().first).last;

    expect(late.isSaved, isTrue);
    expect(late.activeTicketId, 't1');
  });

  test('a cancelled ticket is not going, and lists the event once', () async {
    await db
        .into(db.tickets)
        .insert(ticket(eventId: 'ev_late', cancelledAt: at).toRow());
    await db
        .into(db.tickets)
        .insert(
          ticket(id: 't2', eventId: 'ev_late', code: 'EVT-H4TW-8RCU').toRow(),
        );

    final cards = await dao.watchCards().first;

    expect(cards, hasLength(2));
    expect(cards.last.activeTicketId, 't2');
  });

  test(
    'the list follows your saves and bookings, not only refreshes',
    () async {
      final emitted = <List<EventCardRow>>[];
      final subscription = dao.watchCards().listen(emitted.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      await db.savedEventsDao.save('ev_early', at);
      await pumpEventQueue();
      await db.into(db.tickets).insert(ticket(eventId: 'ev_early').toRow());
      await pumpEventQueue();
      await db.savedEventsDao.unsave('ev_early');
      await pumpEventQueue();

      expect(
        [
          for (final cards in emitted)
            (cards.first.isSaved, cards.first.activeTicketId),
        ],
        [(false, null), (true, null), (true, 't1'), (false, 't1')],
      );
    },
  );

  test('one event, or null when it is not cached', () async {
    expect((await dao.watchCard('ev_late').first)?.event.id, 'ev_late');
    expect(await dao.watchCard('ev_nowhere').first, isNull);
  });

  test("an agenda preview: the first sessions, and the whole agenda's "
      'size', () async {
    final (sessions, count) = await dao.agendaPreview('ev_early', limit: 3);

    expect([for (final s in sessions) s.id], ['ses_0', 'ses_1', 'ses_2']);
    expect(count, 5);
    final (none, zero) = await dao.agendaPreview('ev_late', limit: 3);
    expect(none, isEmpty);
    expect(zero, 0);
  });

  test('saving twice keeps the first time', () async {
    await db.savedEventsDao.save('ev_late', at);
    await db.savedEventsDao.save('ev_late', at.add(const Duration(days: 1)));

    final saved = await db.select(db.savedEvents).get();
    expect(saved.single.savedAt, at);
  });

  test('a refresh rewrites the event and keeps what you did', () async {
    await db.savedEventsDao.save('ev_late', at);
    await db.into(db.tickets).insert(ticket(eventId: 'ev_late').toRow());

    await db.catalogDao.upsertCatalog(
      catalogOf([event(id: 'ev_late', title: 'Renamed', time: startingAt(20))])
          .toRows(),
    );

    final late = (await dao.watchCard('ev_late').first)!;
    expect(late.event.title, 'Renamed');
    expect(late.isSaved, isTrue);
    expect(late.activeTicketId, 't1');
  });
}
