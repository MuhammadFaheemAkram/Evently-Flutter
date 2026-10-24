import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:intl/intl.dart';

/// How Search's filters read: in the sheet, and as the removable chips of
/// the filters that are on.
abstract final class FilterLabels {
  static String dates(DatePreset preset) => switch (preset) {
    DatePreset.any => 'Any dates',
    DatePreset.today => 'Today',
    DatePreset.thisWeekend => 'This weekend',
    DatePreset.next7Days => 'Next 7 days',
    DatePreset.custom => 'Custom…',
  };

  static String price(PriceFilter price) => switch (price) {
    PriceFilter.any => 'Any price',
    PriceFilter.free => 'Free',
    PriceFilter.paid => 'Paid',
  };

  static String format(FormatFilter format) => switch (format) {
    FormatFilter.any => 'Any format',
    FormatFilter.online => 'Online',
    FormatFilter.inPerson => 'In person',
  };

  static String rsvp(RsvpFilter rsvp) => switch (rsvp) {
    RsvpFilter.any => 'Any',
    RsvpFilter.going => 'Going',
    RsvpFilter.notGoing => 'Not going',
  };

  /// "24 Oct – 31 Oct" (with the years when they aren't the same).
  static String range(CalendarDate from, CalendarDate to) {
    final pattern = from.year == to.year ? 'd MMM' : 'd MMM y';
    final format = DateFormat(pattern);
    return '${format.format(from.toDateTime())} – '
        '${format.format(to.toDateTime())}';
  }

  /// Each filter that is on, with its label and the filter without it:
  /// the chips above the results, each removable on its own.
  static List<(String, EventFilter)> active(EventFilter filter) {
    final from = filter.from;
    final to = filter.to;
    return [
      for (final EventCategory category in filter.categories)
        (
          category.label,
          filter.copyWith(categories: {...filter.categories}..remove(category)),
        ),
      if (filter.dates != DatePreset.any)
        (
          filter.dates == DatePreset.custom && from != null && to != null
              ? range(from, to)
              : dates(filter.dates),
          filter.copyWith(dates: DatePreset.any, from: null, to: null),
        ),
      if (filter.price != PriceFilter.any)
        (price(filter.price), filter.copyWith(price: PriceFilter.any)),
      if (filter.format != FormatFilter.any)
        (format(filter.format), filter.copyWith(format: FormatFilter.any)),
      if (filter.rsvp != RsvpFilter.any)
        (rsvp(filter.rsvp), filter.copyWith(rsvp: RsvpFilter.any)),
    ];
  }
}
