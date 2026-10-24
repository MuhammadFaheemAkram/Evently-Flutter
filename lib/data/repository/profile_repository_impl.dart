import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/profile_dao.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._profile);

  final ProfileDao _profile;

  @override
  Stream<UserProfile?> watchProfile() => _profile.watchProfile().map(
    (row) => row == null
        ? null
        : UserProfile(
            name: row.name,
            email: row.email,
            avatarUrl: row.avatarUrl,
          ),
  );

  @override
  Future<Result<void>> save(UserProfile profile) => guardWrite(
    'Saving the profile',
    () => _profile.saveProfile(
      ProfileRow(
        id: 1,
        name: profile.name,
        email: profile.email,
        avatarUrl: profile.avatarUrl,
      ),
    ),
  );

  @override
  Stream<ProfileCounts> watchCounts(DateTime now) => _profile
      .watchCounts(now)
      .map(
        (row) => ProfileCounts(
          upcomingTickets: row.upcomingTickets,
          savedEvents: row.savedEvents,
          organizersFollowed: row.organizersFollowed,
          sessionsBookmarked: row.sessionsBookmarked,
        ),
      );
}
