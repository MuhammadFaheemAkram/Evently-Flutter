import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

// Organizers, the profile and Settings on the real DI graph, with the demo
// loaded (as of Wednesday 21 October, 15:00 in London).
void main() {
  tearDown(getIt.reset);

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tapAndSettle(destination('Profile'));
    await tester.tapAndSettle(find.byTooltip('Settings'));
  }

  Future<void> tapInSettings(WidgetTester tester, String label) async {
    await tester.scrollUntilVisible(find.text(label), 300);
    await tester.tapAndSettle(find.text(label));
  }

  Brightness brightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(Scaffold).last)).brightness;

  testWidgets('Dark in Settings applies to the whole app, and stays', (
    tester,
  ) async {
    await pumpEvently(tester, withDemo: true);
    expect(brightness(tester), Brightness.light);
    await openSettings(tester);

    await tester.tapAndSettle(find.text('Dark'));
    await tester.settleRealAsync();

    expect(brightness(tester), Brightness.dark);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tapAndSettle(destination('Discover'));
    expect(brightness(tester), Brightness.dark);
  });

  testWidgets("dynamic color: the wallpaper's color becomes the seed", (
    tester,
  ) async {
    const wallpaper = Color(0xFF00897B);
    await pumpEvently(
      tester,
      beforeLaunch: () => getIt
        ..unregister<DeviceColors>()
        ..registerSingleton(DeviceColors(wallpaperColor: wallpaper.toARGB32())),
    );

    final primary = Theme.of(tester.element(find.byType(Scaffold).last))
        .colorScheme
        .primary;
    expect(
      primary,
      AppTheme.fromSeed(wallpaper, Brightness.light).colorScheme.primary,
    );
    expect(primary, isNot(AppTheme.light().colorScheme.primary));
  });

  testWidgets('a published catalog update: after a refresh, the tickets say '
      'moved and cancelled', (tester) async {
    await pumpEvently(tester, withDemo: true);
    await openSettings(tester);

    await tapInSettings(tester, 'Publish a catalog update');
    await tester.pumpUntilFound(find.textContaining('Published:'));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tapAndSettle(destination('Discover'));
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 400),
      1000,
    );
    await tester.settleRealAsync();
    await tester.settleRealAsync();
    await tester.tapAndSettle(destination('Tickets'));

    await tester.pumpUntilFound(find.text('Moved'));
    expect(find.text('Cancelled by the organizer'), findsOneWidget);
  });

  testWidgets('clear cache keeps what you saved', (tester) async {
    await pumpEvently(tester, withDemo: true);
    await openSettings(tester);

    await tapInSettings(tester, 'Clear cache');
    await tester.tapAndSettle(find.text('Clear'));
    await tester.pumpUntilFound(find.textContaining('Cleared '));
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tapAndSettle(destination('Saved'));

    await tester.pumpUntilFound(find.text('Late Jazz at the Vaults'));
  });

  testWidgets('follow an organizer: on Following, and counted on Profile', (
    tester,
  ) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/organizers/org_soundwaves',
    );
    await tester.pumpUntilFound(find.text('Follow'));

    await tester.tap(find.text('Follow'));
    await tester.pumpUntilFound(find.text('Following'));
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    await tester.tapAndSettle(destination('Profile'));

    await tester.pumpUntilFound(find.text('3 organizers followed'));
    await tester.tapAndSettle(find.text('3 organizers followed'));
    await tester.pumpUntilFound(find.text('Soundwaves Live'));
  });

  testWidgets('edit the profile: saved, and Profile shows it', (tester) async {
    await pumpEvently(tester, withDemo: true);
    await tester.tapAndSettle(destination('Profile'));
    await tester.pumpUntilFound(find.text('Sara Ahmed'));

    await tester.tapAndSettle(find.text('Edit profile'));
    await tester.pumpUntilFound(find.widgetWithText(TextField, 'Sara Ahmed'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Sara Ahmed'),
      'Sara A.',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpUntilFound(appBarTitled('Profile'));

    await tester.pumpUntilFound(find.text('Sara A.'));
  });
}
