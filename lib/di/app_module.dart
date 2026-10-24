import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/core/database/daos/organizers_dao.dart';
import 'package:evently/core/database/daos/profile_dao.dart';
import 'package:evently/core/database/daos/recent_searches_dao.dart';
import 'package:evently/core/database/daos/reminders_dao.dart';
import 'package:evently/core/database/daos/saved_events_dao.dart';
import 'package:evently/core/database/daos/session_bookmarks_dao.dart';
import 'package:evently/core/database/daos/tickets_dao.dart';
import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/platform/device_time_zone_reader.dart';
import 'package:evently/core/platform/local_notifications.dart';
import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/domain/service/dynamic_color_source.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Registers types the app doesn't own, so they can be injected (and replaced
/// in tests) like everything else.
@module
abstract class AppModule {
  /// The server the app talks to: the in-memory fake, which the developer
  /// tools also reach (to publish a catalog update).
  @lazySingleton
  EventlyApi api(FakeEventlyApi fake) => fake;

  /// The asset bundle the fake API reads its seed files from.
  @lazySingleton
  AssetBundle get assetBundle => rootBundle;

  /// The current time, injected so tests can fix it (`Clock.fixed`): the
  /// fake API renders its relative times ("in 3 days at 18:30") from it.
  @lazySingleton
  Clock get clock => const Clock();

  /// One database for the whole app. Several connections to the same SQLite
  /// file would break drift's change notifications.
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  CatalogDao catalogDao(AppDatabase database) => database.catalogDao;

  @lazySingleton
  UserDataDao userDataDao(AppDatabase database) => database.userDataDao;

  @lazySingleton
  EventsDao eventsDao(AppDatabase database) => database.eventsDao;

  @lazySingleton
  RecentSearchesDao recentSearchesDao(AppDatabase database) =>
      database.recentSearchesDao;

  @lazySingleton
  OrganizersDao organizersDao(AppDatabase database) => database.organizersDao;

  @lazySingleton
  ProfileDao profileDao(AppDatabase database) => database.profileDao;

  @lazySingleton
  TicketsDao ticketsDao(AppDatabase database) => database.ticketsDao;

  @lazySingleton
  SessionBookmarksDao sessionBookmarksDao(AppDatabase database) =>
      database.sessionBookmarksDao;

  @lazySingleton
  RemindersDao remindersDao(AppDatabase database) => database.remindersDao;

  @lazySingleton
  SavedEventsDao savedEventsDao(AppDatabase database) =>
      database.savedEventsDao;

  /// `@preResolve` awaits this before `runApp`, so preferences can be read
  /// synchronously from the first frame: the router knows at once whether
  /// to open Welcome or Discover.
  @preResolve
  @lazySingleton
  Future<SharedPreferencesWithCache> get preferences =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: SettingsLocalDataSource.allowList,
        ),
      );

  /// The device's time zone, before the first frame: Discover's "Today"
  /// is the user's day. `main` loads the zone database first.
  @preResolve
  @lazySingleton
  Future<DeviceTimeZone> get deviceTimeZone => readDeviceTimeZone();

  /// One plugin wrapper for the app, under both of its roles: scheduling
  /// notifications, and reporting taps. The background isolate builds its
  /// own (`BackgroundGraph`).
  @lazySingleton
  LocalNotifications get localNotifications => LocalNotifications();

  @lazySingleton
  NotificationScheduler notificationScheduler(LocalNotifications plugin) =>
      plugin;

  @lazySingleton
  NotificationInteractions notificationInteractions(
    LocalNotifications plugin,
  ) => plugin;

  /// Read once before the first frame, like the preferences: About and
  /// Settings show the version without a loading state.
  @preResolve
  @lazySingleton
  Future<AppInfo> get appInfo async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      name: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }

  /// The wallpaper's color, before the first frame: the first frame is
  /// already in the right colors.
  @preResolve
  @lazySingleton
  Future<DeviceColors> deviceColors(DynamicColorSource source) async =>
      DeviceColors(wallpaperColor: await source.wallpaperColor());
}
