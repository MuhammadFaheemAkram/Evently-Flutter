import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

enum SearchStatus {
  /// Too little text and no filter: the recent searches show.
  idle,

  /// A search is under way; the previous results stay on screen.
  searching,
  results,
  failure,
}

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default(SearchStatus.idle) SearchStatus status,

    /// The text and the filters, as last asked for.
    @Default(EventFilter()) EventFilter filter,
    @Default(<EventCardItem>[]) List<EventCardItem> results,
    @Default(<String>[]) List<String> recentSearches,

    /// What the results' "can I book it" was judged against.
    DateTime? now,

    /// A one-time SnackBar (a failed save); [messageSerial] makes each one
    /// distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _SearchState;

  const SearchState._();

  /// Why [item] can't be booked now (`null`: it can).
  RsvpBlock? rsvpBlockFor(EventCardItem item) {
    final now = this.now;
    if (now == null) return null;
    return rsvpBlock(item.event, isGoing: item.isGoing, now: now);
  }
}
