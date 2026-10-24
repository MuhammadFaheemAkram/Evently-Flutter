import 'package:evently/domain/model/calendar_date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_group.freezed.dart';

/// [items] that fall on one [day]: a list's "Today", "Tomorrow" sections.
@freezed
abstract class DayGroup<T> with _$DayGroup<T> {
  const factory DayGroup({required CalendarDate day, required List<T> items}) =
      _DayGroup<T>;
}
