import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_dto.g.dart';

/// What the app sends to book: an event, a ticket type and a note.
class RsvpRequestDto {
  const RsvpRequestDto({
    required this.eventId,
    required this.type,
    this.note = '',
  });

  final String eventId;
  final TicketType type;
  final String note;
}

/// What the app sends to cancel: the ticket, and its event and type, so the
/// server can give the place back even after it restarted and forgot the
/// ticket (it keeps no database: it's a fake).
class CancelRequestDto {
  const CancelRequestDto({
    required this.ticketId,
    required this.eventId,
    required this.type,
  });

  final String ticketId;
  final String eventId;
  final TicketType type;
}

/// The server's answer to a booking: the new ticket, and the event as it
/// now stands (one place fewer).
@JsonSerializable(createToJson: false, checked: true)
class BookingDto {
  const BookingDto({required this.ticket, required this.event});

  factory BookingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDtoFromJson(json);

  final TicketDto ticket;
  final EventDto event;
}
