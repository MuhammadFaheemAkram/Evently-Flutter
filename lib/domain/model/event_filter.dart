import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_filter.freezed.dart';

/// When an event should happen, in the user's calendar.
enum DatePreset {
  any,
  today,

  /// Saturday and Sunday; on a Sunday, just today.
  thisWeekend,

  /// Today and the six days after it.
  next7Days,

  /// [EventFilter.from] to [EventFilter.to], both included.
  custom,
}

enum PriceFilter { any, free, paid }

enum FormatFilter { any, online, inPerson }

enum RsvpFilter { any, going, notGoing }

/// What Search asks for: text plus a typed filter. Each field narrows the
/// results; the defaults narrow nothing.
@freezed
abstract class EventFilter with _$EventFilter {
  const factory EventFilter({
    /// Matched against the title, the organizer, the venue and the city.
    @Default('') String query,
    @Default(<EventCategory>{}) Set<EventCategory> categories,
    @Default(DatePreset.any) DatePreset dates,

    /// The custom range's first and last day ([DatePreset.custom] only).
    CalendarDate? from,
    CalendarDate? to,
    @Default(PriceFilter.any) PriceFilter price,
    @Default(FormatFilter.any) FormatFilter format,
    @Default(RsvpFilter.any) RsvpFilter rsvp,
  }) = _EventFilter;

  const EventFilter._();

  /// How many filters are on (the text not counted): the filter button's
  /// badge.
  int get activeCount =>
      categories.length +
      (dates == DatePreset.any ? 0 : 1) +
      (price == PriceFilter.any ? 0 : 1) +
      (format == FormatFilter.any ? 0 : 1) +
      (rsvp == RsvpFilter.any ? 0 : 1);

  bool get hasFilters => activeCount > 0;

  /// The same filters, without any text.
  EventFilter get withoutQuery => copyWith(query: '');

  /// The same text, without any filter.
  EventFilter get withoutFilters => EventFilter(query: query);
}
