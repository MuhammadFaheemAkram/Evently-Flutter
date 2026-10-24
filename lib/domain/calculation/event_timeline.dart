import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/day_group.dart';
import 'package:evently/domain/model/event.dart';

/// Upcoming until its last instant: an ongoing event is still upcoming, an
/// event that ended a second ago is past. By instants, so the answer is the
/// same in every time zone.
bool isUpcoming(Event event, DateTime now) => !event.time.hasEnded(now);

/// [items] (in time order) grouped by the user's day each starts on.
///
/// [dayOf] reads an instant in the user's zone. An item that started before
/// [today] and is still on (the second day of a conference) is listed under
/// today: it's happening now, not in the past.
List<DayGroup<T>> groupByDay<T>(
  Iterable<T> items, {
  required DateTime Function(T item) startOf,
  required CalendarDate Function(DateTime instant) dayOf,
  required CalendarDate today,
}) {
  final groups = <(CalendarDate, List<T>)>[];
  for (final item in items) {
    final started = dayOf(startOf(item));
    final day = started < today ? today : started;
    if (groups.isNotEmpty && groups.last.$1 == day) {
      groups.last.$2.add(item);
    } else {
      groups.add((day, [item]));
    }
  }
  return [for (final (day, items) in groups) DayGroup(day: day, items: items)];
}

/// [items] split by whether they're over at [now]: the upcoming soonest
/// first, the past most recent first.
({List<T> upcoming, List<T> past}) splitByEnd<T>(
  Iterable<T> items, {
  required Event Function(T item) eventOf,
  required DateTime now,
}) {
  final upcoming = <T>[];
  final past = <T>[];
  for (final item in items) {
    (isUpcoming(eventOf(item), now) ? upcoming : past).add(item);
  }
  int byStart(T a, T b) =>
      eventOf(a).time.start.compareTo(eventOf(b).time.start);
  upcoming.sort(byStart);
  past.sort((a, b) => byStart(b, a));
  return (upcoming: upcoming, past: past);
}
