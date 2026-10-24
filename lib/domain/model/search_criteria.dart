import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_criteria.freezed.dart';

/// An [EventFilter] resolved against the clock, as the database query needs
/// it: the dates as two instants, and "now" to leave out what's over.
@freezed
abstract class SearchCriteria with _$SearchCriteria {
  const factory SearchCriteria({
    /// Trimmed; empty matches everything.
    @Default('') String text,
    @Default(<EventCategory>{}) Set<EventCategory> categories,

    /// The window an event must overlap, start included, end excluded.
    DateTime? from,
    DateTime? until,
    @Default(PriceFilter.any) PriceFilter price,
    @Default(FormatFilter.any) FormatFilter format,
    @Default(RsvpFilter.any) RsvpFilter rsvp,

    /// Events that have ended by now are left out.
    required DateTime now,
  }) = _SearchCriteria;
}
