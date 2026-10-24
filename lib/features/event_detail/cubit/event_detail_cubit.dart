import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/directions.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_details.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/domain/usecase/open_link_use_case.dart';
import 'package:evently/features/event_detail/cubit/event_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// One event, from the cache, kept current: a save, a booking or a refresh
/// shows up here by itself.
@injectable
class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit(
    this._watchDetails,
    this._setSaved,
    this._openLink,
    this._clock,
  ) : super(const EventDetailState());

  final WatchEventDetailsUseCase _watchDetails;
  final SetEventSavedUseCase _setSaved;
  final OpenLinkUseCase _openLink;
  final EventClock _clock;

  StreamSubscription<EventDetails?>? _subscription;

  void load(String eventId) {
    _subscription ??= _watchDetails(eventId).listen(
      (details) => emit(
        state.copyWith(
          status: details == null
              ? EventDetailStatus.notFound
              : EventDetailStatus.ready,
          details: details,
          now: _clock.now(),
        ),
      ),
      onError: (Object _) =>
          emit(state.copyWith(status: EventDetailStatus.notFound)),
    );
  }

  Future<void> toggleSaved() async {
    final item = state.details?.item;
    if (item == null) return;
    final result = await _setSaved(item.event.id, saved: !item.isSaved);
    if (isClosed) return;
    if (result case Err(:final exception)) _say(exception.message);
  }

  /// Opens the venue in Apple Maps ([appleMaps], on iOS) or Google Maps.
  Future<void> openDirections({required bool appleMaps}) async {
    if (state.details?.item.event.location case final Venue venue) {
      await _open(directionsTo(venue, appleMaps: appleMaps));
    }
  }

  /// Opens an online event's join link; only for someone going.
  Future<void> openJoinLink() async {
    final item = state.details?.item;
    if (item == null || !item.isGoing) return;
    if (item.event.location case Online(:final joinUrl)) await _open(joinUrl);
  }

  Future<void> _open(Uri url) async {
    final result = await _openLink(url);
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
