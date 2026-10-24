import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'profile_dao.g.dart';

/// The profile's counts.
class ProfileCountsRow {
  const ProfileCountsRow({
    required this.upcomingTickets,
    required this.savedEvents,
    required this.organizersFollowed,
    required this.sessionsBookmarked,
  });

  final int upcomingTickets;
  final int savedEvents;
  final int organizersFollowed;
  final int sessionsBookmarked;
}

/// The profile (one row at most) and what Profile counts.
@DriftAccessor(
  tables: [
    Profiles,
    Tickets,
    Events,
    SavedEvents,
    FollowedOrganizers,
    SessionBookmarks,
  ],
)
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.attachedDatabase);

  Stream<ProfileRow?> watchProfile() => select(profiles).watchSingleOrNull();

  /// Writes the profile (it's always row 1), every column: a cleared avatar
  /// must become `null`, which `insertOnConflictUpdate` would skip
  /// (conventions §11.57).
  Future<void> saveProfile(ProfileRow profile) {
    final row = profile.copyWith(id: 1);
    return into(profiles)
        .insert(row, onConflict: DoUpdate((_) => row.toCompanion(false)));
  }

  /// The counts, as of [now] (a ticket's event that has ended is no longer
  /// upcoming). One query, re-run whenever any table it reads changes.
  Stream<ProfileCountsRow> watchCounts(DateTime now) =>
      customSelect(
        'SELECT '
        '(SELECT COUNT(*) FROM tickets t JOIN events e ON e.id = t.event_id '
        'WHERE t.cancelled_at IS NULL AND e.ends_at > ?) AS upcoming, '
        '(SELECT COUNT(*) FROM saved_events) AS saved, '
        '(SELECT COUNT(*) FROM followed_organizers) AS following, '
        '(SELECT COUNT(*) FROM session_bookmarks) AS bookmarks',
        variables: [Variable<DateTime>(now.toUtc())],
        readsFrom: {
          tickets,
          events,
          savedEvents,
          followedOrganizers,
          sessionBookmarks,
        },
      ).watchSingle().map(
        (row) => ProfileCountsRow(
          upcomingTickets: row.read<int>('upcoming'),
          savedEvents: row.read<int>('saved'),
          organizersFollowed: row.read<int>('following'),
          sessionsBookmarked: row.read<int>('bookmarks'),
        ),
      );
}
