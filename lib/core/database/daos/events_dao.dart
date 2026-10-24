import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'events_dao.g.dart';

/// An event as a list reads it: its row, its offers, its organizer's name,
/// and the user's own rows about it.
class EventCardRow {
  const EventCardRow({
    required this.event,
    required this.offers,
    required this.organizerName,
    required this.isSaved,
    this.activeTicketId,
  });

  final EventRow event;
  final List<TicketOfferRow> offers;
  final String organizerName;
  final bool isSaved;

  /// The user's active ticket for it, if any.
  final String? activeTicketId;
}

/// Reads events together with the user's rows about them: the place where
/// the catalog and the user's tables meet. It writes nothing.
///
/// "Saved" and "going" are LEFT JOINs over the user's tables (a saved row,
/// a ticket not cancelled), not columns of `events`: a refresh rewrites the
/// event and can't lose them. Each join matches at most one row (the saved
/// table's key, the one-active-ticket index), so an event is never listed
/// twice. Because the joined tables are part of the query, drift re-runs it
/// when the user saves an event or books one, not only on a refresh.
@DriftAccessor(
  tables: [Events, Organizers, TicketOffers, Sessions, SavedEvents, Tickets],
)
class EventsDao extends DatabaseAccessor<AppDatabase> with _$EventsDaoMixin {
  EventsDao(super.attachedDatabase);

  /// Every cached event, soonest first, kept current.
  Stream<List<EventCardRow>> watchCards() =>
      _cards().watch().asyncMap(_withOffers);

  /// One event, or `null` once it isn't cached.
  Stream<EventCardRow?> watchCard(String eventId) =>
      (_cards()..where(events.id.equals(eventId))).watch().asyncMap(
        (rows) async => (await _withOffers(rows)).firstOrNull,
      );

  Future<OrganizerRow?> organizer(String id) =>
      (select(organizers)..where((o) => o.id.equals(id))).getSingleOrNull();

  /// The first [limit] sessions of an event, in time order, and how many it
  /// has.
  Future<(List<SessionRow>, int)> agendaPreview(
    String eventId, {
    required int limit,
  }) async {
    final count = sessions.id.count();
    final total =
        await (selectOnly(sessions)
              ..addColumns([count])
              ..where(sessions.eventId.equals(eventId)))
            .map((row) => row.read(count)!)
            .getSingle();
    final first =
        await (select(sessions)
              ..where((s) => s.eventId.equals(eventId))
              ..orderBy([(s) => OrderingTerm(expression: s.startsAt)])
              ..limit(limit))
            .get();
    return (first, total);
  }

  JoinedSelectStatement<HasResultSet, dynamic> _cards() =>
      select(events).join([
        innerJoin(organizers, organizers.id.equalsExp(events.organizerId)),
        leftOuterJoin(savedEvents, savedEvents.eventId.equalsExp(events.id)),
        leftOuterJoin(
          tickets,
          tickets.eventId.equalsExp(events.id) & tickets.cancelledAt.isNull(),
        ),
      ])..orderBy([
        OrderingTerm(expression: events.startsAt),
        OrderingTerm(expression: events.id),
      ]);

  /// Each event's offers, in one query for the whole list. Offers change
  /// only with their event (in the same transaction), so the event query's
  /// stream is the trigger for both.
  Future<List<EventCardRow>> _withOffers(List<TypedResult> rows) async {
    if (rows.isEmpty) return const [];
    final ids = [for (final row in rows) row.readTable(events).id];
    final offers =
        await (select(ticketOffers)
              ..where((o) => o.eventId.isIn(ids))
              ..orderBy([(o) => OrderingTerm(expression: o.sortOrder)]))
            .get();
    final byEvent = <String, List<TicketOfferRow>>{};
    for (final offer in offers) {
      (byEvent[offer.eventId] ??= []).add(offer);
    }
    return [
      for (final row in rows)
        EventCardRow(
          event: row.readTable(events),
          offers: byEvent[row.readTable(events).id] ?? const [],
          organizerName: row.readTable(organizers).name,
          isSaved: row.readTableOrNull(savedEvents) != null,
          activeTicketId: row.readTableOrNull(tickets)?.id,
        ),
    ];
  }
}
