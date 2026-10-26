import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';

/// Why an event can't be booked right now.
enum RsvpBlock {
  /// You already hold a ticket.
  going,

  /// The organizer called it off.
  cancelled,

  /// It's over.
  ended,

  /// It has begun: bookings close at the start.
  started,

  /// No offer has a place left.
  soldOut,
}

/// What stands between you and booking [event] at [now], or `null` when
/// nothing does. The first reason that applies wins, most decisive first.
///
/// A moved event can still be booked (at its new time). Whether a *chosen*
/// offer has places left is the RSVP form's check (`validateRsvp`); here
/// it's enough that some offer has.
RsvpBlock? rsvpBlock(
  Event event, {
  required bool isGoing,
  required DateTime now,
}) {
  if (isGoing) return RsvpBlock.going;
  if (event.status == EventStatus.cancelled) return RsvpBlock.cancelled;
  if (event.time.hasEnded(now)) return RsvpBlock.ended;
  if (event.time.hasStarted(now)) return RsvpBlock.started;
  if (event.isSoldOut) return RsvpBlock.soldOut;
  return null;
}

/// Whether you can book [event] at [now].
bool canRsvp(Event event, {required bool isGoing, required DateTime now}) =>
    rsvpBlock(event, isGoing: isGoing, now: now) == null;
