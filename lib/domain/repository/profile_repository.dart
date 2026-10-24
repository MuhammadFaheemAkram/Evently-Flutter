import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/model/user_summary.dart';

/// The user's profile and what Profile counts.
abstract interface class ProfileRepository {
  /// The profile, or `null` before there is one (a fresh start).
  Stream<UserProfile?> watchProfile();

  Future<Result<void>> save(UserProfile profile);

  /// The counts, as of [now].
  Stream<ProfileCounts> watchCounts(DateTime now);
}
