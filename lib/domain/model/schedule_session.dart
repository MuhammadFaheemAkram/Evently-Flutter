import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_session.freezed.dart';

/// A talk or workshop on an event's agenda. Its times are UTC instants; the
/// agenda shows them in the event's zone.
@freezed
abstract class ScheduleSession with _$ScheduleSession {
  const factory ScheduleSession({
    required String id,
    required String eventId,
    required String title,
    required String speaker,
    required String room,
    required DateTime start,
    required DateTime end,
  }) = _ScheduleSession;
}
