import 'package:bloc_test/bloc_test.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
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

  setUpAll(() {
    registerFallbackValue(AppThemeMode.system);
    registerFallbackValue(ReminderLead.oneHour);
  });

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
    when(() => tools.setNotificationsEnabled(enabled: any(named: 'enabled')))
        .thenAnswer((_) async {});
    when(() => tools.openNotificationSettings()).thenAnswer((_) async {});
    when(() => tools.runBackgroundSync()).thenAnswer((_) async {});
    when(() => settings.setReminderLead(any())).thenAnswer((_) async {});
    when(
      () => settings.setSummary(
        enabled: any(named: 'enabled'),
        time: any(named: 'time'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester, {
    SettingsState state = base,
    SettingsToolsState toolState = toolsState,
  }) {
    when(() => settings.state).thenReturn(state);
    when(() => tools.state).thenReturn(toolState);
    tester.view
      ..physicalSize = const Size(1170, 5400)
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
      'Notifications',
      'Your city',
      'Data',
      'Developer',
      'About',
    ]) {
      expect(
        find.descendant(
          of: find.byType(SectionHeader),
          matching: find.text(title),
        ),
        findsOneWidget,
        reason: title,
      );
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

  group('notifications', () {
    final on = base.copyWith(
      settings: base.settings.copyWith(notificationsEnabled: true),
    );

    testWidgets('off: the switch alone; turning it on goes through the '
        'tools (the permission)', (tester) async {
      await pump(tester);

      expect(find.text('Reminder lead time'), findsNothing);
      expect(find.text('Daily summary'), findsNothing);
      await tester.tap(find.text('Notifications').last);

      verify(() => tools.setNotificationsEnabled(enabled: true)).called(1);
    });

    testWidgets('denied: a card that opens the system settings', (
      tester,
    ) async {
      await pump(
        tester,
        toolState: toolsState.copyWith(notificationsDenied: true),
      );

      expect(
        find.textContaining('Notifications are off for Evently'),
        findsOneWidget,
      );
      await tester.tap(find.text('Open settings'));

      verify(() => tools.openNotificationSettings()).called(1);
    });

    testWidgets('asking: the switch waits', (tester) async {
      await pump(
        tester,
        toolState: toolsState.copyWith(running: SettingsTask.notifications),
      );

      await tester.tap(find.text('Notifications').last);

      verifyNever(
        () => tools.setNotificationsEnabled(enabled: any(named: 'enabled')),
      );
    });

    testWidgets('on: the lead time, a choice of four', (tester) async {
      await pump(tester, state: on);

      expect(find.text('1 hour before an event'), findsOneWidget);
      await tester.tap(find.text('Reminder lead time'));
      await tester.pumpAndSettle();
      for (final lead in ReminderLead.values) {
        expect(find.text(lead.label), findsOneWidget);
      }
      await tester.tap(find.text('3 hours'));
      await tester.pumpAndSettle();

      verify(() => settings.setReminderLead(ReminderLead.threeHours)).called(1);
    });

    testWidgets('on: the daily summary, its switch and its time', (
      tester,
    ) async {
      await pump(tester, state: on);

      // The device's clock style: 12-hour in tests.
      expect(
        find.textContaining(
          RegExp(r"^At 8:00\sAM, on days with events you're going to$"),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Daily summary'));
      verify(() => settings.setSummary(enabled: false)).called(1);

      await tester.tap(find.text('Summary time'));
      await tester.pumpAndSettle();
      // Material's clock dialog off iOS; OK keeps 08:00.
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      verify(() => settings.setSummary(time: TimeOfDayValue(8, 0))).called(1);
    });

    testWidgets('on iOS, the time is a wheel in a sheet', (tester) async {
      await pump(tester, state: on);

      await tester.tap(find.text('Summary time'));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoDatePicker), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      verify(() => settings.setSummary(time: TimeOfDayValue(8, 0))).called(1);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('summary off: no time to set', (tester) async {
      await pump(
        tester,
        state: on.copyWith(
          settings: on.settings.copyWith(summaryEnabled: false),
        ),
      );

      expect(find.text('Summary time'), findsNothing);
    });
  });

  group('developer: the background sync and the plan', () {
    testWidgets('run background sync now', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Run background sync now'));

      verify(() => tools.runBackgroundSync()).called(1);
    });

    testWidgets('show planned notifications: a sheet with the plan', (
      tester,
    ) async {
      when(() => tools.previewPlan()).thenAnswer(
        (_) async => NotificationPlanPreview(
          plan: [
            PlannedNotification(
              id: 1,
              kind: NotificationKind.reminder,
              at: DateTime.utc(2026, 10, 21, 17, 30),
              title: 'Flutter London',
              body: 'Starts in 1 hour, at 18:30 · Hall',
              target: const NotificationTarget.event('ev_1'),
            ),
          ],
          pending: 1,
          enabled: true,
        ),
      );
      await pump(tester);

      await tester.tap(find.text('Show planned notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Planned notifications'), findsOneWidget);
      expect(
        find.text('1 planned for the next 7 days; 1 scheduled on this device.'),
        findsOneWidget,
      );
      expect(find.text('Flutter London'), findsOneWidget);
      expect(find.textContaining('Reminder\nStarts in 1 hour'), findsOneWidget);
    });

    testWidgets('off and empty: the sheet says so', (tester) async {
      when(() => tools.previewPlan()).thenAnswer(
        (_) async =>
            const NotificationPlanPreview(plan: [], pending: 0, enabled: false),
      );
      await pump(tester);

      await tester.tap(find.text('Show planned notifications'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Notifications are off, so nothing is scheduled'),
        findsOneWidget,
      );
      expect(find.textContaining('Nothing to plan'), findsOneWidget);
    });
  });
}
