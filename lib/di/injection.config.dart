// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:clock/clock.dart' as _i454;
import 'package:evently/core/common/event_clock.dart' as _i805;
import 'package:evently/core/database/app_database.dart' as _i496;
import 'package:evently/core/database/daos/catalog_dao.dart' as _i601;
import 'package:evently/core/database/daos/events_dao.dart' as _i386;
import 'package:evently/core/database/daos/saved_events_dao.dart' as _i794;
import 'package:evently/core/database/daos/user_data_dao.dart' as _i542;
import 'package:evently/core/network/asset_json_loader.dart' as _i1000;
import 'package:evently/core/network/evently_api.dart' as _i844;
import 'package:evently/core/network/fake_evently_api.dart' as _i796;
import 'package:evently/core/network/network_simulator.dart' as _i1024;
import 'package:evently/core/platform/url_launcher_link_opener.dart' as _i1051;
import 'package:evently/core/storage/settings_local_data_source.dart' as _i327;
import 'package:evently/data/repository/catalog_repository_impl.dart' as _i507;
import 'package:evently/data/repository/demo_repository_impl.dart' as _i936;
import 'package:evently/data/repository/saved_event_repository_impl.dart'
    as _i947;
import 'package:evently/data/repository/settings_repository_impl.dart' as _i4;
import 'package:evently/di/app_module.dart' as _i64;
import 'package:evently/domain/repository/catalog_repository.dart' as _i521;
import 'package:evently/domain/repository/demo_repository.dart' as _i182;
import 'package:evently/domain/repository/saved_event_repository.dart' as _i285;
import 'package:evently/domain/repository/settings_repository.dart' as _i233;
import 'package:evently/domain/service/link_opener.dart' as _i216;
import 'package:evently/domain/usecase/catalog_use_cases.dart' as _i997;
import 'package:evently/domain/usecase/event_use_cases.dart' as _i351;
import 'package:evently/domain/usecase/open_link_use_case.dart' as _i860;
import 'package:evently/domain/usecase/settings_use_cases.dart' as _i27;
import 'package:evently/domain/usecase/start_use_cases.dart' as _i1009;
import 'package:evently/features/discover/cubit/discover_cubit.dart' as _i664;
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart'
    as _i186;
import 'package:evently/features/welcome/cubit/welcome_cubit.dart' as _i321;
import 'package:flutter/services.dart' as _i281;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i1024.NetworkSimulator>(() => _i1024.NetworkSimulator());
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i454.Clock>(() => appModule.clock);
    gh.lazySingleton<_i496.AppDatabase>(() => appModule.appDatabase);
    await gh.lazySingletonAsync<_i460.SharedPreferencesWithCache>(
      () => appModule.preferences,
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i805.DeviceTimeZone>(
      () => appModule.deviceTimeZone,
      preResolve: true,
    );
    gh.lazySingleton<_i601.CatalogDao>(
      () => appModule.catalogDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i542.UserDataDao>(
      () => appModule.userDataDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i386.EventsDao>(
      () => appModule.eventsDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i794.SavedEventsDao>(
      () => appModule.savedEventsDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i216.LinkOpener>(
      () => const _i1051.UrlLauncherLinkOpener(),
    );
    gh.lazySingleton<_i327.SettingsLocalDataSource>(
      () =>
          _i327.SettingsLocalDataSource(gh<_i460.SharedPreferencesWithCache>()),
    );
    gh.lazySingleton<_i1000.AssetJsonLoader>(
      () => _i1000.AssetJsonLoader(gh<_i281.AssetBundle>()),
    );
    gh.lazySingleton<_i844.EventlyApi>(
      () => _i796.FakeEventlyApi(
        gh<_i1000.AssetJsonLoader>(),
        gh<_i1024.NetworkSimulator>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.lazySingleton<_i285.SavedEventRepository>(
      () => _i947.SavedEventRepositoryImpl(
        gh<_i794.SavedEventsDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.factory<_i351.SetEventSavedUseCase>(
      () => _i351.SetEventSavedUseCase(gh<_i285.SavedEventRepository>()),
    );
    gh.lazySingleton<_i805.EventClock>(
      () => _i805.EventClock(gh<_i454.Clock>(), gh<_i805.DeviceTimeZone>()),
    );
    gh.lazySingleton<_i233.SettingsRepository>(
      () => _i4.SettingsRepositoryImpl(gh<_i327.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i182.DemoRepository>(
      () => _i936.DemoRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i542.UserDataDao>(),
      ),
    );
    gh.factory<_i860.OpenLinkUseCase>(
      () => _i860.OpenLinkUseCase(gh<_i216.LinkOpener>()),
    );
    gh.lazySingleton<_i521.CatalogRepository>(
      () => _i507.CatalogRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i601.CatalogDao>(),
        gh<_i386.EventsDao>(),
      ),
    );
    gh.factory<_i1009.StartWithDemoUseCase>(
      () => _i1009.StartWithDemoUseCase(
        gh<_i182.DemoRepository>(),
        gh<_i233.SettingsRepository>(),
      ),
    );
    gh.factory<_i27.WatchSettingsUseCase>(
      () => _i27.WatchSettingsUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i1009.StartFreshUseCase>(
      () => _i1009.StartFreshUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i997.RefreshCatalogUseCase>(
      () => _i997.RefreshCatalogUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i997.ListCitiesUseCase>(
      () => _i997.ListCitiesUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i351.WatchEventCardsUseCase>(
      () => _i351.WatchEventCardsUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i351.WatchEventDetailsUseCase>(
      () => _i351.WatchEventDetailsUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i664.DiscoverCubit>(
      () => _i664.DiscoverCubit(
        gh<_i351.WatchEventCardsUseCase>(),
        gh<_i27.WatchSettingsUseCase>(),
        gh<_i997.RefreshCatalogUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i321.WelcomeCubit>(
      () => _i321.WelcomeCubit(
        gh<_i997.RefreshCatalogUseCase>(),
        gh<_i997.ListCitiesUseCase>(),
        gh<_i1009.StartWithDemoUseCase>(),
        gh<_i1009.StartFreshUseCase>(),
      ),
    );
    gh.factory<_i186.EventDetailCubit>(
      () => _i186.EventDetailCubit(
        gh<_i351.WatchEventDetailsUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i860.OpenLinkUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i64.AppModule {}
