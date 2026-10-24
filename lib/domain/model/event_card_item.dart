import 'package:evently/domain/model/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_card_item.freezed.dart';

/// An event as a list shows it: the event, its organizer's name, and what
/// *you* did about it.
///
/// [isSaved] and [isGoing] are never columns of the event: they are joins
/// over your own tables (a saved row, an active ticket), worked out each
/// time the list is read. A refresh rewrites the event and can't touch them.
@freezed
abstract class EventCardItem with _$EventCardItem {
  const factory EventCardItem({
    required Event event,
    required String organizerName,
    @Default(false) bool isSaved,

    /// You hold an active ticket.
    @Default(false) bool isGoing,

    /// Your choice on the event's reminder toggle; `null` until you touch
    /// it, when the default applies.
    bool? reminderChoice,
  }) = _EventCardItem;

  const EventCardItem._();

  /// Only an event you're going to or saved has a reminder.
  bool get canHaveReminder => isGoing || isSaved;

  /// Whether you're reminded before it: your choice, or by default only
  /// when you're going (a save alone is "maybe").
  bool get hasReminder => canHaveReminder && (reminderChoice ?? isGoing);
}
