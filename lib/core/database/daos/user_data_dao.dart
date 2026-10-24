import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'user_data_dao.g.dart';

/// The user's rows, as the demo writes them.
class UserRows {
  const UserRows({
    this.profile,
    this.saved = const [],
    this.tickets = const [],
    this.bookmarks = const [],
    this.follows = const [],
  });

  final ProfileRow? profile;
  final List<SavedEventRow> saved;
  final List<TicketRow> tickets;
  final List<SessionBookmarkRow> bookmarks;
  final List<FollowRow> follows;
}

/// Reads and writes all of the user's tables at once. Never touches the
/// catalog.
@DriftAccessor(
  tables: [
    SavedEvents,
    Tickets,
    SessionBookmarks,
    FollowedOrganizers,
    EventReminders,
    EventChanges,
    RecentSearches,
    Profiles,
  ],
)
class UserDataDao extends DatabaseAccessor<AppDatabase>
    with _$UserDataDaoMixin {
  UserDataDao(super.attachedDatabase);

  /// Replaces everything the user owns with [rows], in **one transaction**:
  /// it lands completely or not at all, and running it twice gives the same
  /// result. The catalog must already hold every event, session and
  /// organizer [rows] point at: a foreign key refuses anything else, and the
  /// whole write with it.
  Future<void> replaceAll(UserRows rows) {
    return transaction(() async {
      for (final table in <TableInfo<Table, Object?>>[
        sessionBookmarks,
        savedEvents,
        tickets,
        followedOrganizers,
        eventReminders,
        eventChanges,
        recentSearches,
        profiles,
      ]) {
        await delete(table).go();
      }
      final profile = rows.profile;
      if (profile != null) await into(profiles).insert(profile);
      await batch((batch) {
        batch
          ..insertAll(savedEvents, rows.saved)
          ..insertAll(tickets, rows.tickets)
          ..insertAll(sessionBookmarks, rows.bookmarks)
          ..insertAll(followedOrganizers, rows.follows);
      });
    });
  }

  /// Every row the demo writes, in a stable order, read in one transaction.
  Future<UserRows> readAll() {
    return transaction(() async {
      return UserRows(
        profile: await select(profiles).getSingleOrNull(),
        saved: await (select(
          savedEvents,
        )..orderBy([(t) => OrderingTerm(expression: t.eventId)])).get(),
        tickets: await (select(
          tickets,
        )..orderBy([(t) => OrderingTerm(expression: t.id)])).get(),
        bookmarks: await (select(
          sessionBookmarks,
        )..orderBy([(t) => OrderingTerm(expression: t.sessionId)])).get(),
        follows: await (select(
          followedOrganizers,
        )..orderBy([(t) => OrderingTerm(expression: t.organizerId)])).get(),
      );
    });
  }
}
