import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'organizers_dao.g.dart';

/// Organizers and the user's follows. Following is local: the server's
/// follower count is its own business, and a follow works offline.
@DriftAccessor(tables: [Organizers, FollowedOrganizers])
class OrganizersDao extends DatabaseAccessor<AppDatabase>
    with _$OrganizersDaoMixin {
  OrganizersDao(super.attachedDatabase);

  /// One organizer and whether you follow them, or `null`.
  Stream<(OrganizerRow, bool)?> watchOne(String organizerId) {
    final query = select(organizers).join([
      leftOuterJoin(
        followedOrganizers,
        followedOrganizers.organizerId.equalsExp(organizers.id),
      ),
    ])..where(organizers.id.equals(organizerId));
    return query.watchSingleOrNull().map(
      (row) => row == null
          ? null
          : (
              row.readTable(organizers),
              row.readTableOrNull(followedOrganizers) != null,
            ),
    );
  }

  /// The organizers you follow, A to Z.
  Stream<List<OrganizerRow>> watchFollowed() {
    final query = select(organizers).join([
      innerJoin(
        followedOrganizers,
        followedOrganizers.organizerId.equalsExp(organizers.id),
      ),
    ])..orderBy([OrderingTerm(expression: organizers.name)]);
    return query.watch().map(
      (rows) => [for (final row in rows) row.readTable(organizers)],
    );
  }

  /// Follows [organizerId] (at [at]) or unfollows them.
  Future<void> setFollowing(
    String organizerId, {
    required bool following,
    required DateTime at,
  }) => following
      ? into(followedOrganizers).insert(
          FollowRow(organizerId: organizerId, followedAt: at),
          mode: InsertMode.insertOrIgnore,
        )
      : (delete(
          followedOrganizers,
        )..where((f) => f.organizerId.equals(organizerId))).go();
}
