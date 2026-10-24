import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/ticket_item.dart';

/// Bookings: confirmed by the server before anything is written.
abstract interface class BookingRepository {
  /// Asks the server for a [type] place at [eventId]; on its answer, writes
  /// the ticket and the event's new counts in one transaction. On any
  /// failure nothing is written.
  Future<Result<Ticket>> rsvp(
    String eventId, {
    required TicketType type,
    String note = '',
  });

  /// Asks the server to cancel [item]'s ticket; on its answer, marks the
  /// ticket cancelled and writes the event's new counts, in one
  /// transaction.
  Future<Result<void>> cancel(TicketItem item);

  /// Every ticket with its event, by the event's start, kept current.
  Stream<List<TicketItem>> watchTickets();

  /// One ticket, or `null` when there's no such ticket.
  Stream<TicketItem?> watchTicket(String ticketId);
}
