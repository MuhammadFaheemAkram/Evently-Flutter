import 'package:evently/domain/calculation/rsvp_rules.dart' as rules;
import 'package:evently/domain/model/event_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_detail_state.freezed.dart';

/// - [loading]: before the first read;
/// - [ready]: the event is cached;
/// - [notFound]: it isn't (a stale link, or Clear cache took it).
enum EventDetailStatus { loading, ready, notFound }

@freezed
abstract class EventDetailState with _$EventDetailState {
  const factory EventDetailState({
    @Default(EventDetailStatus.loading) EventDetailStatus status,
    EventDetails? details,

    /// What "can I book it" was judged against.
    DateTime? now,

    /// A one-time SnackBar (a link that wouldn't open, a failed save);
    /// [messageSerial] makes each one distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _EventDetailState;

  const EventDetailState._();

  /// Why the event can't be booked (`null`: it can, or it isn't read yet).
  rules.RsvpBlock? get rsvpBlock {
    final details = this.details;
    final now = this.now;
    if (details == null || now == null) return null;
    return rules.rsvpBlock(
      details.item.event,
      isGoing: details.item.isGoing,
      now: now,
    );
  }

  /// Whether the event is over.
  bool get hasEnded {
    final details = this.details;
    final now = this.now;
    return details != null &&
        now != null &&
        details.item.event.time.hasEnded(now);
  }
}
