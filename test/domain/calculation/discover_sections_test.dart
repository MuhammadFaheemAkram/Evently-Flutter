import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/domain/calculation/discover_sections.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/test_dependencies.dart';

void main() {
  // Wednesday 21 October, 15:00 in London.
  final clock = EventClock(Clock.fixed(demoNow), londonZone);

  EventTime at(int day, int hourUtc) => EventTime(
    start: DateTime.utc(2026, 10, day, hourUtc),
    end: DateTime.utc(2026, 10, day, hourUtc + 2),
    zone: 'Europe/London',
  );

  final past = card(event(id: 'past', time: at(20, 18), featured: true));
  final tonight = card(event(id: 'tonight', time: at(21, 18), featured: true));
  final berlin = card(
    event(id: 'berlin', time: at(22, 9), location: venueIn('Berlin')),
  );
  final online = card(
    event(
      id: 'online',
      time: at(21, 20),
      location: onlineAt('https://meet.example/a'),
    ),
  );
  final music = card(
    event(id: 'music', time: at(23, 19), category: EventCategory.music),
  );
  final all = [music, berlin, online, past, tonight];

  List<String> ids(Iterable<EventCardItem> cards) => [
    for (final c in cards) c.event.id,
  ];

  test('featured: upcoming featured events only', () {
    final sections = discoverSections(all, clock: clock);

    expect(ids(sections.featured), ['tonight']);
  });

  test('in your city: upcoming in-person events there, soonest first', () {
    expect(
      ids(discoverSections(all, clock: clock, city: 'London').inYourCity),
      ['tonight', 'music'],
    );
    expect(
      ids(discoverSections(all, clock: clock, city: 'Berlin').inYourCity),
      ['berlin'],
    );
  });

  test('"Anywhere" has no city section', () {
    expect(discoverSections(all, clock: clock).inYourCity, isEmpty);
  });

  test('upcoming: every upcoming event, by the user\'s day, past ones '
      'left out', () {
    final upcoming = discoverSections(all, clock: clock).upcoming;

    expect(
      [for (final g in upcoming) g.day],
      [
        CalendarDate(2026, 10, 21),
        CalendarDate(2026, 10, 22),
        CalendarDate(2026, 10, 23),
      ],
    );
    expect(ids(upcoming.first.items), ['tonight', 'online']);
  });

  test("a late event is grouped on the user's day, not UTC's", () {
    // Thursday 23:30 UTC is Friday 00:30 in London.
    final late = card(
      event(
        id: 'late',
        time: EventTime(
          start: DateTime.utc(2026, 10, 22, 23, 30),
          end: DateTime.utc(2026, 10, 23, 1),
          zone: 'Europe/London',
        ),
      ),
    );

    final upcoming = discoverSections([late], clock: clock).upcoming;

    expect(upcoming.single.day, CalendarDate(2026, 10, 23));
  });

  test('a category filters the upcoming list only', () {
    final sections = discoverSections(
      all,
      clock: clock,
      city: 'London',
      category: EventCategory.music,
    );

    expect(ids(sections.upcoming.expand((g) => g.items)), ['music']);
    expect(ids(sections.featured), ['tonight']);
    expect(ids(sections.inYourCity), ['tonight', 'music']);
  });

  test('a category with nothing coming up gives no groups', () {
    final sections = discoverSections(
      all,
      clock: clock,
      category: EventCategory.health,
    );

    expect(sections.upcoming, isEmpty);
  });
}
