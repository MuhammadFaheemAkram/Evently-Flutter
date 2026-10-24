import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog.freezed.dart';

/// What the server serves, all of it: one refresh writes it to the cache in
/// one transaction.
@freezed
abstract class Catalog with _$Catalog {
  const factory Catalog({
    @Default(<Organizer>[]) List<Organizer> organizers,
    @Default(<Event>[]) List<Event> events,
    @Default(<ScheduleSession>[]) List<ScheduleSession> sessions,
  }) = _Catalog;
}
