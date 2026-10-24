import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/profile_validation.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/domain/repository/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchProfileUseCase {
  const WatchProfileUseCase(this._profile);

  final ProfileRepository _profile;

  Stream<UserProfile?> call() => _profile.watchProfile();
}

/// What Profile counts, as of the user's now.
@injectable
class WatchProfileCountsUseCase {
  const WatchProfileCountsUseCase(this._profile, this._clock);

  final ProfileRepository _profile;
  final EventClock _clock;

  Stream<ProfileCounts> call() => _profile.watchCounts(_clock.now());
}

/// Saves the profile after checking it again (the form shows the same
/// rules), trimmed; an empty avatar URL is none.
@injectable
class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._profile);

  final ProfileRepository _profile;

  Future<Result<void>> call({
    required String name,
    required String email,
    String avatarUrl = '',
  }) async {
    final problem =
        ProfileRules.nameError(name) ??
        ProfileRules.emailError(email) ??
        ProfileRules.avatarUrlError(avatarUrl);
    if (problem != null) return Err(InvalidInputException(problem));
    final avatar = avatarUrl.trim();
    return _profile.save(
      UserProfile(
        name: name.trim(),
        email: email.trim(),
        avatarUrl: avatar.isEmpty ? null : Uri.parse(avatar),
      ),
    );
  }
}
