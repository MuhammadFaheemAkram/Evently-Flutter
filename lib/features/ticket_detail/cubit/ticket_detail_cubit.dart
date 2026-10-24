import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/domain/usecase/booking_use_cases.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// One ticket, kept current, and cancelling it (server first).
@injectable
class TicketDetailCubit extends Cubit<TicketDetailState> {
  TicketDetailCubit(this._watchTicket, this._cancelRsvp, this._clock)
    : super(const TicketDetailState());

  final WatchTicketUseCase _watchTicket;
  final CancelRsvpUseCase _cancelRsvp;
  final EventClock _clock;

  StreamSubscription<TicketItem?>? _subscription;

  void load(String ticketId) {
    _subscription ??= _watchTicket(ticketId).listen(
      (item) => emit(
        state.copyWith(
          status: item == null
              ? TicketDetailStatus.notFound
              : TicketDetailStatus.ready,
          item: item,
          now: _clock.now(),
        ),
      ),
    );
  }

  /// Cancels the RSVP. The ticket stays, marked cancelled; its place goes
  /// back. A second tap while waiting does nothing.
  Future<void> cancel() async {
    final item = state.item;
    if (item == null || state.cancelling) return;
    emit(state.copyWith(cancelling: true, now: _clock.now()));
    final result = await _cancelRsvp(item);
    if (isClosed) return;
    emit(
      state.copyWith(
        cancelling: false,
        message: switch (result) {
          Ok() => 'RSVP cancelled. Your place went back.',
          Err(:final exception) => exception.message,
        },
        messageSerial: state.messageSerial + 1,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
