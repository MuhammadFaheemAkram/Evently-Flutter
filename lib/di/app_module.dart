import 'package:clock/clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Registers types the app doesn't own, so they can be injected (and replaced
/// in tests) like everything else.
@module
abstract class AppModule {
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
}
