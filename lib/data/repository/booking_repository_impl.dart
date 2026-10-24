import 'package:clock/clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/tickets_dao.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/data/mapper/booking_mappers.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/data/repository/api_guard.dart';
import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/domain/repository/booking_repository.dart';
import 'package:injectable/injectable.dart';

/// Server first, then the database. A booking is not the user's own note
/// (like a save): only the server can grant a place, so there are no
/// optimistic tickets. The server's answer is checked before anything is
/// written, and then the ticket and the event's counts land together.
@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._api, this._tickets, this._clock);

  final EventlyApi _api;
  final TicketsDao _tickets;
  final Clock _clock;

  @override
  Future<Result<Ticket>> rsvp(
    String eventId, {
    required TicketType type,
    String note = '',
  }) => guardApiCall('Booking $eventId', () async {
    final booking = await _api.rsvp(
      RsvpRequestDto(eventId: eventId, type: type, note: note),
    );
    final ticket = booking.ticket.toTicket();
    final event = booking.event.toEvent();
    if (ticket.eventId != eventId || event.id != eventId) {
      throw const FormatException('Booking: the answer is for another event');
    }
    await _tickets.book(ticket.toRow(), Catalog(events: [event]).toRows());
    return ticket;
  });

  @override
  Future<Result<void>> cancel(TicketItem item) =>
      guardApiCall('Cancelling ${item.ticket.id}', () async {
        final answer = await _api.cancelRsvp(
          CancelRequestDto(
            ticketId: item.ticket.id,
            eventId: item.event.id,
            type: item.ticket.type,
          ),
        );
        final event = answer.toEvent();
        await _tickets.cancel(
          item.ticket.id,
          _clock.now().toUtc(),
          Catalog(events: [event]).toRows(),
        );
      });

  @override
  Stream<List<TicketItem>> watchTickets() => _tickets.watchAll().map(
    (rows) => [for (final row in rows) row.toDomain()],
  );

  @override
  Stream<TicketItem?> watchTicket(String ticketId) =>
      _tickets.watchOne(ticketId).map((row) => row?.toDomain());
}
