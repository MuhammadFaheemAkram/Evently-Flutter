import 'dart:async';

import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/usecase/schedule_use_cases.dart';
import 'package:evently/features/agenda/cubit/agenda_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// An event's agenda: its days (the venue's), bookmarks and clashes.
@injectable
class AgendaCubit extends Cubit<AgendaState> {
  AgendaCubit(this._watchAgenda, this._setBookmarked)
    : super(const AgendaState());

  final WatchAgendaUseCase _watchAgenda;
  final SetSessionBookmarkedUseCase _setBookmarked;

  StreamSubscription<Agenda?>? _subscription;

  void load(String eventId) {
    _subscription ??= _watchAgenda(eventId).listen(
      (agenda) => emit(
        state.copyWith(
          status: agenda == null ? AgendaStatus.notFound : AgendaStatus.ready,
          agenda: agenda,
        ),
      ),
    );
  }

  void selectDay(CalendarDate day) => emit(state.copyWith(selectedDay: day));

  void toggleMyOnly() => emit(state.copyWith(myOnly: !state.myOnly));

  Future<void> toggleBookmark(AgendaSession item) async {
    final result = await _setBookmarked(
      item.session.id,
      bookmarked: !item.isBookmarked,
    );
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
