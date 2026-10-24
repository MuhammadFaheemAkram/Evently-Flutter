import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'saved_events_dao.g.dart';

/// The user's saved events. Local only: saving needs no server, so it works
/// offline.
@DriftAccessor(tables: [SavedEvents])
class SavedEventsDao extends DatabaseAccessor<AppDatabase>
    with _$SavedEventsDaoMixin {
  SavedEventsDao(super.attachedDatabase);

  /// Saves [eventId] at [at]. Saving it again keeps the first time (`INSERT
  /// OR IGNORE`, safe here: nothing points at a saved row, so the ignored
  /// insert has nothing to cascade).
  Future<void> save(String eventId, DateTime at) => into(savedEvents).insert(
    SavedEventRow(eventId: eventId, savedAt: at),
    mode: InsertMode.insertOrIgnore,
  );

  Future<void> unsave(String eventId) =>
      (delete(savedEvents)..where((s) => s.eventId.equals(eventId))).go();
}
