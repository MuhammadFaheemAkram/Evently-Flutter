import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  setUp(() async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
  });

  SettingsCubit settingsCubit({int? wallpaper}) {
    final cubit = SettingsCubit(
      stack.settings,
      stack.updateThemeMode,
      stack.updateDynamicColor,
      stack.updatePreferredCity,
      stack.updateReminderLead,
      stack.updateSummary,
      DeviceColors(wallpaperColor: wallpaper),
    )..load();
    addTearDown(cubit.close);
    return cubit;
  }

  SettingsToolsCubit toolsCubit() {
    final cubit = SettingsToolsCubit(
      stack.listCities,
      stack.clearCache,
      stack.resetDemoData,
      stack.developer,
      stack.setNotificationsEnabled,
      stack.openNotificationSettings,
      stack.runBackgroundSync,
      stack.previewPlan,
    );
    addTearDown(cubit.close);
    return cubit;
  }

  group('the app-wide settings', () {
    test('theme mode, dynamic color and city follow what is saved', () async {
      final cubit = settingsCubit();

      await cubit.setThemeMode(AppThemeMode.dark);
      await cubit.setDynamicColor(enabled: false);
      await cubit.setPreferredCity('Berlin');
      final state = await waitFor(
        cubit,
        (s) => s.settings.preferredCity != null,
      );

      expect(state.settings.themeMode, AppThemeMode.dark);
      expect(state.settings.dynamicColor, isFalse);
      expect(state.settings.preferredCity, 'Berlin');
    });

    test(
      "the wallpaper's color is the seed only while dynamic color is on",
      () async {
        final cubit = settingsCubit(wallpaper: 0xFF00897B);

        expect(cubit.state.dynamicSeed, 0xFF00897B);
        await cubit.setDynamicColor(enabled: false);
        await waitFor(cubit, (s) => !s.settings.dynamicColor);
        expect(cubit.state.dynamicSeed, isNull);
      },
    );

    test('a device without wallpaper colors: no seed', () {
      expect(settingsCubit().state.dynamicSeed, isNull);
      expect(settingsCubit().state.deviceColors.supportsDynamicColor, false);
    });
  });

  group('the tools', () {
    test("the cities to choose from, and the network switch's state", () async {
      final cubit = toolsCubit();

      await cubit.load();

      expect(cubit.state.cities, ['Berlin', 'Lahore', 'London', 'New York']);
      expect(cubit.state.failingRequests, isFalse);
    });

    test('clear cache says how many went', () async {
      final cubit = toolsCubit();

      await cubit.clearCache();

      expect(cubit.state.message, startsWith('Cleared '));
      expect(cubit.state.running, isNull);
    });

    test('reset demo data, and offline its error', () async {
      final cubit = toolsCubit();

      await cubit.resetDemoData();
      expect(cubit.state.message, 'The demo data is back.');

      cubit.setFailingRequests(fail: true);
      expect(stack.network.failRequests, isTrue);
      await cubit.resetDemoData();
      expect(cubit.state.message, contains("Couldn't reach the server"));
    });

    test('publish an update', () async {
      final cubit = toolsCubit();

      await cubit.publishCatalogUpdate();

      expect(
        cubit.state.message,
        'Published: 1 moved, 1 cancelled, 1 edited, 2 new. Pull to refresh '
        'to see it.',
      );
    });

    test('one task at a time', () async {
      final cubit = toolsCubit();

      final first = cubit.clearCache();
      expect(cubit.state.running, SettingsTask.clearCache);
      await cubit.resetDemoData();
      await first;

      expect(cubit.state.messageSerial, 1);
    });
  });

  group('notifications', () {
    test('the lead time and the summary, saved and followed', () async {
      final cubit = settingsCubit();

      await cubit.setReminderLead(ReminderLead.threeHours);
      await cubit.setSummary(enabled: false);
      await cubit.setSummary(time: TimeOfDayValue(7, 30));
      final state = await waitFor(
        cubit,
        (s) => s.settings.summaryTime == TimeOfDayValue(7, 30),
      );

      expect(state.settings.reminderLead, ReminderLead.threeHours);
      // The time alone leaves the switch as it was.
      expect(state.settings.summaryEnabled, isFalse);
    });

    test('turned on: the system asks; allowed, on', () async {
      final cubit = toolsCubit();

      await cubit.setNotificationsEnabled(enabled: true);

      expect(stack.settings.current.notificationsEnabled, isTrue);
      expect(cubit.state.notificationsDenied, isFalse);
      expect(cubit.state.running, isNull);
    });

    test('denied: off, with the card, which opens the system '
        'settings', () async {
      stack.notifications.grantsWhenAsked = false;
      final cubit = toolsCubit();

      await cubit.setNotificationsEnabled(enabled: true);
      expect(stack.settings.current.notificationsEnabled, isFalse);
      expect(cubit.state.notificationsDenied, isTrue);

      await cubit.openNotificationSettings();
      expect(stack.notifications.calls, ['request', 'openSettings']);
    });

    test('run background sync now says what it did', () async {
      stack.notifications.permitted = true;
      await stack.settings.update(
        (s) => s.copyWith(notificationsEnabled: true),
      );
      await stack.server.publishUpdate();
      final cubit = toolsCubit();

      await cubit.runBackgroundSync();

      expect(
        cubit.state.message,
        'Synced. 2 change alerts. 1 notification planned.',
      );
    });

    test('offline, and notifications off: says both', () async {
      stack.network.failRequests = true;
      final cubit = toolsCubit();

      await cubit.runBackgroundSync();

      expect(
        cubit.state.message,
        "Sync failed: Couldn't reach the server. Check your connection and "
        'try again. Notifications are off.',
      );
    });

    test('the plan, for the sheet', () async {
      final preview = await toolsCubit().previewPlan();

      expect(preview.enabled, isFalse);
      expect(preview.plan, isNotEmpty);
    });
  });
}
