import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
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
}
