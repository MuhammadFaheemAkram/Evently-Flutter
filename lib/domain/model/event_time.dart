import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'event_time.freezed.dart';

/// When an event happens: two **instants** ([start], [end], in UTC) and the
/// IANA [zone] of the place it happens in ("Europe/London").
///
/// An event happens at one moment everywhere, so the instants are the
/// truth: "has it started?" and "is it upcoming?" compare instants, and
/// nothing moves when the phone changes time zone. The zone is how the
/// event is *told*: 18:30 in London is the time on the poster, whoever reads
/// it, so the venue's local time is shown first (with yours when they
/// differ), and the agenda's days are the venue's days.
///
/// Times are kept out of `DateTime`'s local zone on purpose: a `DateTime` is
/// either UTC or the *device's* zone, and an event in New York read on a
/// phone in Lahore is neither. `timezone`'s `TZDateTime` carries any zone,
/// with its daylight-saving rules.
@freezed
abstract class EventTime with _$EventTime {
  const factory EventTime({
    /// UTC.
    required DateTime start,

    /// UTC, after [start].
    required DateTime end,

    /// The venue's IANA zone (an online event's organizer's).
    required String zone,
  }) = _EventTime;

  const EventTime._();

  /// An event told as its poster tells it: [startTime] on [startDay] to
  /// [endTime] on [endDay] (the same day if omitted), in [zone].
  ///
  /// A local time that doesn't exist (01:30 in London on the night clocks
  /// go forward) moves an hour later; one that exists twice (01:30 on the
  /// night they go back) is the second of the two, in standard time. That
  /// is how `timezone` resolves them; organizers avoid both.
  factory EventTime.local({
    required String zone,
    required CalendarDate startDay,
    required TimeOfDayValue startTime,
    CalendarDate? endDay,
    required TimeOfDayValue endTime,
  }) {
    final location = tz.getLocation(zone);
    tz.TZDateTime at(CalendarDate day, TimeOfDayValue time) => tz.TZDateTime(
      location,
      day.year,
      day.month,
      day.day,
      time.hour,
      time.minute,
    );
    return EventTime(
      start: at(startDay, startTime).toUtc(),
      end: at(endDay ?? startDay, endTime).toUtc(),
      zone: zone,
    );
  }

  /// The zone's rules. Throws `LocationNotFoundException` for a name the
  /// time-zone database doesn't know (the mapper refuses those).
  tz.Location get location => tz.getLocation(zone);

  /// [start] as the venue's clock shows it.
  tz.TZDateTime get localStart => tz.TZDateTime.from(start, location);

  /// [end] as the venue's clock shows it.
  tz.TZDateTime get localEnd => tz.TZDateTime.from(end, location);

  /// The venue's day the event starts on.
  CalendarDate get startDay => CalendarDate.fromDateTime(localStart);

  /// The venue's day the event ends on.
  CalendarDate get endDay => CalendarDate.fromDateTime(localEnd);

  Duration get duration => end.difference(start);

  /// From its first instant on.
  bool hasStarted(DateTime now) => !now.isBefore(start);

  /// From its last instant on: an event ending at 21:00 has ended at 21:00.
  bool hasEnded(DateTime now) => !now.isBefore(end);

  bool isOngoing(DateTime now) => hasStarted(now) && !hasEnded(now);
}
