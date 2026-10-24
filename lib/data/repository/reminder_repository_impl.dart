import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/core/database/daos/reminders_dao.dart';
import 'package:evently/data/mapper/event_card_mappers.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_change.dart';
import 'package:evently/domain/repository/reminder_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReminderRepository)
class ReminderRepositoryImpl implements ReminderRepository {
  const ReminderRepositoryImpl(this._reminders, this._events);

  final RemindersDao _reminders;
  final EventsDao _events;

  @override
  Stream<List<EventCardItem>> watchRemindable() => _events
      .watchRemindable()
      .map((rows) => [for (final row in rows) row.toDomain()]);

  @override
  Future<Result<void>> setReminder(String eventId, {required bool enabled}) =>
      guardWrite(
        'Setting a reminder',
        () => _reminders.setReminder(eventId, enabled: enabled),
      );

  /// Each claimed change with its event as the cache has it now (the user
  /// rows `RESTRICT` the event's deletion, so it's there).
  @override
  Future<List<EventChange>> claimUnalertedChanges() async {
    final changes = await _reminders.claimUnalerted();
    return [
      for (final change in changes)
        if (await _events.watchCard(change.eventId).first case final row?)
          EventChange(
            id: change.id,
            kind: change.kind,
            event: row.toDomain().event,
            ticketId: row.activeTicketId,
          ),
    ];
  }
}
