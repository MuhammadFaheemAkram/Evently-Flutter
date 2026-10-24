import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:evently/domain/repository/demo_repository.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/domain/service/developer_tools.dart';
import 'package:injectable/injectable.dart';

/// The settings now, then every change.
@injectable
class WatchSettingsUseCase {
  const WatchSettingsUseCase(this._settings);

  final SettingsRepository _settings;

  Stream<AppSettings> call() => _settings.watch();
}

@injectable
class UpdateThemeModeUseCase {
  const UpdateThemeModeUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call(AppThemeMode mode) =>
      _settings.update((s) => s.copyWith(themeMode: mode));
}

@injectable
class UpdateDynamicColorUseCase {
  const UpdateDynamicColorUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call({required bool enabled}) =>
      _settings.update((s) => s.copyWith(dynamicColor: enabled));
}

/// The city Discover leads with; `null` is "Anywhere".
@injectable
class UpdatePreferredCityUseCase {
  const UpdatePreferredCityUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call(String? city) =>
      _settings.update((s) => s.copyWith(preferredCity: city));
}

/// Settings → Clear cache: frees what the user owns nothing of.
@injectable
class ClearCacheUseCase {
  const ClearCacheUseCase(this._catalog);

  final CatalogRepository _catalog;

  Future<Result<int>> call() => _catalog.clearCache();
}

/// Settings → Reset demo data: the catalog fetched again (the demo points
/// at its events), then the demo user's data written over the user's, in
/// one transaction. Offline, nothing changes.
@injectable
class ResetDemoDataUseCase {
  const ResetDemoDataUseCase(this._catalog, this._demo);

  final CatalogRepository _catalog;
  final DemoRepository _demo;

  Future<Result<void>> call() async {
    final refreshed = await _catalog.refresh();
    if (refreshed case Err(:final exception)) return Err(exception);
    return _demo.loadDemoUser();
  }
}

/// The developer switches (see [DeveloperTools]).
@injectable
class DeveloperToolsUseCase {
  const DeveloperToolsUseCase(this._tools);

  final DeveloperTools _tools;

  bool get failingRequests => _tools.failingRequests;

  void setFailingRequests({required bool fail}) =>
      _tools.failingRequests = fail;

  Future<String> publishCatalogUpdate() => _tools.publishCatalogUpdate();
}
