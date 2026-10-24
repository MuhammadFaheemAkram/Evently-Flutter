import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/calculation/rsvp_validation.dart';
import 'package:evently/domain/calculation/ticket_rules.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/domain/repository/booking_repository.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:injectable/injectable.dart';

/// Books a place: checks the form against the latest cached event (the
/// form may have been open a while), then asks the server. Once it
/// confirms, the RSVP confirmation is shown (when notifications are on).
@injectable
class RsvpEventUseCase {
  const RsvpEventUseCase(
    this._catalog,
    this._booking,
    this._clock,
    this._confirm,
  );

  final CatalogRepository _catalog;
  final BookingRepository _booking;
  final EventClock _clock;
  final ShowRsvpConfirmationUseCase _confirm;

  Future<Result<Ticket>> call(
    String eventId, {
    required TicketType? type,
    String note = '',
  }) async {
    final details = await _catalog.watchEventDetails(eventId).first;
    if (details == null) return const Err(NotFoundException('event'));
    final problem = validateRsvp(
      event: details.item.event,
      isGoing: details.item.isGoing,
      type: type,
      note: note,
      now: _clock.now(),
    );
    if (problem != null) {
      return Err(InvalidInputException(rsvpProblemMessage(problem)));
    }
    final result = await _booking.rsvp(eventId, type: type!, note: note.trim());
    if (result case Ok(value: final ticket)) {
      await _confirm(ticket, details.item.event);
    }
    return result;
  }
}

/// Cancels an RSVP, only before the event starts.
@injectable
class CancelRsvpUseCase {
  const CancelRsvpUseCase(this._booking, this._clock);

  final BookingRepository _booking;
  final EventClock _clock;

  Future<Result<void>> call(TicketItem item) async {
    final block = cancelBlock(item, now: _clock.now());
    if (block != null) {
      return Err(InvalidInputException(cancelBlockMessage(block)));
    }
    return _booking.cancel(item);
  }
}

@injectable
class WatchTicketsUseCase {
  const WatchTicketsUseCase(this._booking);

  final BookingRepository _booking;

  Stream<List<TicketItem>> call() => _booking.watchTickets();
}

@injectable
class WatchTicketUseCase {
  const WatchTicketUseCase(this._booking);

  final BookingRepository _booking;

  Stream<TicketItem?> call(String ticketId) => _booking.watchTicket(ticketId);
}

/// What the user reads when the form can't be sent.
String rsvpProblemMessage(RsvpProblem problem) => switch (problem) {
  RsvpClosed(:final block) => switch (block) {
    RsvpBlock.going => "You're already going.",
    RsvpBlock.cancelled => 'This event was cancelled.',
    RsvpBlock.ended => 'This event has ended.',
    RsvpBlock.started => 'Bookings closed when it started.',
    RsvpBlock.soldOut => 'Sold out.',
  },
  RsvpNoType() => 'Choose a ticket type.',
  RsvpTypeNotOffered(:final type) => "This event doesn't sell ${type.label}.",
  RsvpTypeSoldOut(:final type) => 'No ${type.label} places left.',
  RsvpNoteTooLong() =>
    'Keep the note to ${RsvpRules.maxNoteLength} characters.',
};

/// Why a ticket can't be cancelled, in words.
String cancelBlockMessage(CancelBlock block) => switch (block) {
  CancelBlock.cancelled => 'This ticket is already cancelled.',
  CancelBlock.eventCancelled => 'The organizer cancelled this event.',
  CancelBlock.started => 'A place can only be given back before it starts.',
};
