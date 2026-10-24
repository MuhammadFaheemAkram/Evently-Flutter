import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/service/link_opener.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes/recording_link_opener.dart';

// Discover and Event detail on the real DI graph, with the demo loaded (as
// of Wednesday 21 October, 15:00 in London).
void main() {
  tearDown(getIt.reset);

  /// Scrolls Discover's list (built lazily) until [finder] is on screen.
  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );

  Future<void> openEvent(WidgetTester tester, String title) async {
    final card = find.text(title).first;
    await scrollTo(tester, card);
    await tester.tap(card);
    await tester.pumpUntilFound(appBarTitled('Event'));
  }

  testWidgets('Discover lists the demo; a card opens its event, and Back '
      'returns', (tester) async {
    await pumpEvently(tester, withDemo: true);

    expect(find.text('Featured'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    await openEvent(tester, 'Flutter London: State of Flutter');

    expect(find.text("You're going"), findsOneWidget);
    expect(find.text('Code Hub'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(appBarTitled('Discover'), findsOneWidget);
  });

  testWidgets('saving from a card shows on the event, offline too', (
    tester,
  ) async {
    await pumpEvently(tester, withDemo: true);
    getIt<NetworkSimulator>().failRequests = true;
    await scrollTo(tester, find.text('Thames Sunrise 10K'));
    final card = find.ancestor(
      of: find.text('Thames Sunrise 10K').first,
      matching: find.byType(Card),
    );

    await tester.tap(
      find.descendant(of: card.first, matching: find.byTooltip('Save')),
    );
    await tester.pumpUntilFound(
      find.descendant(
        of: card.first,
        matching: find.byTooltip('Remove from saved'),
      ),
    );

    await openEvent(tester, 'Thames Sunrise 10K');
    expect(find.byTooltip('Remove from saved'), findsOneWidget);
  });

  testWidgets('pull to refresh offline keeps the events and says so', (
    tester,
  ) async {
    await pumpEvently(tester, withDemo: true);
    getIt<NetworkSimulator>().failRequests = true;

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpUntilFound(find.text(DiscoverCubit.offlineMessage));

    expect(find.text('Featured'), findsOneWidget);
  });

  testWidgets('RSVP on a card opens the booking dialog', (tester) async {
    await pumpEvently(tester, withDemo: true);
    await scrollTo(tester, find.text('Midnight Code Jam'));
    final card = find.ancestor(
      of: find.text('Midnight Code Jam'),
      matching: find.byType(Card),
    );

    await tester.tap(find.descendant(of: card, matching: find.text('RSVP')));
    await tester.pumpAndSettle();

    expect(appBarTitled('RSVP'), findsOneWidget);
  });

  testWidgets('from an event: its organizer, its agenda, your ticket', (
    tester,
  ) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/events/ev_design_conf',
    );
    await tester.pumpUntilFound(find.text('View ticket'));
    // A Berlin event, read by a user in London (in GMT by then).
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.data ?? '').startsWith('Your time:') &&
            (w.data ?? '').endsWith(' GMT'),
      ),
      findsOneWidget,
    );

    Future<void> visit(String label, String title) async {
      final link = find.text(label);
      await tester.ensureVisible(link);
      await tester.pumpAndSettle();
      await tester.tap(link);
      await tester.pumpAndSettle();
      expect(appBarTitled(title), findsOneWidget, reason: label);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    await visit('View ticket', 'Ticket');
    await visit('See full agenda (12 sessions)', 'Agenda');
    await visit('Berlin Design Collective', 'Organizer');
  });

  testWidgets('Directions opens the maps link', (tester) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/events/ev_jazz_vaults',
    );
    await tester.pumpUntilFound(find.text('Directions'));

    await tester.tap(find.text('Directions'));
    await tester.pumpAndSettle();

    final opened = (getIt<LinkOpener>() as RecordingLinkOpener).opened;
    expect(opened.single.host, 'www.google.com');
  });

  testWidgets('a link to an event that is gone: not found, and back to '
      'Discover', (tester) async {
    await pumpEvently(tester, initialLocation: '/events/ev_nowhere');
    await tester.pumpUntilFound(find.text("This event isn't available"));

    await tester.tap(find.text('Go to Discover'));
    await tester.pumpAndSettle();

    expect(appBarTitled('Discover'), findsOneWidget);
  });
}
