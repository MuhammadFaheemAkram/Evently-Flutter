import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';
import 'package:evently/domain/model/event_enums.dart';

part 'reminders_dao.g.dart';

/// A change as it was recorded.
typedef RecordedChange = ({int id, String eventId, EventChangeKind kind});

/// The user's notification rows: the reminder toggles, and the changes a
/// sync recorded for the alerts.
@DriftAccessor(tables: [EventReminders, EventChanges, Tickets])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.attachedDatabase);

  /// The user's choice on [eventId]'s reminder toggle. Written as a choice
  /// either way (`false` is "not for this one"), so the default for an
  /// event you're going to can be turned off.
  Future<void> setReminder(String eventId, {required bool enabled}) =>
      into(eventReminders).insertOnConflictUpdate(
        EventReminderRow(eventId: eventId, enabled: enabled),
      );

  /// The events the user holds an active ticket for.
  Future<Set<String>> ticketedEventIds() async {
    final query = selectOnly(tickets, distinct: true)
      ..addColumns([tickets.eventId])
      ..where(tickets.cancelledAt.isNull());
    return {for (final row in await query.get()) row.read(tickets.eventId)!};
  }

  /// Records [changes], detected [at]; not alerted yet.
  Future<void> recordChanges(
    List<({String eventId, EventChangeKind kind})> changes, {
    required DateTime at,
  }) => batch(
    (batch) => batch.insertAll(eventChanges, [
      for (final change in changes)
        EventChangesCompanion.insert(
          eventId: change.eventId,
          kind: change.kind,
          detectedAt: at,
        ),
    ]),
  );

  /// The changes not alerted yet, oldest first, marked alerted (`seen`) in
  /// the same transaction: whoever claims a change alerts it, and no one
  /// else can. The app and the background isolate may sync at the same
  /// time; through the one drift server they share, only one gets each
  /// change.
  Future<List<RecordedChange>> claimUnalerted() => transaction(() async {
    final rows =
        await (select(eventChanges)
              ..where((c) => c.seen.not())
              ..orderBy([(c) => OrderingTerm(expression: c.id)]))
            .get();
    if (rows.isEmpty) return const [];
    await (update(eventChanges)
          ..where((c) => c.id.isIn([for (final row in rows) row.id])))
        .write(const EventChangesCompanion(seen: Value(true)));
    return [
      for (final row in rows)
        (id: row.id, eventId: row.eventId, kind: row.kind),
    ];
  });

  /// Every change recorded, oldest first (for tests and the developer).
  Future<List<EventChangeRow>> allChanges() => (select(
    eventChanges,
  )..orderBy([(c) => OrderingTerm(expression: c.id)])).get();
}
