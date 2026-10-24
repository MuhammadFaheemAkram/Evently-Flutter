import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

/// The settings now, then every change.
@injectable
class WatchSettingsUseCase {
  const WatchSettingsUseCase(this._settings);

  final SettingsRepository _settings;

  Stream<AppSettings> call() => _settings.watch();
}
