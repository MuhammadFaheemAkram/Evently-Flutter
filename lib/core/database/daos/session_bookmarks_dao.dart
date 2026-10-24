import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'session_bookmarks_dao.g.dart';

/// An event's sessions with the user's bookmarks: like saved and going, a
/// bookmark is a row of the user's, joined, never a flag on a session.
@DriftAccessor(tables: [Events, Sessions, SessionBookmarks])
class SessionBookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$SessionBookmarksDaoMixin {
  SessionBookmarksDao(super.attachedDatabase);

  /// [eventId]'s sessions with whether each is bookmarked, in time order;
  /// `null` when the event isn't cached.
  Stream<(EventRow, List<(SessionRow, bool)>)?> watchAgenda(String eventId) {
    final query =
        select(events).join([
            leftOuterJoin(sessions, sessions.eventId.equalsExp(events.id)),
            leftOuterJoin(
              sessionBookmarks,
              sessionBookmarks.sessionId.equalsExp(sessions.id),
            ),
          ])
          ..where(events.id.equals(eventId))
          ..orderBy([
            OrderingTerm(expression: sessions.startsAt),
            OrderingTerm(expression: sessions.id),
          ]);
    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      return (
        rows.first.readTable(events),
        [
          for (final row in rows)
            if (row.readTableOrNull(sessions) case final session?)
              (session, row.readTableOrNull(sessionBookmarks) != null),
        ],
      );
    });
  }

  /// Bookmarks [sessionId] at [at], or removes its bookmark. Local only.
  Future<void> setBookmarked(
    String sessionId, {
    required bool bookmarked,
    required DateTime at,
  }) => bookmarked
      ? into(sessionBookmarks).insert(
          SessionBookmarkRow(sessionId: sessionId, createdAt: at),
          mode: InsertMode.insertOrIgnore,
        )
      : (delete(
          sessionBookmarks,
        )..where((b) => b.sessionId.equals(sessionId))).go();
}
