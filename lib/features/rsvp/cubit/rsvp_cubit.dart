import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_details.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/usecase/booking_use_cases.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/features/rsvp/cubit/rsvp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// The RSVP form: a ticket type the event sells, an optional note, and
/// Confirm, which waits for the server.
///
/// The event is watched while the form is open: if its last place goes
/// (a sync, another booking), the form says so before you confirm. On
/// success it sets `ticketId` once; the view opens the ticket in the
/// form's place.
@injectable
class RsvpCubit extends Cubit<RsvpState> {
  RsvpCubit(this._watchDetails, this._rsvp, this._clock)
    : super(const RsvpState());

  final WatchEventDetailsUseCase _watchDetails;
  final RsvpEventUseCase _rsvp;
  final EventClock _clock;

  StreamSubscription<EventDetails?>? _subscription;

  void load(String eventId) {
    _subscription ??= _watchDetails(eventId).listen((details) {
      if (details == null) {
        emit(state.copyWith(status: RsvpStatus.notFound, event: null));
        return;
      }
      final offers = details.item.event.offers;
      emit(
        state.copyWith(
          status: state.status == RsvpStatus.loading
              ? RsvpStatus.editing
              : state.status,
          event: details.item,
          now: _clock.now(),
          // With one ticket type on sale, it's chosen already.
          type:
              state.type ??
              (offers.length == 1 && !offers.single.isSoldOut
                  ? offers.single.type
                  : null),
        ),
      );
    });
  }

  void selectType(TicketType type) {
    if (state.isBusy) return;
    emit(state.copyWith(type: type));
  }

  void changeNote(String note) {
    if (state.isBusy) return;
    emit(state.copyWith(note: note));
  }

  /// Checks the form, then asks the server. A second tap while waiting does
  /// nothing; after a failure it tries again.
  Future<void> confirm() async {
    final event = state.event;
    if (event == null || state.isBusy) return;
    emit(state.copyWith(showErrors: true, now: _clock.now()));
    if (state.problem != null) return;
    emit(state.copyWith(status: RsvpStatus.submitting, error: null));
    final result = await _rsvp(
      event.event.id,
      type: state.type,
      note: state.note,
    );
    if (isClosed) return;
    emit(switch (result) {
      Ok(value: final ticket) => state.copyWith(
        status: RsvpStatus.booked,
        ticketId: ticket.id,
      ),
      Err(:final exception) => state.copyWith(
        status: RsvpStatus.failed,
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
