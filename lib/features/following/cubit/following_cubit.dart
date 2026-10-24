import 'dart:async';

import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/domain/usecase/organizer_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// The organizers you follow, each with their next event; `null` until
/// first read.
@injectable
class FollowingCubit extends Cubit<List<FollowedOrganizer>?> {
  FollowingCubit(this._watchFollowing) : super(null);

  final WatchFollowingUseCase _watchFollowing;

  StreamSubscription<List<FollowedOrganizer>>? _subscription;

  void load() => _subscription ??= _watchFollowing().listen(emit);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
