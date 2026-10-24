import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_item.freezed.dart';

/// Where a ticket stands, from the ticket and its event.
enum TicketStatus {
  confirmed,

  /// The organizer moved the event; the ticket holds for the new time.
  moved,

  /// The organizer called the event off.
  cancelledByOrganizer,

  /// You cancelled your RSVP.
  cancelledByYou,
}

/// A ticket with its event, as the Tickets tab and Ticket detail show it.
@freezed
abstract class TicketItem with _$TicketItem {
  const factory TicketItem({
    required Ticket ticket,
    required Event event,
    required String organizerName,
  }) = _TicketItem;

  const TicketItem._();

  /// Your cancellation first (it's what you did), then the organizer's
  /// word on the event.
  TicketStatus get status {
    if (!ticket.isActive) return TicketStatus.cancelledByYou;
    return switch (event.status) {
      EventStatus.cancelled => TicketStatus.cancelledByOrganizer,
      EventStatus.moved => TicketStatus.moved,
      EventStatus.scheduled => TicketStatus.confirmed,
    };
  }
}
