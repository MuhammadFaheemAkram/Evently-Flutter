import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_state.freezed.dart';

enum AgendaStatus { loading, ready, notFound }

@freezed
abstract class AgendaState with _$AgendaState {
  const factory AgendaState({
    @Default(AgendaStatus.loading) AgendaStatus status,
    Agenda? agenda,

    /// The day shown; `null` is the first.
    CalendarDate? selectedDay,

    /// Only bookmarked sessions ("My sessions").
    @Default(false) bool myOnly,

    /// A one-time SnackBar (a failed bookmark); [messageSerial] makes each
    /// one distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _AgendaState;

  const AgendaState._();

  List<AgendaDay> get days => agenda?.days ?? const [];

  /// The day shown.
  AgendaDay? get currentDay {
    final days = this.days;
    if (days.isEmpty) return null;
    return days.where((d) => d.day == selectedDay).firstOrNull ?? days.first;
  }

  /// The current day's sessions, bookmarked only when [myOnly].
  List<AgendaSession> get visibleSessions => [
    for (final session in currentDay?.sessions ?? const <AgendaSession>[])
      if (!myOnly || session.isBookmarked) session,
  ];
}
