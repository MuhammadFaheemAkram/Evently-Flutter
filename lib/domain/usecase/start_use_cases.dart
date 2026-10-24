import 'package:evently/core/common/result.dart';
import 'package:evently/domain/repository/demo_repository.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

/// Welcome → "Explore with demo data", once the catalog is cached: the demo
/// user is written first; only if that succeeds is the first launch over
/// (with [city] as the preferred city, `null` for "Anywhere"). The router's
/// gate then opens Discover; a failure leaves the user on Welcome with
/// nothing half-done.
@injectable
class StartWithDemoUseCase {
  const StartWithDemoUseCase(this._demo, this._settings);

  final DemoRepository _demo;
  final SettingsRepository _settings;

  Future<Result<void>> call({String? city}) async {
    final result = await _demo.loadDemoUser();
    if (result is Ok) {
      await _settings.update(
        (settings) => settings.copyWith(onboarded: true, preferredCity: city),
      );
    }
    return result;
  }
}

/// Welcome → "Start fresh", once the catalog is cached: no saved events, no
/// tickets, no profile; the first launch is over and Discover opens.
@injectable
class StartFreshUseCase {
  const StartFreshUseCase(this._settings);

  final SettingsRepository _settings;

  Future<void> call({String? city}) => _settings.update(
    (settings) => settings.copyWith(onboarded: true, preferredCity: city),
  );
}
