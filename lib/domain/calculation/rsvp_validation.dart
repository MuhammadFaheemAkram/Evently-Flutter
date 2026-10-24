import 'package:characters/characters.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';

/// What stops an RSVP form from being sent.
sealed class RsvpProblem {
  const RsvpProblem();
}

/// The event can't be booked at all (going, cancelled, started, sold out).
final class RsvpClosed extends RsvpProblem {
  const RsvpClosed(this.block);

  final RsvpBlock block;
}

/// No ticket type chosen.
final class RsvpNoType extends RsvpProblem {
  const RsvpNoType();
}

/// The chosen type isn't sold for this event.
final class RsvpTypeNotOffered extends RsvpProblem {
  const RsvpTypeNotOffered(this.type);

  final TicketType type;
}

/// The chosen type has no places left.
final class RsvpTypeSoldOut extends RsvpProblem {
  const RsvpTypeSoldOut(this.type);

  final TicketType type;
}

/// The note is longer than [RsvpRules.maxNoteLength] characters.
final class RsvpNoteTooLong extends RsvpProblem {
  const RsvpNoteTooLong(this.length);

  final int length;
}

abstract final class RsvpRules {
  /// The longest attendee note, in characters as a reader counts them (an
  /// emoji is one).
  static const maxNoteLength = 200;

  /// [note]'s length as a reader counts it.
  static int noteLength(String note) => note.trim().characters.length;
}

/// The first problem with booking [type] for [event] with [note] at [now],
/// or `null` when the form can be sent. The form shows the same checks as
/// it's filled in; the use case asks again before calling the server, and
/// the server checks once more.
RsvpProblem? validateRsvp({
  required Event event,
  required bool isGoing,
  required TicketType? type,
  required String note,
  required DateTime now,
}) {
  final block = rsvpBlock(event, isGoing: isGoing, now: now);
  if (block != null) return RsvpClosed(block);
  if (type == null) return const RsvpNoType();
  final offer = event.offers.where((o) => o.type == type).firstOrNull;
  if (offer == null) return RsvpTypeNotOffered(type);
  if (offer.isSoldOut) return RsvpTypeSoldOut(type);
  final length = RsvpRules.noteLength(note);
  if (length > RsvpRules.maxNoteLength) return RsvpNoteTooLong(length);
  return null;
}
