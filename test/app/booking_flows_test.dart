import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

// RSVP, tickets and the agenda on the real DI graph, with the demo loaded
// (as of Wednesday 21 October, 15:00 in London).
void main() {
  tearDown(getIt.reset);

  // "VIP" is on the event page under the dialog too.
  final vipOption = find.widgetWithText(RadioListTile<TicketType>, 'VIP');

  /// Brings [finder] into view (these screens build every row).
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> book(WidgetTester tester) async {
    await scrollTo(tester, find.widgetWithText(FilledButton, 'RSVP'));
    await tester.tap(find.widgetWithText(FilledButton, 'RSVP'));
    await tester.pumpUntilFound(vipOption);
    await tester.tap(vipOption);
    await tester.pump();
    await scrollTo(tester, find.text('Confirm · £45'));
    await tester.tap(find.text('Confirm · £45'));
  }

  testWidgets('RSVP: the ticket opens in place of the form, and Back '
      'returns to the event, now going', (tester) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/events/ev_jazz_vaults',
    );
    await tester.pumpUntilFound(appBarTitled('Event'));

    await book(tester);
    await tester.pumpUntilFound(appBarTitled('Ticket'));
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.textContaining('EVT-'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(appBarTitled('Event'), findsOneWidget);
    expect(appBarTitled('RSVP'), findsNothing);
    await tester.pumpUntilFound(find.text("You're going"));
  });

  testWidgets('RSVP offline fails cleanly; Try again books', (tester) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/events/ev_jazz_vaults/rsvp',
    );
    await tester.pumpUntilFound(vipOption);
    getIt<NetworkSimulator>().failRequests = true;

    await tester.tap(vipOption);
    await tester.pump();
    await tester.tap(find.text('Confirm · £45'));
    await tester.pumpUntilFound(find.textContaining('Not booked.'));
    expect(appBarTitled('RSVP'), findsOneWidget);

    getIt<NetworkSimulator>().failRequests = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpUntilFound(appBarTitled('Ticket'));
  });

  testWidgets('cancel from the ticket: asked first, then cancelled by you, '
      'on Tickets too', (tester) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/tickets/tkt_demo_design_conf',
    );
    // Tall enough for the whole ticket page to be built.
    tester.view.physicalSize = const Size(390 * 3, 1400 * 3);
    await tester.pumpUntilFound(find.text('Cancel RSVP'));

    await scrollTo(tester, find.text('Cancel RSVP'));
    await tester.tap(find.text('Cancel RSVP'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel RSVP').last);
    await tester.pumpUntilFound(find.text('Cancelled by you'));
    expect(find.text('RSVP cancelled. Your place went back.'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpUntilFound(appBarTitled('Tickets'));
    await tester.pumpUntilFound(find.text('Cancelled by you'));
  });

  testWidgets('agenda: bookmark a session, and find it under My sessions', (
    tester,
  ) async {
    await pumpEvently(
      tester,
      withDemo: true,
      initialLocation: '/events/ev_design_conf/agenda',
    );
    await tester.pumpUntilFound(find.text('Opening'));
    expect(find.text('Clashes with Type at Scale'), findsOneWidget);

    await tester.tap(find.byTooltip('Bookmark: Opening'));
    await tester.pumpUntilFound(find.byTooltip('Remove bookmark: Opening'));
    await tester.tap(find.text('My sessions'));
    await tester.pumpAndSettle();

    expect(find.text('Opening'), findsOneWidget);
    expect(find.text('Colour Systems That Last'), findsNothing);
  });
}
