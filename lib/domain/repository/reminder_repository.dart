import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_change.dart';

/// What the notifications are made from: the events a reminder can be for,
/// the reminder toggles, and the changes a sync recorded.
abstract interface class ReminderRepository {
  /// The events you're going to or saved, with your reminder choice,
  /// soonest first; a new list after every change to them.
  Stream<List<EventCardItem>> watchRemindable();

  /// Turns [eventId]'s reminder on or off. Local, like a save.
  Future<Result<void>> setReminder(String eventId, {required bool enabled});

  /// The recorded changes not alerted yet, now marked alerted: each is
  /// returned once, to whoever asks first.
  Future<List<EventChange>> claimUnalertedChanges();
}
