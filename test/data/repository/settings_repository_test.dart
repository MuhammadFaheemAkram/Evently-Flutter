import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:evently/data/repository/settings_repository_impl.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  /// The device's store, as one isolate sees it: its own cache over the
  /// shared store.
  Future<SharedPreferencesWithCache> preferences() =>
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          allowList: SettingsLocalDataSource.allowList,
        ),
      );

  Future<SettingsRepositoryImpl> repository() async {
    final settings = SettingsRepositoryImpl(
      SettingsLocalDataSource(await preferences()),
    );
    addTearDown(settings.dispose);
    return settings;
  }

  void deviceHolds(Map<String, Object> values) =>
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData(values);

  setUp(() => deviceHolds({}));

  test('a new device: not onboarded, anywhere', () async {
    expect((await repository()).current, const AppSettings());
  });

  test('reads what was saved', () async {
    deviceHolds({
      'settings.onboarded': true,
      'settings.preferredCity': 'Lahore',
    });

    expect(
      (await repository()).current,
      const AppSettings(onboarded: true, preferredCity: 'Lahore'),
    );
  });

  test('a change is current at once, and saved for the next launch', () async {
    final settings = await repository();

    await settings.update(
      (s) => s.copyWith(onboarded: true, preferredCity: 'Berlin'),
    );

    expect(settings.current.preferredCity, 'Berlin');
    expect(
      (await repository()).current,
      const AppSettings(onboarded: true, preferredCity: 'Berlin'),
    );
  });

  test('"Anywhere" removes the saved city', () async {
    deviceHolds({'settings.preferredCity': 'Lahore'});
    final settings = await repository();

    await settings.update((s) => s.copyWith(preferredCity: null));

    expect((await preferences()).containsKey('settings.preferredCity'), false);
    expect((await repository()).current.preferredCity, isNull);
  });

  test('only what changed is written: a stale copy never undoes another '
      "isolate's save", () async {
    final app = await repository();
    // Meanwhile, the background isolate (Phase 7) saves the city.
    await (await preferences()).setString('settings.preferredCity', 'London');

    await app.update((s) => s.copyWith(onboarded: true));

    expect(
      (await repository()).current,
      const AppSettings(onboarded: true, preferredCity: 'London'),
    );
  });

  test('watch: the current settings on listen, then each change', () async {
    final settings = await repository();
    final seen = <AppSettings>[];
    final subscription = settings.watch().listen(seen.add);
    addTearDown(subscription.cancel);

    await settings.update((s) => s.copyWith(preferredCity: 'Berlin'));
    await settings.update((s) => s.copyWith(onboarded: true));
    await pumpEventQueue();

    expect(seen, const [
      AppSettings(),
      AppSettings(preferredCity: 'Berlin'),
      AppSettings(onboarded: true, preferredCity: 'Berlin'),
    ]);
  });

  test('a change that changes nothing is not published', () async {
    final settings = await repository();
    final seen = <AppSettings>[];
    final subscription = settings.watch().listen(seen.add);
    addTearDown(subscription.cancel);

    await settings.update((s) => s);
    await pumpEventQueue();

    expect(seen, const [AppSettings()]);
  });
}
