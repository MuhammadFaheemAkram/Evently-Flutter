import 'package:evently/app/evently_app.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:evently/domain/repository/demo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'pump_app.dart';
import 'test_dependencies.dart';

/// Starts the whole app on the real DI graph (see
/// [configureTestDependencies]): already past Welcome ([onboarded]) or on a
/// first launch, optionally on a deep link, as of [demoNow]. Pair it with
/// `tearDown(getIt.reset)`.
///
/// An app past Welcome has the catalog cached, as Welcome leaves it; with
/// [withDemo], the demo user too ("Explore with demo data").
///
/// [preferences] adds saved settings (raw keys). [beforeLaunch] runs once
/// the graph exists and before the first frame (to switch the network off,
/// say); it must not wait on anything (§11.44).
Future<void> pumpEvently(
  WidgetTester tester, {
  bool onboarded = true,
  bool withDemo = false,
  String? initialLocation,
  Map<String, Object> preferences = const {},
  void Function()? beforeLaunch,
}) async {
  await configureTestDependencies(
    preferences: {if (onboarded) ...onboardedPreferences, ...preferences},
  );
  if (onboarded) {
    // On the real event loop: before the first pump nothing advances the
    // widget test's fake time, so even the simulated network's zero-length
    // delay would never fire (§11.44).
    await tester.runAsync(() async {
      await getIt<CatalogRepository>().refresh();
      if (withDemo) await getIt<DemoRepository>().loadDemoUser();
    });
  }
  beforeLaunch?.call();
  tester.usePhoneSurface();
  await tester.pumpWidget(EventlyApp(initialLocation: initialLocation));
  await tester.pumpAndSettle();
}

/// The bottom bar's destination labelled [label] (a tab).
Finder destination(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

/// The drawer's item labelled [label].
Finder drawerItem(String label) =>
    find.descendant(of: find.byType(Drawer), matching: find.text(label));

/// The app bar showing [title]: which screen is on top.
Finder appBarTitled(String title) => find.widgetWithText(AppBar, title);

extension AppHarness on WidgetTester {
  /// The index of the selected tab.
  int get selectedTab =>
      widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettle();
  }

  /// Opens the navigation drawer from the current tab's menu button.
  Future<void> openDrawer() =>
      tapAndSettle(find.byTooltip('Open navigation menu'));

  /// Settles real-loop work in slices until [finder] finds something (a
  /// flow that alternates fake-time delays and database work needs several,
  /// conventions §11.54), failing after [attempts] slices instead of
  /// hanging.
  Future<void> pumpUntilFound(Finder finder, {int attempts = 20}) async {
    for (var i = 0; i < attempts; i++) {
      if (finder.evaluate().isNotEmpty) return;
      await settleRealAsync();
    }
    expect(finder, findsWidgets, reason: 'never appeared');
  }

  /// Lets work that runs on the real event loop finish (a database write
  /// started by a tap), then settles.
  Future<void> settleRealAsync() async {
    await runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await pumpAndSettle();
  }

  /// On Welcome: waits for the catalog, then taps [choice] and waits for
  /// Discover.
  Future<void> startFromWelcome(String choice) async {
    await pumpUntilFound(find.text(choice));
    await tap(find.text(choice));
    await pumpUntilFound(appBarTitled('Discover'));
  }
}
