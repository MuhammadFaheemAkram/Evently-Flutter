import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';

// The rules the database itself enforces: whatever code writes, these rows
// can't exist.
void main() {
  late AppDatabase db;
  late EventRow eventRow;
  late SessionRow sessionRow;
  final at = DateTime.utc(2026, 10, 20, 9);

  setUp(() async {
    db = newTestDatabase();
    final rows = catalogOf([event()], sessions: [session()]).toRows();
    await db.catalogDao.upsertCatalog(rows);
    eventRow = rows.events.single;
    sessionRow = rows.sessions.single;
  });

  tearDown(() => db.close());

  Matcher refused() => throwsA(isA<SqliteException>());

  Future<void> insertEvent(EventRow row) => db.into(db.events).insert(row);

  EventRow anotherEvent() => eventRow.copyWith(id: 'ev_2');

  TicketsCompanion ticket(String id, {String? code, DateTime? cancelledAt}) =>
      TicketsCompanion.insert(
        id: id,
        eventId: 'ev_1',
        code: code ?? 'CODE-$id',
        type: TicketType.free,
        bookedAt: at,
        cancelledAt: Value(cancelledAt),
      );

  group('events', () {
    test('foreign keys are on: an unknown organizer is refused', () {
      expect(
        insertEvent(anotherEvent().copyWith(organizerId: 'org_nobody')),
        refused(),
      );
    });

    test('instants must be UTC: a local time is refused', () {
      expect(
        insertEvent(
          anotherEvent().copyWith(startsAt: DateTime(2026, 10, 24, 18)),
        ),
        refused(),
      );
      expect(
        insertEvent(
          anotherEvent().copyWith(
            status: EventStatus.moved,
            previousStartsAt: Value(DateTime(2026, 10, 23, 18)),
          ),
        ),
        refused(),
      );
    });

    test('an event ends after it starts', () {
      expect(
        insertEvent(anotherEvent().copyWith(endsAt: eventRow.startsAt)),
        refused(),
      );
    });

    test('no more attendees than places', () {
      expect(
        insertEvent(anotherEvent().copyWith(attendeeCount: 101)),
        refused(),
      );
    });

    test('a venue (name, address and city) or a link, never both, never '
        'neither', () {
      final link = Value(Uri.parse('https://meet.example/a'));
      expect(insertEvent(anotherEvent().copyWith(joinUrl: link)), refused());
      expect(
        insertEvent(
          anotherEvent().copyWith(
            venueName: const Value(null),
            venueAddress: const Value(null),
            city: const Value(null),
          ),
        ),
        refused(),
      );
      expect(
        insertEvent(
          anotherEvent().copyWith(
            venueName: const Value(null),
            venueAddress: const Value(null),
            joinUrl: link,
          ),
        ),
        refused(),
        reason: 'an online event with a city',
      );
    });

    test('a valid one goes in', () async {
      await insertEvent(anotherEvent());
      expect(await db.select(db.events).get(), hasLength(2));
    });
  });

  group('ticket offers', () {
    TicketOfferRow offer() => const TicketOfferRow(
      eventId: 'ev_1',
      type: TicketType.vip,
      priceMinor: 5000,
      currency: 'GBP',
      capacity: 10,
      remaining: 10,
      sortOrder: 1,
    );

    Future<void> insert(TicketOfferRow row) =>
        db.into(db.ticketOffers).insert(row);

    test('places left between 0 and the places', () {
      expect(insert(offer().copyWith(remaining: 11)), refused());
      expect(insert(offer().copyWith(remaining: -1)), refused());
    });

    test('a price ≥ 0 and a three-letter currency', () {
      expect(insert(offer().copyWith(priceMinor: -1)), refused());
      expect(insert(offer().copyWith(currency: 'GB')), refused());
    });

    test('one offer per ticket type', () {
      expect(insert(offer().copyWith(type: TicketType.free)), refused());
    });
  });

  group('deleting an event no one points at', () {
    test('takes its offers and sessions, and their bookmarks', () async {
      await db
          .into(db.sessionBookmarks)
          .insert(SessionBookmarkRow(sessionId: sessionRow.id, createdAt: at));

      await (db.delete(db.events)..where((t) => t.id.equals('ev_1'))).go();

      expect(await db.select(db.ticketOffers).get(), isEmpty);
      expect(await db.select(db.sessions).get(), isEmpty);
      expect(await db.select(db.sessionBookmarks).get(), isEmpty);
    });
  });

  group("the user's rows keep their event", () {
    Future<void> deleteEvent() =>
        (db.delete(db.events)..where((t) => t.id.equals('ev_1'))).go();

    test('a saved event', () async {
      await db
          .into(db.savedEvents)
          .insert(SavedEventRow(eventId: 'ev_1', savedAt: at));
      await expectLater(deleteEvent(), refused());
    });

    test('a ticket, even a cancelled one', () async {
      await db.into(db.tickets).insert(ticket('t1', cancelledAt: at));
      await expectLater(deleteEvent(), refused());
    });

    test('a reminder and a change alert', () async {
      await db
          .into(db.eventReminders)
          .insert(const EventReminderRow(eventId: 'ev_1', enabled: true));
      await expectLater(deleteEvent(), refused());
      await db.delete(db.eventReminders).go();

      await db
          .into(db.eventChanges)
          .insert(
            EventChangesCompanion.insert(
              eventId: 'ev_1',
              kind: EventChangeKind.moved,
              detectedAt: at,
            ),
          );
      await expectLater(deleteEvent(), refused());
    });

    test('a followed organizer', () async {
      await db
          .into(db.followedOrganizers)
          .insert(FollowRow(organizerId: 'org_1', followedAt: at));
      await expectLater(
        (db.delete(db.organizers)..where((t) => t.id.equals('org_1'))).go(),
        refused(),
      );
    });

    test('and the refusal changes nothing', () async {
      await db
          .into(db.savedEvents)
          .insert(SavedEventRow(eventId: 'ev_1', savedAt: at));
      await expectLater(deleteEvent(), refused());

      expect(await db.select(db.events).get(), hasLength(1));
      expect(await db.select(db.ticketOffers).get(), hasLength(1));
      expect(await db.select(db.sessions).get(), hasLength(1));
    });
  });

  group('tickets', () {
    test('one active ticket per event', () async {
      await db.into(db.tickets).insert(ticket('t1'));
      await expectLater(db.into(db.tickets).insert(ticket('t2')), refused());
    });

    test('after cancelling, you can book again', () async {
      await db.into(db.tickets).insert(ticket('t1', cancelledAt: at));
      await db.into(db.tickets).insert(ticket('t2'));
      expect(await db.select(db.tickets).get(), hasLength(2));
    });

    test('codes are unique', () async {
      await db.into(db.tickets).insert(ticket('t1', cancelledAt: at));
      await expectLater(
        db.into(db.tickets).insert(ticket('t2', code: 'CODE-t1')),
        refused(),
      );
    });

    test('times are UTC', () {
      expect(
        db
            .into(db.tickets)
            .insert(ticket('t1').copyWith(bookedAt: Value(DateTime(2026)))),
        refused(),
      );
    });
  });

  test("the user's other instants are UTC too", () {
    expect(
      db
          .into(db.savedEvents)
          .insert(SavedEventRow(eventId: 'ev_1', savedAt: DateTime(2026))),
      refused(),
    );
    expect(
      db
          .into(db.recentSearches)
          .insert(RecentSearchRow(query: 'jazz', searchedAt: DateTime(2026))),
      refused(),
    );
  });

  test('one profile at most', () async {
    await db
        .into(db.profiles)
        .insert(const ProfileRow(id: 1, name: 'Sara', email: 's@example.com'));
    await expectLater(
      db
          .into(db.profiles)
          .insert(const ProfileRow(id: 2, name: 'Ali', email: 'a@example.com')),
      refused(),
    );
  });
}
