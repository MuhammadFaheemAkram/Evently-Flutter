import 'dart:async';

import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/usecase/profile_use_cases.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Edit profile: name, email and an optional avatar URL, checked on Save.
@injectable
class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit(this._watchProfile, this._updateProfile)
    : super(const ProfileEditState());

  final WatchProfileUseCase _watchProfile;
  final UpdateProfileUseCase _updateProfile;

  StreamSubscription<UserProfile?>? _subscription;

  /// Starts from the profile as saved. Only its first value is used: a
  /// later change mustn't overwrite what's being typed.
  void load() {
    _subscription ??= _watchProfile().listen((profile) {
      if (state.status != ProfileEditStatus.loading) return;
      emit(
        state.copyWith(
          status: ProfileEditStatus.editing,
          original: profile,
          name: profile?.name ?? '',
          email: profile?.email ?? '',
          avatarUrl: profile?.avatarUrl?.toString() ?? '',
        ),
      );
    });
  }

  void nameChanged(String name) => emit(state.copyWith(name: name));

  void emailChanged(String email) => emit(state.copyWith(email: email));

  void avatarUrlChanged(String url) => emit(state.copyWith(avatarUrl: url));

  Future<void> save() async {
    if (state.status != ProfileEditStatus.editing) return;
    emit(state.copyWith(showErrors: true, error: null));
    if (!state.isValid) return;
    emit(state.copyWith(status: ProfileEditStatus.saving));
    final result = await _updateProfile(
      name: state.name,
      email: state.email,
      avatarUrl: state.avatarUrl,
    );
    if (isClosed) return;
    emit(switch (result) {
      Ok() => state.copyWith(status: ProfileEditStatus.saved),
      Err(:final exception) => state.copyWith(
        status: ProfileEditStatus.editing,
        error: exception.message,
      ),
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
