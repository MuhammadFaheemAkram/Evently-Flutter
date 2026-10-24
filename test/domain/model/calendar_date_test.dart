import 'package:evently/domain/model/calendar_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('creating', () {
    test('packs year, month and day into yyyymmdd', () {
      final date = CalendarDate(2026, 10, 14);

      expect(date.yyyymmdd, 20261014);
      expect((date.year, date.month, date.day), (2026, 10, 14));
      expect(date.toIso(), '2026-10-14');
    });

    test('refuses days that do not exist', () {
      expect(() => CalendarDate(2026, 4, 31), throwsArgumentError);
      expect(() => CalendarDate(2027, 2, 29), throwsArgumentError);
      expect(() => CalendarDate(2026, 13, 1), throwsArgumentError);
      expect(() => CalendarDate(2026, 1, 0), throwsArgumentError);
    });

    test('accepts 29 February in a leap year', () {
      expect(CalendarDate(2028, 2, 29).day, 29);
    });

    test('clamps a day to the end of a short month', () {
      expect(CalendarDate.clamped(2027, 2, 31), CalendarDate(2027, 2, 28));
      expect(CalendarDate.clamped(2028, 2, 31), CalendarDate(2028, 2, 29));
      expect(CalendarDate.clamped(2026, 4, 31), CalendarDate(2026, 4, 30));
    });

    test('reads back a stored integer, and refuses a broken one', () {
      expect(CalendarDate.fromInt(20261014), CalendarDate(2026, 10, 14));
      expect(() => CalendarDate.fromInt(20261340), throwsArgumentError);
    });

    test("takes a DateTime's own calendar day, ignoring the time", () {
      expect(
        CalendarDate.fromDateTime(DateTime(2026, 10, 14, 23, 59)),
        CalendarDate(2026, 10, 14),
      );
    });
  });

  group('arithmetic', () {
    test('adds and removes days across months and years', () {
      expect(CalendarDate(2026, 10, 31).addDays(1), CalendarDate(2026, 11, 1));
      expect(CalendarDate(2026, 1, 1).addDays(-1), CalendarDate(2025, 12, 31));
      expect(CalendarDate(2028, 2, 28).addDays(1), CalendarDate(2028, 2, 29));
    });

    test('a day is a day even across a daylight-saving change', () {
      // 29 March 2026 is the EU's spring-forward day.
      expect(CalendarDate(2026, 3, 28).addDays(2), CalendarDate(2026, 3, 30));
    });

    test('adds months, clamping to the end of a shorter month', () {
      expect(CalendarDate(2026, 1, 31).addMonths(1), CalendarDate(2026, 2, 28));
      expect(
        CalendarDate(2026, 3, 31).addMonths(-1),
        CalendarDate(2026, 2, 28),
      );
      expect(
        CalendarDate(2026, 11, 15).addMonths(3),
        CalendarDate(2027, 2, 15),
      );
      expect(
        CalendarDate(2026, 2, 15).addMonths(-14),
        CalendarDate(2024, 12, 15),
      );
    });

    test('knows the weekday', () {
      expect(CalendarDate(2026, 10, 14).weekday, DateTime.wednesday);
    });

    test('compares like the days it stands for', () {
      final earlier = CalendarDate(2026, 9, 30);
      final later = CalendarDate(2026, 10, 1);

      expect(earlier < later, isTrue);
      expect(later >= earlier, isTrue);
      expect(earlier <= CalendarDate(2026, 9, 30), isTrue);
      expect(later > earlier, isTrue);
    });

    test("finds its ISO week's Monday, across a month and a year", () {
      // Wednesday 21 October 2026.
      expect(CalendarDate(2026, 10, 21).weekStart, CalendarDate(2026, 10, 19));
      // A Monday is its own week's start; a Sunday ends the week.
      expect(CalendarDate(2026, 10, 19).weekStart, CalendarDate(2026, 10, 19));
      expect(CalendarDate(2026, 10, 25).weekStart, CalendarDate(2026, 10, 19));
      // Thursday 1 October 2026 began on Monday 28 September.
      expect(CalendarDate(2026, 10, 1).weekStart, CalendarDate(2026, 9, 28));
      // Friday 1 January 2027 belongs to the week of 28 December 2026.
      expect(CalendarDate(2027, 1, 1).weekStart, CalendarDate(2026, 12, 28));
    });

    test("finds its month's first day", () {
      expect(CalendarDate(2026, 10, 21).monthStart, CalendarDate(2026, 10, 1));
    });

    test('counts the days to another day, either way, across DST changes', () {
      // Europe and the US leave summer time on 25 October and 1 November
      // 2026: in UTC every day is still 24 hours.
      expect(
        CalendarDate(2026, 10, 21).daysUntil(CalendarDate(2026, 11, 4)),
        14,
      );
      expect(
        CalendarDate(2026, 10, 21).daysUntil(CalendarDate(2026, 10, 14)),
        -7,
      );
      expect(CalendarDate(2026, 12, 31).daysUntil(CalendarDate(2027, 1, 1)), 1);
    });

    test('counts the days of every month', () {
      expect(CalendarDate.daysInMonth(2026, 2), 28);
      expect(CalendarDate.daysInMonth(2028, 2), 29);
      expect(CalendarDate.daysInMonth(2026, 12), 31);
      expect(CalendarDate.daysInMonth(2026, 9), 30);
    });
  });
}
