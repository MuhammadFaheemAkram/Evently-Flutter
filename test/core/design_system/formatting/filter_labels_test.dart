import 'package:evently/core/design_system/formatting/filter_labels.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every choice has a label', () {
    for (final preset in DatePreset.values) {
      expect(FilterLabels.dates(preset), isNotEmpty);
    }
    for (final price in PriceFilter.values) {
      expect(FilterLabels.price(price), isNotEmpty);
    }
    for (final format in FormatFilter.values) {
      expect(FilterLabels.format(format), isNotEmpty);
    }
    for (final rsvp in RsvpFilter.values) {
      expect(FilterLabels.rsvp(rsvp), isNotEmpty);
    }
  });

  test('a custom range reads as its days, with years when they differ', () {
    expect(
      FilterLabels.range(
        CalendarDate(2026, 10, 24),
        CalendarDate(2026, 10, 31),
      ),
      '24 Oct – 31 Oct',
    );
    expect(
      FilterLabels.range(CalendarDate(2026, 12, 30), CalendarDate(2027, 1, 2)),
      '30 Dec 2026 – 2 Jan 2027',
    );
  });

  test('no filter on: no chips', () {
    expect(FilterLabels.active(const EventFilter(query: 'jazz')), isEmpty);
  });

  test('each filter on is a chip that removes only itself', () {
    final filter = EventFilter(
      query: 'jazz',
      categories: const {EventCategory.music, EventCategory.design},
      dates: DatePreset.custom,
      from: CalendarDate(2026, 10, 24),
      to: CalendarDate(2026, 10, 31),
      price: PriceFilter.free,
      format: FormatFilter.inPerson,
      rsvp: RsvpFilter.notGoing,
    );

    final chips = FilterLabels.active(filter);

    expect(
      [for (final (label, _) in chips) label],
      ['Music', 'Design', '24 Oct – 31 Oct', 'Free', 'In person', 'Not going'],
    );
    final (_, withoutMusic) = chips.first;
    expect(withoutMusic.categories, {EventCategory.design});
    expect(withoutMusic.query, 'jazz');
    final (_, withoutDates) = chips[2];
    expect(withoutDates.dates, DatePreset.any);
    expect(withoutDates.from, isNull);
    for (final (_, without) in chips) {
      expect(without.activeCount, filter.activeCount - 1);
    }
  });
}
