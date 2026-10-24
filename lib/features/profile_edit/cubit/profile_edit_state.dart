import 'package:evently/domain/calculation/profile_validation.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_edit_state.freezed.dart';

/// - [loading]: reading the profile;
/// - [editing]: the form;
/// - [saving]: writing it;
/// - [saved]: done; the view closes.
enum ProfileEditStatus { loading, editing, saving, saved }

@freezed
abstract class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState({
    @Default(ProfileEditStatus.loading) ProfileEditStatus status,

    /// The profile as saved; `null` when there's none yet.
    UserProfile? original,
    @Default('') String name,
    @Default('') String email,
    @Default('') String avatarUrl,

    /// Field errors show after the first Save, not while typing.
    @Default(false) bool showErrors,

    /// Why the last Save failed.
    String? error,
  }) = _ProfileEditState;

  const ProfileEditState._();

  String? get nameError => showErrors ? ProfileRules.nameError(name) : null;

  String? get emailError => showErrors ? ProfileRules.emailError(email) : null;

  String? get avatarUrlError =>
      showErrors ? ProfileRules.avatarUrlError(avatarUrl) : null;

  bool get isValid =>
      ProfileRules.nameError(name) == null &&
      ProfileRules.emailError(email) == null &&
      ProfileRules.avatarUrlError(avatarUrl) == null;

  /// Whether leaving now would lose something typed.
  bool get hasChanges {
    final original = this.original;
    return name.trim() != (original?.name ?? '') ||
        email.trim() != (original?.email ?? '') ||
        avatarUrl.trim() != (original?.avatarUrl?.toString() ?? '');
  }
}
