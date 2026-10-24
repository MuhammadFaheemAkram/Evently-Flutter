import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_details.freezed.dart';

/// Everything Event detail shows about one event.
@freezed
abstract class EventDetails with _$EventDetails {
  const factory EventDetails({
    required EventCardItem item,
    required Organizer organizer,

    /// The first sessions of the agenda, in order.
    @Default(<ScheduleSession>[]) List<ScheduleSession> agendaPreview,

    /// How many sessions the whole agenda has.
    @Default(0) int sessionCount,

    /// Your active ticket's id, when you're going.
    String? ticketId,
  }) = _EventDetails;
}
