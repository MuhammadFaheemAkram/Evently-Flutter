import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/event_timeline.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/domain/usecase/organizer_use_cases.dart';
import 'package:evently/features/organizer/cubit/organizer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// An organizer: who they are, Follow, and their events.
@injectable
class OrganizerCubit extends Cubit<OrganizerState> {
  OrganizerCubit(
    this._watchOrganizer,
    this._setFollowing,
    this._setSaved,
    this._clock,
  ) : super(const OrganizerState());

  final WatchOrganizerUseCase _watchOrganizer;
  final SetFollowingUseCase _setFollowing;
  final SetEventSavedUseCase _setSaved;
  final EventClock _clock;

  StreamSubscription<OrganizerDetails?>? _subscription;

  void load(String organizerId) {
    _subscription ??= _watchOrganizer(organizerId).listen((details) {
      if (details == null) {
        emit(state.copyWith(status: OrganizerStatus.notFound));
        return;
      }
      final now = _clock.now();
      final split = splitByEnd(
        details.events,
        eventOf: (card) => card.event,
        now: now,
      );
      emit(
        state.copyWith(
          status: OrganizerStatus.ready,
          organizer: details.organizer,
          isFollowing: details.isFollowing,
          upcoming: split.upcoming,
          past: split.past,
          now: now,
        ),
      );
    });
  }

  Future<void> toggleFollowing() async {
    final organizer = state.organizer;
    if (organizer == null) return;
    _report(await _setFollowing(organizer.id, following: !state.isFollowing));
  }

  Future<void> toggleSaved(EventCardItem item) async =>
      _report(await _setSaved(item.event.id, saved: !item.isSaved));

  void _report(Result<void> result) {
    if (isClosed) return;
    if (result case Err(:final exception)) {
      emit(
        state.copyWith(
          message: exception.message,
          messageSerial: state.messageSerial + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
