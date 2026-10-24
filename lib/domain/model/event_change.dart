import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_change.freezed.dart';

/// A change a sync recorded on an event you hold a ticket for, with the
/// event as it is now: what a change alert tells.
@freezed
abstract class EventChange with _$EventChange {
  const factory EventChange({
    /// The record's id: one alert per record.
    required int id,
    required EventChangeKind kind,
    required Event event,

    /// Your active ticket for it, where the alert's tap leads (`null` once
    /// you cancelled it: the tap opens the event).
    String? ticketId,
  }) = _EventChange;
}
