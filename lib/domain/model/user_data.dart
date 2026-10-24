import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';

/// An event you saved, and when.
@freezed
abstract class SavedEvent with _$SavedEvent {
  const factory SavedEvent({
    required String eventId,
    required DateTime savedAt,
  }) = _SavedEvent;
}

/// An agenda session you bookmarked.
@freezed
abstract class SessionBookmark with _$SessionBookmark {
  const factory SessionBookmark({
    required String sessionId,
    required DateTime createdAt,
  }) = _SessionBookmark;
}

/// An organizer you follow.
@freezed
abstract class Follow with _$Follow {
  const factory Follow({
    required String organizerId,
    required DateTime followedAt,
  }) = _Follow;
}

/// Everything that is *yours*, in one value: what the demo loads.
///
/// It points at the catalog only by ids, so the catalog can be refreshed
/// underneath it without touching it.
@freezed
abstract class UserData with _$UserData {
  const factory UserData({
    UserProfile? profile,
    @Default(<SavedEvent>[]) List<SavedEvent> saved,
    @Default(<Ticket>[]) List<Ticket> tickets,
    @Default(<SessionBookmark>[]) List<SessionBookmark> bookmarks,
    @Default(<Follow>[]) List<Follow> follows,
  }) = _UserData;
}
