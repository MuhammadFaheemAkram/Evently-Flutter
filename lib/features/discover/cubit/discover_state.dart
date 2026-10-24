import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/day_group.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_state.freezed.dart';

/// - [loading]: the cache is empty and a refresh is filling it;
/// - [ready]: there are events to show;
/// - [empty]: the server has no events;
/// - [failed]: the cache is empty and the refresh failed (offline).
enum DiscoverStatus { loading, ready, empty, failed }

@freezed
abstract class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default(DiscoverStatus.loading) DiscoverStatus status,
    @Default(<EventCardItem>[]) List<EventCardItem> featured,
    @Default(<EventCardItem>[]) List<EventCardItem> inYourCity,
    @Default(<DayGroup<EventCardItem>>[])
    List<DayGroup<EventCardItem>> upcoming,

    /// The category the upcoming list is filtered to; `null` is "All".
    EventCategory? category,

    /// The preferred city; `null` is "Anywhere" (no "In your city").
    String? city,

    /// When the lists were last worked out: what "upcoming" and "can I book
    /// it" were judged against.
    DateTime? now,

    /// The user's day at [now]: the upcoming list's "Today".
    CalendarDate? today,

    /// Why the cache couldn't be filled ([DiscoverStatus.failed]).
    String? errorMessage,

    /// A one-time SnackBar (offline on refresh, a failed save);
    /// [messageSerial] makes each one distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _DiscoverState;

  const DiscoverState._();

  /// Why [item] can't be booked now (`null`: it can, or the lists aren't
  /// worked out yet).
  RsvpBlock? rsvpBlockFor(EventCardItem item) {
    final now = this.now;
    if (now == null) return null;
    return rsvpBlock(item.event, isGoing: item.isGoing, now: now);
  }
}
