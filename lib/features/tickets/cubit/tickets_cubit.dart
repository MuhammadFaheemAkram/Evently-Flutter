import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/domain/calculation/event_timeline.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/domain/usecase/booking_use_cases.dart';
import 'package:evently/features/tickets/cubit/tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// The Tickets tab: your tickets from the database (offline), upcoming
/// and past by the event's end.
@injectable
class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit(this._watchTickets, this._clock) : super(const TicketsState());

  final WatchTicketsUseCase _watchTickets;
  final EventClock _clock;

  StreamSubscription<List<TicketItem>>? _subscription;

  void load() {
    _subscription ??= _watchTickets().listen((tickets) {
      final split = splitByEnd(
        tickets,
        eventOf: (item) => item.event,
        now: _clock.now(),
      );
      emit(
        TicketsState(
          status: TicketsStatus.ready,
          upcoming: split.upcoming,
          past: split.past,
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
