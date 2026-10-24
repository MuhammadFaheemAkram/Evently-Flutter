import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda.freezed.dart';

/// A session as the agenda shows it.
@freezed
abstract class AgendaSession with _$AgendaSession {
  const factory AgendaSession({
    required ScheduleSession session,
    @Default(false) bool isBookmarked,

    /// Other bookmarked sessions overlapping this one (only when this one
    /// is bookmarked too): you can't be in both.
    @Default(<ScheduleSession>[]) List<ScheduleSession> clashesWith,
  }) = _AgendaSession;
}

/// One day of an event's agenda, in the event's own calendar.
@freezed
abstract class AgendaDay with _$AgendaDay {
  const factory AgendaDay({
    required CalendarDate day,
    required List<AgendaSession> sessions,
  }) = _AgendaDay;
}

/// An event's agenda: its title and zone, and its days.
@freezed
abstract class Agenda with _$Agenda {
  const factory Agenda({
    required String eventId,
    required String eventTitle,

    /// The event's IANA zone: its days and times are the venue's.
    required String zone,
    @Default(<AgendaDay>[]) List<AgendaDay> days,
  }) = _Agenda;
}
