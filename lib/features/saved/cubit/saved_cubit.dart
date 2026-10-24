import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/event_timeline.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/features/saved/cubit/saved_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Saved: the events you saved, from the database alone, so it works with
/// no network at all. Upcoming first, then the past ones.
@injectable
class SavedCubit extends Cubit<SavedState> {
  SavedCubit(this._watchSaved, this._setSaved, this._clock)
    : super(const SavedState());

  final WatchSavedEventsUseCase _watchSaved;
  final SetEventSavedUseCase _setSaved;
  final EventClock _clock;

  StreamSubscription<List<EventCardItem>>? _subscription;

  void load() {
    _subscription ??= _watchSaved().listen((saved) {
      final now = _clock.now();
      final split = splitByEnd(saved, eventOf: (item) => item.event, now: now);
      emit(
        state.copyWith(
          status: SavedStatus.ready,
          upcoming: split.upcoming,
          past: split.past,
          now: now,
        ),
      );
    });
  }

  /// Removes [item] from Saved, offering Undo.
  Future<void> remove(EventCardItem item) async {
    final result = await _setSaved(item.event.id, saved: false);
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(
          state.copyWith(removed: item, removedSerial: state.removedSerial + 1),
        );
      case Err(:final exception):
        _say(exception.message);
    }
  }

  /// Saves [item] again (the SnackBar's Undo).
  Future<void> undo(EventCardItem item) async {
    final result = await _setSaved(item.event.id, saved: true);
    if (isClosed) return;
    if (result case Err(:final exception)) _say(exception.message);
  }

  void _say(String message) => emit(
    state.copyWith(message: message, messageSerial: state.messageSerial + 1),
  );

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
