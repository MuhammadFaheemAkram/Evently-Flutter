import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer_state.freezed.dart';

enum OrganizerStatus { loading, ready, notFound }

@freezed
abstract class OrganizerState with _$OrganizerState {
  const factory OrganizerState({
    @Default(OrganizerStatus.loading) OrganizerStatus status,
    Organizer? organizer,
    @Default(false) bool isFollowing,

    /// Their events still to come, soonest first.
    @Default(<EventCardItem>[]) List<EventCardItem> upcoming,

    /// Their events that are over, most recent first.
    @Default(<EventCardItem>[]) List<EventCardItem> past,
    DateTime? now,

    /// A one-time SnackBar; [messageSerial] makes each one distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _OrganizerState;

  const OrganizerState._();

  /// Why [item] can't be booked now (`null`: it can).
  RsvpBlock? rsvpBlockFor(EventCardItem item) {
    final now = this.now;
    if (now == null) return null;
    return rsvpBlock(item.event, isGoing: item.isGoing, now: now);
  }
}
