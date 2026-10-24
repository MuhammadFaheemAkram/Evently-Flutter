import 'package:evently/app/evently_app.dart';
import 'package:evently/core/navigation/placeholder_onboarding.dart';
import 'package:evently/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'pump_app.dart';

/// Starts the whole app on the real DI graph: already past Welcome
/// ([onboarded]) or on a first launch, optionally on a deep link. Pair it
/// with `tearDown(getIt.reset)`.
Future<void> pumpEvently(
  WidgetTester tester, {
  bool onboarded = true,
  String? initialLocation,
}) async {
  configureDependencies();
  if (onboarded) getIt<PlaceholderOnboarding>().complete();
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
}
