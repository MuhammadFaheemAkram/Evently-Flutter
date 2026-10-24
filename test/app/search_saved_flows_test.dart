import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

// Search and Saved on the real DI graph, with the demo loaded (as of
// Wednesday 21 October, 15:00 in London).
void main() {
  tearDown(getIt.reset);

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tapAndSettle(destination(label));
  }

  Finder cardOf(String title) =>
      find.ancestor(of: find.text(title), matching: find.byType(Card));

  testWidgets('search offline, open a result, and find the search among the '
      'recent ones', (tester) async {
    await pumpEvently(tester, withDemo: true);
    getIt<NetworkSimulator>().failRequests = true;
    await openTab(tester, 'Search');

    await tester.enterText(find.byType(TextField), 'jazz');
    // The debounce, in the widget test's fake time.
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpUntilFound(find.text('Late Jazz at the Vaults'));
    expect(find.text('1 event'), findsOneWidget);

    await tester.tap(find.text('Late Jazz at the Vaults'));
    await tester.pumpUntilFound(appBarTitled('Event'));
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpUntilFound(find.text('Recent searches'));
    expect(find.widgetWithText(ListTile, 'jazz'), findsOneWidget);
  });

  testWidgets('filters alone: free and online, then a chip removed', (
    tester,
  ) async {
    await pumpEvently(tester, withDemo: true);
    await openTab(tester, 'Search');

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Free'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Online'));
    await tester.pump();
    await tester.ensureVisible(find.text('Apply'));
    await tester.tap(find.text('Apply'));
    await tester.pumpUntilFound(find.text('3 events'));

    expect(find.byTooltip('Filters, 2 on'), findsOneWidget);
    expect(find.text('The Burnout-Proof Developer'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Online'));
    await tester.pumpUntilFound(find.byTooltip('Filters, 1 on'));
    await tester.pumpUntilFound(find.textContaining(RegExp(r'^\d+ events$')));
    expect(find.text('3 events'), findsNothing);
  });

  testWidgets('saved from Discover, it is on Saved; swiped away and back '
      'with Undo', (tester) async {
    await pumpEvently(tester, withDemo: true);
    await tester.scrollUntilVisible(
      find.text('Thames Sunrise 10K'),
      300,
      scrollable: find
          .byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await tester.tap(
      find.descendant(
        of: cardOf('Thames Sunrise 10K').first,
        matching: find.byTooltip('Save'),
      ),
    );
    await tester.settleRealAsync();

    await openTab(tester, 'Saved');
    await tester.pumpUntilFound(find.text('Thames Sunrise 10K'));

    await tester.drag(find.text('Thames Sunrise 10K'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.pumpUntilFound(find.text('Removed “Thames Sunrise 10K”'));
    expect(find.text('Thames Sunrise 10K'), findsNothing);

    await tester.tap(find.text('Undo'));
    await tester.pumpUntilFound(find.text('Thames Sunrise 10K'));
  });
}
