import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(true) bool loading,

    /// `null` before there is one (a fresh start).
    UserProfile? profile,
    @Default(ProfileCounts()) ProfileCounts counts,
  }) = _ProfileState;
}
