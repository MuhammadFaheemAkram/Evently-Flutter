import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/demo_calendar.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/core/platform/device_time_zone_reader.dart';
import 'package:evently/core/platform/local_notifications.dart';
import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:evently/data/repository/catalog_repository_impl.dart';
import 'package:evently/data/repository/reminder_repository_impl.dart';
import 'package:evently/data/repository/settings_repository_impl.dart';
import 'package:evently/domain/usecase/background_use_cases.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;

/// What the background isolate needs: the same use cases the app runs, on
/// the same database file and preferences.
///
/// **Its own small graph, built by hand.** A background isolate shares no
/// memory with the app: `getIt` there is empty, and the app may not even be
/// running. The whole app graph (screens' Cubits, the router's settings
/// stream, the wallpaper's colors) would be wasted work in a job that has
/// seconds to run, so this builds only what the sync uses, from the same
/// classes (correctness rule 14).
///
/// **The same database:** `AppDatabase` opens with `shareAcrossIsolates`,
/// so if the app is open too, both isolates talk to one drift server
/// isolate: writes never collide, the app's screens see the sync's changes
/// at once, and a change alert is claimed by one isolate only.
///
/// **Preferences** have a cache per isolate: what this one saves (a
/// permission found revoked) reaches the app when it reloads them, on
/// resume.
///
/// **The fake server** is in memory, so this isolate's is a fresh one, as
/// if the server had restarted: it hasn't seen the app's bookings or a
/// published catalog update. Its calendar is shared (the anchor is in the
/// preferences), so the events are where the app's server has them. A
/// real backend is one server for both.
final class BackgroundGraph {
  BackgroundGraph({required this.runSync, required this._close});

  final RunBackgroundSyncUseCase runSync;
  final Future<void> Function() _close;

  /// Closes the database connection and the settings.
  Future<void> close() => _close();

  static Future<BackgroundGraph> open() async {
    tz_data.initializeTimeZones();
    final database = AppDatabase();
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsLocalDataSource.allowList,
      ),
    );
    const clock = Clock();
    final eventClock = EventClock(clock, await readDeviceTimeZone());
    final local = SettingsLocalDataSource(preferences);
    final settings = SettingsRepositoryImpl(local);
    final api = FakeEventlyApi(
      AssetJsonLoader(rootBundle),
      NetworkSimulator(),
      clock,
      StoredDemoCalendar(local, clock),
    );
    final reminders = ReminderRepositoryImpl(
      database.remindersDao,
      database.eventsDao,
    );
    final notifications = LocalNotifications();
    return BackgroundGraph(
      runSync: RunBackgroundSyncUseCase(
        CatalogRepositoryImpl(
          api,
          database.catalogDao,
          database.eventsDao,
          database.remindersDao,
          eventClock,
        ),
        AlertCatalogChangesUseCase(
          reminders,
          settings,
          notifications,
          eventClock,
        ),
        SyncNotificationsUseCase(
          settings,
          reminders,
          notifications,
          eventClock,
        ),
      ),
      close: () async {
        await settings.dispose();
        await database.close();
      },
    );
  }
}
