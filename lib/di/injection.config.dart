// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:clock/clock.dart' as _i454;
import 'package:evently/core/database/app_database.dart' as _i496;
import 'package:evently/core/database/daos/catalog_dao.dart' as _i601;
import 'package:evently/core/database/daos/user_data_dao.dart' as _i542;
import 'package:evently/core/network/asset_json_loader.dart' as _i1000;
import 'package:evently/core/network/evently_api.dart' as _i844;
import 'package:evently/core/network/fake_evently_api.dart' as _i796;
import 'package:evently/core/network/network_simulator.dart' as _i1024;
import 'package:evently/core/storage/settings_local_data_source.dart' as _i327;
import 'package:evently/data/repository/catalog_repository_impl.dart' as _i507;
import 'package:evently/data/repository/demo_repository_impl.dart' as _i936;
import 'package:evently/data/repository/settings_repository_impl.dart' as _i4;
import 'package:evently/di/app_module.dart' as _i64;
import 'package:evently/domain/repository/catalog_repository.dart' as _i521;
import 'package:evently/domain/repository/demo_repository.dart' as _i182;
import 'package:evently/domain/repository/settings_repository.dart' as _i233;
import 'package:evently/domain/usecase/catalog_use_cases.dart' as _i997;
import 'package:evently/domain/usecase/start_use_cases.dart' as _i1009;
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
    gh.lazySingleton<_i601.CatalogDao>(
      () => appModule.catalogDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i542.UserDataDao>(
      () => appModule.userDataDao(gh<_i496.AppDatabase>()),
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
    gh.lazySingleton<_i521.CatalogRepository>(
      () => _i507.CatalogRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i601.CatalogDao>(),
      ),
    );
    gh.lazySingleton<_i233.SettingsRepository>(
      () => _i4.SettingsRepositoryImpl(gh<_i327.SettingsLocalDataSource>()),
    );
    gh.factory<_i997.RefreshCatalogUseCase>(
      () => _i997.RefreshCatalogUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i997.ListCitiesUseCase>(
      () => _i997.ListCitiesUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.lazySingleton<_i182.DemoRepository>(
      () => _i936.DemoRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i542.UserDataDao>(),
      ),
    );
    gh.factory<_i1009.StartWithDemoUseCase>(
      () => _i1009.StartWithDemoUseCase(
        gh<_i182.DemoRepository>(),
        gh<_i233.SettingsRepository>(),
      ),
    );
    gh.factory<_i1009.StartFreshUseCase>(
      () => _i1009.StartFreshUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i321.WelcomeCubit>(
      () => _i321.WelcomeCubit(
        gh<_i997.RefreshCatalogUseCase>(),
        gh<_i997.ListCitiesUseCase>(),
        gh<_i1009.StartWithDemoUseCase>(),
        gh<_i1009.StartFreshUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i64.AppModule {}
