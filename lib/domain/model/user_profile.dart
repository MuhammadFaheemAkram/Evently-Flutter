import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Who you are, on this device.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String name,
    required String email,

    /// An https picture, for a real backend later; the app draws initials.
    Uri? avatarUrl,
  }) = _UserProfile;
}
