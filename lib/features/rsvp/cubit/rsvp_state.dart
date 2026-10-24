import 'package:evently/domain/calculation/rsvp_rules.dart' as rules;
import 'package:evently/domain/calculation/rsvp_validation.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rsvp_state.freezed.dart';

/// - [loading]: before the event is read;
/// - [notFound]: it isn't cached;
/// - [editing]: the form;
/// - [submitting]: waiting for the server; the form is locked;
/// - [failed]: the server said no (or wasn't reached); nothing was written;
/// - [booked]: the server confirmed; the ticket opens in the form's place.
enum RsvpStatus { loading, notFound, editing, submitting, failed, booked }

@freezed
abstract class RsvpState with _$RsvpState {
  const factory RsvpState({
    @Default(RsvpStatus.loading) RsvpStatus status,
    EventCardItem? event,
    TicketType? type,
    @Default('') String note,

    /// Field errors show after the first Confirm, not while typing.
    @Default(false) bool showErrors,

    /// Why the last Confirm failed.
    String? error,

    /// Set once, when the server confirmed: the one-time effect that opens
    /// the new ticket.
    String? ticketId,

    /// What "can I book it" is judged against.
    DateTime? now,
  }) = _RsvpState;

  const RsvpState._();

  /// The first problem with the form as it is, or `null`.
  RsvpProblem? get problem {
    final event = this.event;
    final now = this.now;
    if (event == null || now == null) return null;
    return validateRsvp(
      event: event.event,
      isGoing: event.isGoing,
      type: type,
      note: note,
      now: now,
    );
  }

  /// Why the event can't be booked at all (the form isn't shown).
  rules.RsvpBlock? get block => switch (problem) {
    RsvpClosed(:final block) => block,
    _ => null,
  };

  /// The form is locked: waiting for the server, or already booked.
  bool get isBusy =>
      status == RsvpStatus.submitting || status == RsvpStatus.booked;
}
