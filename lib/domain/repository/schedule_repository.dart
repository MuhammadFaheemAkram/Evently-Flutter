import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/agenda.dart';

/// An event's agenda and the user's session bookmarks.
abstract interface class ScheduleRepository {
  /// [eventId]'s agenda, by the event's days, kept current; `null` when
  /// the event isn't cached.
  Stream<Agenda?> watchAgenda(String eventId);

  /// Bookmarks a session, or removes its bookmark. Local, so offline too.
  Future<Result<void>> setBookmarked(
    String sessionId, {
    required bool bookmarked,
  });
}
