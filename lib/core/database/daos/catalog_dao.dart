import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'catalog_dao.g.dart';

/// The catalog's rows, as one refresh writes them.
class CatalogRows {
  const CatalogRows({
    this.organizers = const [],
    this.events = const [],
    this.offers = const [],
    this.sessions = const [],
  });

  final List<OrganizerRow> organizers;
  final List<EventRow> events;
  final List<TicketOfferRow> offers;
  final List<SessionRow> sessions;
}

/// Reads and writes the cached catalog. Never touches the user's tables.
@DriftAccessor(tables: [Organizers, Events, TicketOffers, Sessions])
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.attachedDatabase);

  /// Writes [rows] over the cache in **one transaction**: every row lands, or
  /// none does (a refresh that fails half-way leaves yesterday's cache).
  ///
  /// - **Upserts, never `REPLACE`:** `INSERT OR REPLACE` deletes the old row
  ///   first, and that delete would cascade into, or be refused because of,
  ///   the user's rows pointing at it (conventions §11.53). `ON CONFLICT DO
  ///   UPDATE` changes the row in place.
  /// - **Every column is written, nulls too:** the update is a companion
  ///   built with `nullToAbsent: false`, so an event that moved online loses
  ///   its venue (a row object would leave null columns as they were,
  ///   §11.57, and the venue/online `CHECK` would then refuse it).
  /// - **Nothing is deleted,** except an event's ticket offers, which are
  ///   part of the event and rewritten with it (nothing of the user's points
  ///   at an offer). An event missing from a newer catalog stays; Phase 7
  ///   marks it cancelled.
  Future<void> upsertCatalog(CatalogRows rows) {
    return transaction(() async {
      for (final row in rows.organizers) {
        await into(organizers)
            .insert(row, onConflict: DoUpdate((_) => row.toCompanion(false)));
      }
      for (final row in rows.events) {
        await into(events)
            .insert(row, onConflict: DoUpdate((_) => row.toCompanion(false)));
      }
      final eventIds = {for (final row in rows.events) row.id};
      await (delete(ticketOffers)..where((t) => t.eventId.isIn(eventIds))).go();
      await batch((batch) => batch.insertAll(ticketOffers, rows.offers));
      for (final row in rows.sessions) {
        await into(sessions)
            .insert(row, onConflict: DoUpdate((_) => row.toCompanion(false)));
      }
    });
  }

  /// Clear cache: deletes the cached events nothing of the user's points
  /// at, and the organizers left with no event that nobody follows; their
  /// offers and sessions go with them (`CASCADE`). The next refresh fetches
  /// them again. Returns how many events went.
  ///
  /// An event the user saved, holds a ticket for (even a cancelled one),
  /// bookmarked a session of, asked a reminder for, or was alerted about
  /// stays: the user's rows point at it, and the foreign keys would refuse
  /// the delete anyway. Asking for exactly the rest means the delete never
  /// hits them.
  Future<int> clearUnowned() => transaction(() async {
    final owned = customSelect(
      'SELECT event_id FROM saved_events '
      'UNION SELECT event_id FROM tickets '
      'UNION SELECT event_id FROM event_reminders '
      'UNION SELECT event_id FROM event_changes '
      'UNION SELECT s.event_id FROM sessions s '
      'JOIN session_bookmarks b ON b.session_id = s.id',
    );
    final keep = {
      for (final row in await owned.get()) row.read<String>('event_id'),
    };
    final deleted = await (delete(
      events,
    )..where((e) => e.id.isNotIn(keep))).go();
    await customStatement(
      'DELETE FROM organizers WHERE id NOT IN (SELECT organizer_id FROM '
      'events) AND id NOT IN (SELECT organizer_id FROM followed_organizers)',
    );
    return deleted;
  });

  /// The cities with in-person events in the cache, A to Z.
  Future<List<String>> cities() async {
    final query = selectOnly(events, distinct: true)
      ..addColumns([events.city])
      ..where(events.city.isNotNull())
      ..orderBy([OrderingTerm(expression: events.city)]);
    return [for (final row in await query.get()) row.read(events.city)!];
  }

  /// Every cached row, in a stable order (for tests and, later, a backup).
  Future<CatalogRows> readAll() {
    return transaction(() async {
      return CatalogRows(
        organizers: await (select(
          organizers,
        )..orderBy([(t) => OrderingTerm(expression: t.id)])).get(),
        events: await (select(
          events,
        )..orderBy([(t) => OrderingTerm(expression: t.id)])).get(),
        offers:
            await (select(ticketOffers)..orderBy([
                  (t) => OrderingTerm(expression: t.eventId),
                  (t) => OrderingTerm(expression: t.sortOrder),
                ]))
                .get(),
        sessions: await (select(
          sessions,
        )..orderBy([(t) => OrderingTerm(expression: t.id)])).get(),
      );
    });
  }
}
