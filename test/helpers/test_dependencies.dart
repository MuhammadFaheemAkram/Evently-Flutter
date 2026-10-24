import 'package:clock/clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'database.dart';

/// Builds the app's real composition root for app-level tests, with these
/// swaps:
/// - preferences live in an in-memory store, pre-filled with [preferences]
///   (raw keys, as `SettingsLocalDataSource` names them);
/// - the database lives in memory (and is closed by `getIt.reset()`);
/// - the simulated network has no latency;
/// - the clock is fixed at [demoNow], so every rendered event time is known.
///
/// Everything else is the real code, so these tests also prove the DI graph
/// resolves. Call `getIt.reset()` in `tearDown`.
Future<void> configureTestDependencies({
  Map<String, Object> preferences = const {},
}) async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData(Map.of(preferences));
  await configureDependencies();
  getIt
    ..unregister<AppDatabase>()
    ..registerLazySingleton<AppDatabase>(
      newTestDatabase,
      dispose: (database) => database.close(),
    )
    ..unregister<NetworkSimulator>()
    ..registerLazySingleton<NetworkSimulator>(
      () => NetworkSimulator(latency: Duration.zero),
    )
    ..unregister<Clock>()
    ..registerLazySingleton<Clock>(() => Clock.fixed(demoNow));
}

/// "Now" in every test: Wednesday 21 October 2026, 14:00 UTC. That is 15:00
/// in London and Berlin (summer time until Sunday the 25th), 10:00 in New
/// York (until 1 November) and 19:00 in Lahore. The seed's events land
/// around both clock changes.
final demoNow = DateTime.utc(2026, 10, 21, 14);

/// The saved preferences of an app that is past Welcome.
const onboardedPreferences = {'settings.onboarded': true};
