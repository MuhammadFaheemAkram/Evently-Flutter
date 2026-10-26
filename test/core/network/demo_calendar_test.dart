import 'package:clock/clock.dart';
import 'package:evently/core/network/demo_calendar.dart';
import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  setUp(
    () => SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty(),
  );

  late SharedPreferencesWithCache preferences;

  /// One isolate's view of the device's preferences, at [now].
  Future<StoredDemoCalendar> calendar(DateTime now) async {
    preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsLocalDataSource.allowList,
      ),
    );
    return StoredDemoCalendar(
      SettingsLocalDataSource(preferences),
      Clock.fixed(now),
    );
  }

  final dayLater = demoNow.add(const Duration(days: 1));

  test('anchored at the first read, and kept: a day later it still counts '
      'from then', () async {
    expect((await calendar(demoNow)).anchor(), demoNow);
    await pumpEventQueue();

    expect((await calendar(dayLater)).anchor(), demoNow);
  });

  test('another isolate reads the same anchor from the device', () async {
    final app = await calendar(demoNow);
    app.anchor();
    await pumpEventQueue();

    final background = await calendar(dayLater);

    expect(background.anchor(), demoNow);
  });

  test('restart counts from now', () async {
    (await calendar(demoNow)).anchor();
    await pumpEventQueue();

    final later = await calendar(dayLater);
    await later.restart();

    expect(later.anchor(), dayLater);
    expect((await calendar(dayLater)).anchor(), dayLater);
  });

  test('read once: a moment with no stored anchor (a reload emptying the '
      'cache) never starts a new calendar', () async {
    await calendar(demoNow);
    var now = demoNow;
    final app = StoredDemoCalendar(
      SettingsLocalDataSource(preferences),
      Clock(() => now),
    );
    expect(app.anchor(), demoNow);
    await pumpEventQueue();

    await preferences.remove(SettingsLocalDataSource.demoAnchorKey);
    now = dayLater;

    expect(app.anchor(), demoNow);
  });
}
