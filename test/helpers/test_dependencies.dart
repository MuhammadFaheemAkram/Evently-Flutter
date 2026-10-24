import 'package:clock/clock.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/service/background_work.dart';
import 'package:evently/domain/service/link_opener.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:timezone/timezone.dart' as tz;

import 'database.dart';
import 'fakes/fake_notification_scheduler.dart';
import 'fakes/recording_link_opener.dart';

/// Builds the app's real composition root for app-level tests, with these
/// swaps:
/// - preferences live in an in-memory store, pre-filled with [preferences]
///   (raw keys, as `SettingsLocalDataSource` names them);
/// - the database lives in memory (and is closed by `getIt.reset()`);
/// - the simulated network has no latency;
/// - the clock is fixed at [demoNow], so every rendered event time is known;
/// - the device is in London ([deviceZone]), with no wallpaper colors (as
///   on iOS), and the app is version 1.0.0 (1);
/// - links go to a [RecordingLinkOpener] (`getIt<LinkOpener>()`);
/// - notifications go to a [FakeNotificationScheduler] ([notifications], or
///   a new one: not permitted until asked, granted when asked), reachable as
///   `getIt<NotificationScheduler>() as FakeNotificationScheduler`;
/// - background work registers nothing.
///
/// Everything else is the real code, so these tests also prove the DI graph
/// resolves. Call `getIt.reset()` in `tearDown`.
Future<void> configureTestDependencies({
  Map<String, Object> preferences = const {},
  FakeNotificationScheduler? notifications,
}) async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData(Map.of(preferences));
  // Answered at once: an unanswered platform call before the first pump
  // would wait on fake time forever (§11.44).
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    ..setMockMethodCallHandler(
      const MethodChannel('flutter_timezone'),
      (_) async => deviceZone,
    )
    // No wallpaper palette (as on iOS).
    ..setMockMethodCallHandler(DynamicColorPlugin.channel, (_) async => null);
  PackageInfo.setMockInitialValues(
    appName: 'Evently',
    packageName: 'co.bitfuse.flutter.evently',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );
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
    ..registerLazySingleton<Clock>(() => Clock.fixed(demoNow))
    ..unregister<LinkOpener>()
    ..registerSingleton<LinkOpener>(RecordingLinkOpener());
  final scheduler = notifications ?? FakeNotificationScheduler();
  getIt
    ..unregister<NotificationScheduler>()
    ..registerSingleton<NotificationScheduler>(scheduler)
    ..unregister<NotificationInteractions>()
    ..registerSingleton<NotificationInteractions>(scheduler)
    ..unregister<BackgroundWork>()
    ..registerSingleton<BackgroundWork>(const _NoBackgroundWork());
}

class _NoBackgroundWork implements BackgroundWork {
  const _NoBackgroundWork();

  @override
  Future<void> registerSync() async {}
}

/// "Now" in every test: Wednesday 21 October 2026, 14:00 UTC. That is 15:00
/// in London and Berlin (summer time until Sunday the 25th), 10:00 in New
/// York (until 1 November) and 19:00 in Lahore. The seed's events land
/// around both clock changes.
final demoNow = DateTime.utc(2026, 10, 21, 14);

/// The device's zone in every test.
const deviceZone = 'Europe/London';

/// [deviceZone], as `EventClock` is given it.
DeviceTimeZone get londonZone => DeviceTimeZone(tz.getLocation(deviceZone));

/// The saved preferences of an app that is past Welcome.
const onboardedPreferences = {'settings.onboarded': true};
