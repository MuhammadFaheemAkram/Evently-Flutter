import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:evently/core/database/converters.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/core/database/tables/tables.dart';
import 'package:evently/domain/model/event_enums.dart';

part 'app_database.g.dart';

/// The app's SQLite database: the **cache** of what the server serves (the
/// catalog) and the **source of truth** for what the user owns.
///
/// Every screen reads it, never the API: the app works offline, and a
/// refresh only changes what the screens are watching.
///
/// This file and the rest of `core/database/` never import `material_ui` or
/// the JSON packages: drift exports `Table`, `Column` and `JsonKey`, and
/// those names would clash (conventions §11.1).
@DriftDatabase(
  tables: [
    Organizers,
    Events,
    TicketOffers,
    Sessions,
    SavedEvents,
    Tickets,
    SessionBookmarks,
    FollowedOrganizers,
    EventReminders,
    EventChanges,
    RecentSearches,
    Profiles,
  ],
  daos: [CatalogDao, UserDataDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens `evently.sqlite` in the app's documents directory. Tests pass an
  /// in-memory [executor] instead.
  ///
  /// `shareAcrossIsolates`: from Phase 7 the background sync runs in a
  /// second isolate (`workmanager`) while the app may be open. With this
  /// option both isolates talk to one drift server that owns the only
  /// connection, so they never write the file at once, and each sees the
  /// other's changes in its streams.
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'evently',
              native: const DriftNativeOptions(shareAcrossIsolates: true),
            ),
      );

  /// Each phase is treated as a release: a phase that changes the schema
  /// bumps this, exports the new version (`drift_dev make-migrations`) and
  /// ships a tested migration.
  ///
  /// 1. Phase 2: every table.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // SQLite ships with foreign keys *off*, per connection. Without this
    // pragma, every REFERENCES, CASCADE and the protection of the user's
    // rows would be ignored.
    beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
  );
}
