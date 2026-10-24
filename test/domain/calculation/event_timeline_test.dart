import 'package:evently/domain/calculation/event_timeline.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/day_group.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/catalog_fixtures.dart';

void main() {
  group('upcoming until its last instant', () {
    final evening = event(); // 17:30–20:00 UTC, Saturday 24 October.
    const tick = Duration(microseconds: 1);

    test('before it starts', () {
      expect(isUpcoming(evening, saturdayEvening.start.subtract(tick)), true);
    });

    test('while it is on', () {
      expect(isUpcoming(evening, saturdayEvening.start), isTrue);
      expect(isUpcoming(evening, saturdayEvening.end.subtract(tick)), isTrue);
    });

    test('not once it ends', () {
      expect(isUpcoming(evening, saturdayEvening.end), isFalse);
    });
  });

  group('grouped by the user\'s day', () {
    final london = tz.getLocation('Europe/London');
    CalendarDate inLondon(DateTime instant) =>
        CalendarDate.fromDateTime(tz.TZDateTime.from(instant, london));
    final today = CalendarDate(2026, 10, 21);

    List<DayGroup<String>> group(Map<String, DateTime> starts) => groupByDay(
      starts.keys,
      startOf: (id) => starts[id]!,
      dayOf: inLondon,
      today: today,
    );

    test('consecutive items on one day share a group, in order', () {
      final groups = group({
        'a': DateTime.utc(2026, 10, 21, 17),
        'b': DateTime.utc(2026, 10, 21, 18),
        'c': DateTime.utc(2026, 10, 22, 9),
      });

      expect(groups, [
        DayGroup(day: today, items: const ['a', 'b']),
        DayGroup(day: CalendarDate(2026, 10, 22), items: const ['c']),
      ]);
    });

    test('a New York night is tomorrow in London', () {
      // Wednesday 23:30 EDT = Thursday 04:30 BST.
      final groups = group({'jam': DateTime.utc(2026, 10, 22, 3, 30)});

      expect(groups.single.day, CalendarDate(2026, 10, 22));
    });

    test('just before midnight in London is still today', () {
      // 23:59 BST = 22:59 UTC.
      final groups = group({'late': DateTime.utc(2026, 10, 21, 22, 59)});

      expect(groups.single.day, today);
    });

    test('an event that started on an earlier day and is still on is '
        'listed today', () {
      final groups = group({
        'conference day two': DateTime.utc(2026, 10, 20, 8),
        'tonight': DateTime.utc(2026, 10, 21, 18),
      });

      expect(groups, [
        DayGroup(day: today, items: const ['conference day two', 'tonight']),
      ]);
    });

    test('nothing gives no groups', () {
      expect(group({}), isEmpty);
    });
  });

  test('an EventTime and the timeline agree on "ended"', () {
    final time = EventTime(
      start: DateTime.utc(2026, 10, 21, 9),
      end: DateTime.utc(2026, 10, 21, 10),
      zone: 'Europe/London',
    );

    expect(isUpcoming(event(time: time), time.end), isFalse);
  });
}
