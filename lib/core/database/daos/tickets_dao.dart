import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'tickets_dao.g.dart';

/// A ticket with its event, its event's offers and organizer.
class TicketWithEventRow {
  const TicketWithEventRow({
    required this.ticket,
    required this.event,
    required this.offers,
    required this.organizerName,
  });

  final TicketRow ticket;
  final EventRow event;
  final List<TicketOfferRow> offers;
  final String organizerName;
}

/// Tickets: read with their events, and written only from the server's
/// answers.
///
/// A booking writes the new ticket *and* the event as the server now has it
/// (one place fewer) in **one transaction**: the app never shows a ticket
/// beside a place count that doesn't include it, or the reverse.
@DriftAccessor(tables: [Tickets, Events, Organizers, TicketOffers])
class TicketsDao extends DatabaseAccessor<AppDatabase> with _$TicketsDaoMixin {
  TicketsDao(super.attachedDatabase);

  /// Every ticket, by its event's start.
  Stream<List<TicketWithEventRow>> watchAll() =>
      _query().watch().asyncMap(_withOffers);

  /// One ticket, or `null`.
  Stream<TicketWithEventRow?> watchOne(String ticketId) =>
      (_query()..where(tickets.id.equals(ticketId))).watch().asyncMap(
        (rows) async => (await _withOffers(rows)).firstOrNull,
      );

  /// Writes a confirmed booking: [ticket], and its event as [event] says.
  Future<void> book(TicketRow ticket, CatalogRows event) =>
      transaction(() async {
        await into(tickets).insert(ticket);
        await attachedDatabase.catalogDao.upsertCatalog(event);
      });

  /// Writes a confirmed cancellation: the ticket cancelled [at], and its
  /// event as [event] says.
  Future<void> cancel(String ticketId, DateTime at, CatalogRows event) =>
      transaction(() async {
        await (update(tickets)
              ..where((t) => t.id.equals(ticketId) & t.cancelledAt.isNull()))
            .write(TicketsCompanion(cancelledAt: Value(at)));
        await attachedDatabase.catalogDao.upsertCatalog(event);
      });

  JoinedSelectStatement<HasResultSet, dynamic> _query() =>
      select(tickets).join([
        innerJoin(events, events.id.equalsExp(tickets.eventId)),
        innerJoin(organizers, organizers.id.equalsExp(events.organizerId)),
      ])..orderBy([
        OrderingTerm(expression: events.startsAt),
        OrderingTerm(expression: tickets.bookedAt),
      ]);

  Future<List<TicketWithEventRow>> _withOffers(List<TypedResult> rows) async {
    if (rows.isEmpty) return const [];
    final ids = {for (final row in rows) row.readTable(events).id};
    final offers =
        await (select(ticketOffers)
              ..where((o) => o.eventId.isIn(ids))
              ..orderBy([(o) => OrderingTerm(expression: o.sortOrder)]))
            .get();
    return [
      for (final row in rows)
        TicketWithEventRow(
          ticket: row.readTable(tickets),
          event: row.readTable(events),
          offers: [
            for (final offer in offers)
              if (offer.eventId == row.readTable(events).id) offer,
          ],
          organizerName: row.readTable(organizers).name,
        ),
    ];
  }
}
