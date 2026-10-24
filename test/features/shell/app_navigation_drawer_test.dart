import 'package:evently/features/shell/app_navigation_drawer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<List<DrawerDestination>> pumpDrawer(
    WidgetTester tester, {
    int currentTab = 0,
  }) async {
    final selected = <DrawerDestination>[];
    tester.usePhoneSurface();
    await tester.pumpThemed(
      AppNavigationDrawer(currentTab: currentTab, onSelected: selected.add),
    );
    return selected;
  }

  List<String> labels(WidgetTester tester) => [
    for (final tile in tester.widgetList<ListTile>(find.byType(ListTile)))
      (tile.title! as Text).data!,
  ];

  testWidgets('the tabs, then Following and Settings, then About', (
    tester,
  ) async {
    await pumpDrawer(tester);

    expect(labels(tester), [
      'Discover',
      'Search',
      'Saved',
      'Tickets',
      'Profile',
      'Following',
      'Settings',
      'About',
    ]);
  });

  testWidgets('only the current tab is selected', (tester) async {
    await pumpDrawer(tester, currentTab: 3);

    final selected = [
      for (final tile in tester.widgetList<ListTile>(find.byType(ListTile)))
        if (tile.selected) (tile.title! as Text).data,
    ];
    expect(selected, ['Tickets']);
  });

  testWidgets('each item reports where it leads', (tester) async {
    final selected = await pumpDrawer(tester);

    await tester.tap(find.text('Saved'));
    await tester.tap(find.text('Following'));
    await tester.tap(find.text('Settings'));
    await tester.tap(find.text('About'));

    expect(selected, [
      isA<TabDestination>().having((d) => d.index, 'index', 2),
      ScreenDestination.following,
      ScreenDestination.settings,
      ScreenDestination.about,
    ]);
  });

  test('every tab is one short word, so five fit the bar', () {
    expect(
      [for (final tab in AppTab.values) tab.label],
      ['Discover', 'Search', 'Saved', 'Tickets', 'Profile'],
    );
  });

  testWidgets('at large text it widens, so long labels keep whole words', (
    tester,
  ) async {
    await pumpDrawer(tester);
    expect(tester.getSize(find.byType(Drawer)).width, 304);

    // AX3 on iOS, about 235 %. (The test font's square glyphs make the
    // words themselves no measure: the width is what changes.)
    tester.platformDispatcher.textScaleFactorTestValue = 2.35;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await pumpDrawer(tester);

    expect(tester.getSize(find.byType(Drawer)).width, closeTo(390 * 0.9, 0.01));
  });
}
