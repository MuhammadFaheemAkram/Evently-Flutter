import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket.freezed.dart';

/// Your place at an event. A ticket *is* the RSVP: there's no separate
/// "going" flag to keep in step with it.
///
/// Only the server issues one (Phase 5): the app writes a ticket only from
/// the server's answer, so there is never a ticket the server doesn't know.
@freezed
abstract class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    required String eventId,

    /// What the QR code encodes, and the door checks ("EVT-7KQ2-M9XA").
    required String code,
    required TicketType type,
    @Default('') String note,
    required DateTime bookedAt,

    /// When you cancelled it. An event the organizer cancels says so on its
    /// own (`EventStatus.cancelled`); the ticket stays as it was.
    DateTime? cancelledAt,
  }) = _Ticket;

  const Ticket._();

  /// Not cancelled by you. At most one per event (the database enforces it).
  bool get isActive => cancelledAt == null;
}
