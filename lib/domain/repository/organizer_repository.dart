import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/user_summary.dart';

/// Organizers, their events, and who you follow.
abstract interface class OrganizerRepository {
  /// One organizer with their events and whether you follow them, kept
  /// current; `null` when not cached.
  Stream<OrganizerDetails?> watchOrganizer(String organizerId);

  /// The organizers you follow, A to Z, each with their events.
  Stream<List<OrganizerDetails>> watchFollowed();

  /// Follows or unfollows. Local, so offline too.
  Future<Result<void>> setFollowing(
    String organizerId, {
    required bool following,
  });
}
