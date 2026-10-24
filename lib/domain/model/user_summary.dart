import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_summary.freezed.dart';

/// What Profile counts.
@freezed
abstract class ProfileCounts with _$ProfileCounts {
  const factory ProfileCounts({
    /// Active tickets for events not over yet.
    @Default(0) int upcomingTickets,
    @Default(0) int savedEvents,
    @Default(0) int organizersFollowed,
    @Default(0) int sessionsBookmarked,
  }) = _ProfileCounts;
}

/// An organizer's page: the organizer, whether you follow them, and their
/// events (any order).
@freezed
abstract class OrganizerDetails with _$OrganizerDetails {
  const factory OrganizerDetails({
    required Organizer organizer,
    @Default(false) bool isFollowing,
    @Default(<EventCardItem>[]) List<EventCardItem> events,
  }) = _OrganizerDetails;
}

/// An organizer you follow, with their next event.
@freezed
abstract class FollowedOrganizer with _$FollowedOrganizer {
  const factory FollowedOrganizer({
    required Organizer organizer,

    /// Their soonest event that isn't over, if any.
    EventCardItem? nextEvent,
  }) = _FollowedOrganizer;
}
