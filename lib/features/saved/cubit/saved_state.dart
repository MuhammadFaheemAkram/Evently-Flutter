import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_state.freezed.dart';

enum SavedStatus { loading, ready }

@freezed
abstract class SavedState with _$SavedState {
  const factory SavedState({
    @Default(SavedStatus.loading) SavedStatus status,

    /// Saved events still to come, soonest first.
    @Default(<EventCardItem>[]) List<EventCardItem> upcoming,

    /// Saved events that are over, most recent first.
    @Default(<EventCardItem>[]) List<EventCardItem> past,
    DateTime? now,

    /// The event just removed, for the SnackBar's Undo; [removedSerial]
    /// makes each removal distinct.
    EventCardItem? removed,
    @Default(0) int removedSerial,

    /// A one-time SnackBar (a failed write); [messageSerial] makes each one
    /// distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _SavedState;

  const SavedState._();

  bool get isEmpty => upcoming.isEmpty && past.isEmpty;

  /// Why [item] can't be booked now (`null`: it can).
  RsvpBlock? rsvpBlockFor(EventCardItem item) {
    final now = this.now;
    if (now == null) return null;
    return rsvpBlock(item.event, isGoing: item.isGoing, now: now);
  }
}
