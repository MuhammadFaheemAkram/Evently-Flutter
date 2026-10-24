import 'package:evently/core/common/event_clock.dart';
import 'package:evently/domain/calculation/event_timeline.dart';
import 'package:evently/domain/model/day_group.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_sections.freezed.dart';

/// What Discover lists.
@freezed
abstract class DiscoverSections with _$DiscoverSections {
  const factory DiscoverSections({
    @Default(<EventCardItem>[]) List<EventCardItem> featured,
    @Default(<EventCardItem>[]) List<EventCardItem> inYourCity,
    @Default(<DayGroup<EventCardItem>>[])
    List<DayGroup<EventCardItem>> upcoming,
  }) = _DiscoverSections;
}

/// Discover's sections from every cached event ([cards], any order):
/// - **featured:** upcoming featured events;
/// - **in your city:** upcoming in-person events in [city] (none for
///   "Anywhere", `null`);
/// - **upcoming:** upcoming events in [category] (all when `null`), grouped
///   by the user's day.
///
/// Each list is soonest first; past events appear in none of them.
DiscoverSections discoverSections(
  Iterable<EventCardItem> cards, {
  required EventClock clock,
  String? city,
  EventCategory? category,
}) {
  final now = clock.now();
  final upcoming = cards.where((card) => isUpcoming(card.event, now)).toList()
    ..sort((a, b) => a.event.time.start.compareTo(b.event.time.start));
  return DiscoverSections(
    featured: [
      for (final card in upcoming)
        if (card.event.featured) card,
    ],
    inYourCity: [
      if (city != null)
        for (final card in upcoming)
          if (card.event.location case Venue(city: final venueCity)
              when venueCity == city)
            card,
    ],
    upcoming: groupByDay(
      upcoming.where(
        (card) => category == null || card.event.category == category,
      ),
      startOf: (card) => card.event.time.start,
      dayOf: clock.dayOf,
      today: clock.today(),
    ),
  );
}
