import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_state.dart';
import 'package:evently/features/settings/cubit/settings_tools_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_state.dart';
import 'package:evently/features/settings/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class _MockToolsCubit extends MockCubit<SettingsToolsState>
    implements SettingsToolsCubit {}

void main() {
  late _MockSettingsCubit settings;
  late _MockToolsCubit tools;

  const base = SettingsState(
    settings: AppSettings(onboarded: true, preferredCity: 'London'),
    deviceColors: DeviceColors(),
  );
  const toolsState = SettingsToolsState(cities: ['Berlin', 'London']);

  setUpAll(() => registerFallbackValue(AppThemeMode.system));

  setUp(() {
    settings = _MockSettingsCubit();
    tools = _MockToolsCubit();
    when(() => settings.setThemeMode(any())).thenAnswer((_) async {});
    when(() => settings.setDynamicColor(enabled: any(named: 'enabled')))
        .thenAnswer((_) async {});
    when(() => settings.setPreferredCity(any())).thenAnswer((_) async {});
    when(() => tools.clearCache()).thenAnswer((_) async {});
    when(() => tools.resetDemoData()).thenAnswer((_) async {});
    when(() => tools.publishCatalogUpdate()).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester, {
    SettingsState state = base,
    SettingsToolsState toolState = toolsState,
  }) {
    when(() => settings.state).thenReturn(state);
    when(() => tools.state).thenReturn(toolState);
    tester.view
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: settings),
          BlocProvider<SettingsToolsCubit>.value(value: tools),
        ],
        child: const SettingsView(version: '1.0.0 (1)'),
      ),
    );
  }

  testWidgets('every section, and the version', (tester) async {
    await pump(tester);

    for (final title in [
      'Appearance',
      'Your city',
      'Data',
      'Developer',
      'About',
    ]) {
      expect(find.text(title), findsOneWidget, reason: title);
    }
    expect(find.text('Version 1.0.0 (1)'), findsOneWidget);
    expect(find.text('London: Discover leads with it'), findsOneWidget);
  });

  testWidgets('appearance: segments, which set the theme', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Dark'));

    verify(() => settings.setThemeMode(AppThemeMode.dark)).called(1);
  });

  testWidgets('at large text: a radio list instead of segments', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await pump(tester);

    expect(find.byType(SegmentedButton<AppThemeMode>), findsNothing);
    expect(find.byType(RadioListTile<AppThemeMode>), findsNWidgets(3));
  });

  testWidgets('dynamic color only where the device has wallpaper colors', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Dynamic color'), findsNothing);
  });

  testWidgets('with wallpaper colors: the switch, which sets it', (
    tester,
  ) async {
    await pump(
      tester,
      state: base.copyWith(
        deviceColors: const DeviceColors(wallpaperColor: 0xFF00897B),
      ),
    );

    await tester.tap(find.text('Dynamic color'));

    verify(() => settings.setDynamicColor(enabled: false)).called(1);
  });

  testWidgets('the city: a choice of Anywhere and the cities', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Preferred city'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anywhere'));
    await tester.pumpAndSettle();

    verify(() => settings.setPreferredCity(null)).called(1);
  });

  testWidgets('clear cache asks first', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Clear cache'));
    await tester.pumpAndSettle();
    expect(find.text('Clear the cache?'), findsOneWidget);
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    verify(() => tools.clearCache()).called(1);
  });

  testWidgets('clear cache: Cancel clears nothing', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Clear cache'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    verifyNever(() => tools.clearCache());
  });

  testWidgets('reset demo data asks first; Cancel does nothing', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Reset demo data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    verifyNever(() => tools.resetDemoData());
  });

  testWidgets('a task running: its tile spins, the others wait', (
    tester,
  ) async {
    await pump(
      tester,
      toolState: toolsState.copyWith(running: SettingsTask.resetDemo),
    );

    final clear = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Clear cache'),
    );
    expect(clear.enabled, isFalse);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('developer: the network switch and publishing', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Simulate network failure'));
    await tester.tap(find.text('Publish a catalog update'));

    verify(() => tools.setFailingRequests(fail: true)).called(1);
    verify(() => tools.publishCatalogUpdate()).called(1);
  });

  testWidgets("a tool's result shows as a SnackBar", (tester) async {
    whenListen(
      tools,
      Stream.value(toolsState.copyWith(message: 'Cleared 3', messageSerial: 1)),
      initialState: toolsState,
    );
    await pump(tester);
    await tester.pump();

    expect(find.widgetWithText(SnackBar, 'Cleared 3'), findsOneWidget);
  });
}
