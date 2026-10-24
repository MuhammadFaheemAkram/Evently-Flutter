import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/domain/model/search_criteria.dart';

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

  /// The events you saved, soonest first.
  Stream<List<EventCardRow>> watchSavedCards() =>
      (_cards()..where(savedEvents.eventId.isNotNull())).watch().asyncMap(
        _withOffers,
      );

  /// The upcoming events matching [criteria], soonest first: one query, with
  /// every filter a `WHERE` clause.
  ///
  /// The text matches the title, the organizer's name, the venue or the
  /// city, ignoring case (SQLite's `LIKE` does, for ASCII letters). The
  /// user's `%` and `_` are escaped: "50%" finds "50%", not everything
  /// starting with "50".
  Stream<List<EventCardRow>> watchSearch(SearchCriteria criteria) {
    final query = _cards()..where(_matches(criteria));
    return query.watch().asyncMap(_withOffers);
  }

  Expression<bool> _matches(SearchCriteria criteria) {
    final conditions = <Expression<bool>>[
      // Over is over: Search finds what you can still go to.
      events.endsAt.isBiggerThanValue(criteria.now),
    ];
    final text = criteria.text;
    if (text.isNotEmpty) {
      final pattern = '%${escapeLike(text)}%';
      Expression<bool> like(Expression<String> column) =>
          column.like(pattern, escapeChar: likeEscape);
      conditions.add(
        like(events.title) |
            like(organizers.name) |
            like(events.venueName) |
            like(events.city),
      );
    }
    if (criteria.categories.isNotEmpty) {
      conditions.add(events.category.isInValues(criteria.categories));
    }
    // An event overlapping the window: it starts before the window ends and
    // ends after it begins (an ongoing event counts for "Today").
    if (criteria.until case final until?) {
      conditions.add(events.startsAt.isSmallerThanValue(until));
    }
    if (criteria.from case final from?) {
      conditions.add(events.endsAt.isBiggerThanValue(from));
    }
    // Paid: some offer has a price. Free: none has.
    final paidOffer = existsQuery(
      select(ticketOffers)..where(
        (o) =>
            o.eventId.equalsExp(events.id) & o.priceMinor.isBiggerThanValue(0),
      ),
    );
    switch (criteria.price) {
      case PriceFilter.any:
        break;
      case PriceFilter.free:
        conditions.add(paidOffer.not());
      case PriceFilter.paid:
        conditions.add(paidOffer);
    }
    switch (criteria.format) {
      case FormatFilter.any:
        break;
      case FormatFilter.online:
        conditions.add(events.joinUrl.isNotNull());
      case FormatFilter.inPerson:
        conditions.add(events.joinUrl.isNull());
    }
    switch (criteria.rsvp) {
      case RsvpFilter.any:
        break;
      // The LEFT JOIN found an active ticket, or didn't.
      case RsvpFilter.going:
        conditions.add(tickets.id.isNotNull());
      case RsvpFilter.notGoing:
        conditions.add(tickets.id.isNull());
    }
    return Expression.and(conditions);
  }

  static const likeEscape = r'\';

  /// [text] with `LIKE`'s wildcards (and the escape character itself)
  /// escaped.
  static String escapeLike(String text) => text.replaceAllMapped(
    RegExp(r'[\\%_]'),
    (match) => '$likeEscape${match[0]}',
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
