import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:evently/data/repository/settings_repository_impl.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

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
    // Meanwhile, the background isolate saves the city.
    await (await preferences()).setString('settings.preferredCity', 'London');

    await app.update((s) => s.copyWith(onboarded: true));

    expect(
      (await repository()).current,
      const AppSettings(onboarded: true, preferredCity: 'London'),
    );
  });

  test('appearance: saved and read back', () async {
    final settings = await repository();

    await settings.update(
      (s) => s.copyWith(themeMode: AppThemeMode.dark, dynamicColor: false),
    );

    expect(
      (await repository()).current,
      const AppSettings(themeMode: AppThemeMode.dark, dynamicColor: false),
    );
  });

  test(
    'a theme mode this version does not know falls back to System',
    () async {
      deviceHolds({'settings.themeMode': 'sepia'});

      expect((await repository()).current.themeMode, AppThemeMode.system);
    },
  );

  test('dynamic color is on by default', () async {
    expect((await repository()).current.dynamicColor, isTrue);
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

  // Found on the Android emulator: the system's permission dialog pauses
  // the app, and closing it resumes the app, which reloads the settings
  // while the switch's own write is still on its way to the disk. Android's
  // store (DataStore) doesn't keep the two in order: the read can overtake
  // the write.
  group('a reload racing a write', () {
    test('waits for its own writes: the read never overtakes them', () async {
      SharedPreferencesAsyncPlatform.instance = _SlowWrites();
      final app = await repository();

      final writing = app.update((s) => s.copyWith(notificationsEnabled: true));
      await app.reload();
      await writing;

      expect(app.current.notificationsEnabled, isTrue);
    });

    test(
      'a change made while the disk is read wins over what was read',
      () async {
        SharedPreferencesAsyncPlatform.instance = _SlowReads({
          'settings.notificationsEnabled': false,
        });
        final app = await repository();

        final reading = app.reload();
        // The read is under way (it answers after 20 ms) when the change
        // is made.
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await app.update((s) => s.copyWith(notificationsEnabled: true));
        await reading;

        expect(app.current.notificationsEnabled, isTrue);
        expect((await repository()).current.notificationsEnabled, isTrue);
      },
    );
  });

  group('notifications', () {
    test('off by default; a 1-hour lead, the summary on at 08:00', () async {
      final settings = (await repository()).current;

      expect(settings.notificationsEnabled, isFalse);
      expect(settings.reminderLead, ReminderLead.oneHour);
      expect(settings.summaryEnabled, isTrue);
      expect(settings.summaryTime, TimeOfDayValue(8, 0));
    });

    test('saved under their keys and read back', () async {
      final settings = await repository();

      await settings.update(
        (s) => s.copyWith(
          notificationsEnabled: true,
          reminderLead: ReminderLead.oneDay,
          summaryEnabled: false,
          summaryTime: TimeOfDayValue(7, 30),
        ),
      );

      final stored = await preferences();
      expect(stored.getBool('settings.notificationsEnabled'), isTrue);
      expect(stored.getString('settings.reminderLead'), 'oneDay');
      expect(stored.getBool('settings.summaryEnabled'), isFalse);
      expect(stored.getString('settings.summaryTime'), '07:30');
      expect((await repository()).current, settings.current);
    });

    test(
      'a value this version can\'t read falls back to the default',
      () async {
        deviceHolds({
          'settings.reminderLead': 'oneWeek',
          'settings.summaryTime': '7:30',
        });

        final settings = (await repository()).current;

        expect(settings.reminderLead, ReminderLead.oneHour);
        expect(settings.summaryTime, TimeOfDayValue(8, 0));
      },
    );

    test('reload: what another isolate saved is published', () async {
      deviceHolds({'settings.notificationsEnabled': true});
      final app = await repository();
      final background = await repository();
      final seen = <AppSettings>[];
      final subscription = app.watch().listen(seen.add);
      addTearDown(subscription.cancel);

      await background.update((s) => s.copyWith(notificationsEnabled: false));
      expect(app.current.notificationsEnabled, isTrue);
      await app.reload();
      await pumpEventQueue();

      expect(app.current.notificationsEnabled, isFalse);
      expect(seen.last.notificationsEnabled, isFalse);

      // Nothing new: nothing published.
      final published = seen.length;
      await app.reload();
      await pumpEventQueue();
      expect(seen, hasLength(published));
    });
  });
}

/// A device store whose writes land a moment after they're made, while
/// reads return what has landed: a read can overtake a write.
final class _SlowWrites extends InMemorySharedPreferencesAsync {
  _SlowWrites() : super.empty();

  @override
  Future<bool> setBool(
    String key,
    bool value,
    SharedPreferencesOptions options,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return super.setBool(key, value, options);
  }
}

/// A device store whose reads take a snapshot when asked and answer a
/// moment later.
final class _SlowReads extends InMemorySharedPreferencesAsync {
  _SlowReads(super.data) : super.withData();

  @override
  Future<Map<String, Object>> getPreferences(
    GetPreferencesParameters parameters,
    SharedPreferencesOptions options,
  ) async {
    final snapshot = await super.getPreferences(parameters, options);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return snapshot;
  }
}
