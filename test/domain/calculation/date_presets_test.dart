import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/domain/calculation/date_presets.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  final wednesday = CalendarDate(2026, 10, 21);
  final saturday = CalendarDate(2026, 10, 24);
  final sunday = CalendarDate(2026, 10, 25);

  (CalendarDate, CalendarDate)? days(
    DatePreset preset,
    CalendarDate today, {
    CalendarDate? from,
    CalendarDate? to,
  }) => daysFor(EventFilter(dates: preset, from: from, to: to), today);

  group('the days a preset covers', () {
    test('any: no limit', () {
      expect(days(DatePreset.any, wednesday), isNull);
    });

    test('today', () {
      expect(days(DatePreset.today, wednesday), (wednesday, wednesday));
    });

    test('this weekend, on a weekday: the coming Saturday and Sunday', () {
      expect(days(DatePreset.thisWeekend, wednesday), (saturday, sunday));
    });

    test('this weekend, on a Saturday: today and tomorrow', () {
      expect(days(DatePreset.thisWeekend, saturday), (saturday, sunday));
    });

    test('this weekend, on a Sunday: just today', () {
      expect(days(DatePreset.thisWeekend, sunday), (sunday, sunday));
    });

    test('this weekend, on a Monday: the Saturday ahead', () {
      expect(days(DatePreset.thisWeekend, CalendarDate(2026, 10, 26)), (
        CalendarDate(2026, 10, 31),
        CalendarDate(2026, 11, 1),
      ));
    });

    test('next 7 days: today and the six after it', () {
      expect(days(DatePreset.next7Days, wednesday), (
        wednesday,
        CalendarDate(2026, 10, 27),
      ));
    });

    test('custom: the range, put in order', () {
      expect(
        days(DatePreset.custom, wednesday, from: saturday, to: wednesday),
        (wednesday, saturday),
      );
    });

    test('custom without both ends: no limit', () {
      expect(days(DatePreset.custom, wednesday, from: saturday), isNull);
    });
  });

  group('resolved against the user\'s clock (London)', () {
    final clock = EventClock(Clock.fixed(demoNow), londonZone);

    test('today runs midnight to midnight in summer time', () {
      final criteria = criteriaFor(
        const EventFilter(dates: DatePreset.today),
        clock,
      );

      expect(criteria.from, DateTime.utc(2026, 10, 20, 23));
      expect(criteria.until, DateTime.utc(2026, 10, 21, 23));
    });

    test('the weekend the clocks go back is 49 hours long', () {
      final criteria = criteriaFor(
        const EventFilter(dates: DatePreset.thisWeekend),
        clock,
      );

      expect(criteria.from, DateTime.utc(2026, 10, 23, 23));
      expect(criteria.until, DateTime.utc(2026, 10, 26));
      expect(
        criteria.until!.difference(criteria.from!),
        const Duration(hours: 49),
      );
    });

    test('the text is trimmed, the rest carried over, and now is now', () {
      final criteria = criteriaFor(
        const EventFilter(
          query: '  jazz ',
          categories: {EventCategory.music},
          price: PriceFilter.paid,
          format: FormatFilter.inPerson,
          rsvp: RsvpFilter.notGoing,
        ),
        clock,
      );

      expect(criteria.text, 'jazz');
      expect(criteria.categories, {EventCategory.music});
      expect(criteria.price, PriceFilter.paid);
      expect(criteria.format, FormatFilter.inPerson);
      expect(criteria.rsvp, RsvpFilter.notGoing);
      expect(criteria.from, isNull);
      expect(criteria.now, demoNow);
    });
  });

  group('the filter itself', () {
    test('counts the filters that are on, not the text', () {
      expect(const EventFilter(query: 'jazz').activeCount, 0);
      expect(
        const EventFilter(
          categories: {EventCategory.music, EventCategory.design},
          dates: DatePreset.today,
          price: PriceFilter.free,
          format: FormatFilter.online,
          rsvp: RsvpFilter.going,
        ).activeCount,
        6,
      );
    });

    test('drops its text, or its filters', () {
      const filter = EventFilter(query: 'jazz', price: PriceFilter.free);

      expect(filter.withoutQuery, const EventFilter(price: PriceFilter.free));
      expect(filter.withoutFilters, const EventFilter(query: 'jazz'));
      expect(filter.hasFilters, isTrue);
      expect(filter.withoutFilters.hasFilters, isFalse);
    });
  });
}
