import 'package:evently/core/common/event_clock.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/domain/model/search_criteria.dart';
import 'package:timezone/timezone.dart' as tz;

/// The first and last day [filter]'s dates cover, in the user's calendar
/// (both included), or `null` for any day.
///
/// "This weekend" is Saturday and Sunday; on a Saturday it starts today, on
/// a Sunday it is just today (yesterday is over). A custom range missing
/// either end covers any day.
(CalendarDate, CalendarDate)? daysFor(EventFilter filter, CalendarDate today) {
  switch (filter.dates) {
    case DatePreset.any:
      return null;
    case DatePreset.today:
      return (today, today);
    case DatePreset.thisWeekend:
      final weekday = today.toDateTime().weekday;
      if (weekday == DateTime.sunday) return (today, today);
      final saturday = today.addDays(DateTime.saturday - weekday);
      return (saturday, saturday.addDays(1));
    case DatePreset.next7Days:
      return (today, today.addDays(6));
    case DatePreset.custom:
      final from = filter.from;
      final to = filter.to;
      if (from == null || to == null) return null;
      return from <= to ? (from, to) : (to, from);
  }
}

/// [filter] resolved against [clock]: its days become the instants where
/// they begin and end in the user's zone (midnight to midnight, whatever
/// the clocks do), and the text is trimmed.
SearchCriteria criteriaFor(EventFilter filter, EventClock clock) {
  final days = daysFor(filter, clock.today());
  DateTime midnight(CalendarDate day) =>
      tz.TZDateTime(clock.local, day.year, day.month, day.day).toUtc();
  return SearchCriteria(
    text: filter.query.trim(),
    categories: filter.categories,
    from: days == null ? null : midnight(days.$1),
    until: days == null ? null : midnight(days.$2.addDays(1)),
    price: filter.price,
    format: filter.format,
    rsvp: filter.rsvp,
    now: clock.now(),
  );
}
