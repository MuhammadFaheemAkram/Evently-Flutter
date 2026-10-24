import 'dart:async';

import 'package:evently/domain/usecase/profile_use_cases.dart';
import 'package:evently/features/profile/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Profile: who you are, and what you have (tickets, saved events, follows,
/// bookmarks), kept current.
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._watchProfile, this._watchCounts)
    : super(const ProfileState());

  final WatchProfileUseCase _watchProfile;
  final WatchProfileCountsUseCase _watchCounts;

  final _subscriptions = <StreamSubscription<Object?>>[];

  void load() {
    if (_subscriptions.isNotEmpty) return;
    _subscriptions.addAll([
      _watchProfile().listen(
        (profile) => emit(state.copyWith(loading: false, profile: profile)),
      ),
      _watchCounts().listen((counts) => emit(state.copyWith(counts: counts))),
    ]);
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
