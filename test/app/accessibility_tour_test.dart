import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/app_harness.dart';

// Every screen, in light and dark, with text at 200%: no layout overflows
// (an overflow fails the test), tap targets of at least 48 × 48, a label on
// everything tappable, and readable text contrast. Each phase adds its
// screens and states here.
void main() {
  tearDown(getIt.reset);

  for (final brightness in Brightness.values) {
    group('${brightness.name} theme, text at 200%', () {
      Future<void> open(
        WidgetTester tester, {
        required String at,
        bool onboarded = true,
        bool withDemo = true,
        bool offline = false,
      }) async {
        tester.platformDispatcher
          ..textScaleFactorTestValue = 2
          ..platformBrightnessTestValue = brightness;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        await pumpEvently(
          tester,
          onboarded: onboarded,
          withDemo: withDemo,
          preferences: const {'settings.preferredCity': 'London'},
          initialLocation: at,
          beforeLaunch: () => getIt<NetworkSimulator>().failRequests = offline,
        );
        // Phone width, but tall enough to lay out every item of a long list:
        // the checks below see only what is built.
        tester.view.physicalSize = const Size(390 * 3, 6000 * 3);
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(Scaffold).first);
        expect(MediaQuery.textScalerOf(context).scale(10), 20);
        expect(Theme.of(context).brightness, brightness);
      }

      Future<void> expectAccessible(WidgetTester tester) async {
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      }

      testWidgets('Welcome, choosing a city', (tester) async {
        await open(tester, at: '/welcome', onboarded: false);
        await tester.pumpUntilFound(find.text('Anywhere'));
        await tester.tapAndSettle(find.text('New York'));
        await expectAccessible(tester);
      });

      testWidgets('Welcome, offline', (tester) async {
        await open(tester, at: '/welcome', onboarded: false, offline: true);
        await tester.pumpUntilFound(find.text('Try again'));
        await expectAccessible(tester);
      });

      testWidgets('Search, results with filters', (tester) async {
        await open(tester, at: '/search');
        await tester.enterText(find.byType(TextField), 'London');
        await tester.pump(const Duration(milliseconds: 350));
        await tester.tap(find.byTooltip('Filters'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ChoiceChip, 'Free'));
        await tester.pump();
        await tester.tap(find.text('Apply'));
        await tester.pumpUntilFound(find.textContaining(' events'));
        await expectAccessible(tester);
      });

      testWidgets('the filter sheet', (tester) async {
        await open(tester, at: '/search');
        await tester.tap(find.byTooltip('Filters'));
        await tester.pumpAndSettle();
        await expectAccessible(tester);
      });

      testWidgets('RSVP, with errors after Confirm', (tester) async {
        await open(tester, at: '/events/ev_jazz_vaults/rsvp');
        await tester.enterText(find.byType(TextField), 'a' * 201);
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
        expect(find.text('Choose a ticket type.'), findsOneWidget);
        await expectAccessible(tester);
      });

      testWidgets('Tickets, past', (tester) async {
        await open(tester, at: '/tickets');
        await tester.tap(find.text('Past'));
        await tester.pumpAndSettle();
        await expectAccessible(tester);
      });

      testWidgets('the navigation drawer', (tester) async {
        await open(tester, at: '/discover');
        await tester.openDrawer();
        expect(find.byType(Drawer), findsOneWidget);
        await expectAccessible(tester);
      });

      for (final (name, location) in [
        ('Discover', '/discover'),
        ('Search', '/search'),
        ('Saved', '/saved'),
        ('Tickets', '/tickets'),
        ('Profile', '/profile'),
        (
          'Event, going, in another zone, with an agenda',
          '/events/ev_design_conf',
        ),
        ('Event, online and going', '/events/ev_dart_patterns_live'),
        ('Event, sold out', '/events/ev_dart_workshop'),
        ('Event, over', '/events/ev_accessibility_talk'),
        ('Event, not found', '/events/ev_nowhere'),
        ('RSVP', '/events/ev_jazz_vaults/rsvp'),
        ('RSVP, closed (going)', '/events/ev_flutter_london_meetup/rsvp'),
        ('Agenda, with clashes', '/events/ev_design_conf/agenda'),
        ('Ticket', '/tickets/tkt_demo_design_conf'),
        ('Ticket, past', '/tickets/tkt_demo_accessibility'),
        ('Organizer', '/organizers/o1'),
        ('Following', '/following'),
        ('Edit profile', '/profile/edit'),
        ('Settings', '/settings'),
        ('About', '/about'),
      ]) {
        testWidgets(name, (tester) async {
          await open(tester, at: location);
          await expectAccessible(tester);
        });
      }
    });
  }

  testWidgets('the tab labels keep their size at any text setting (a long '
      'press shows them)', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await pumpEvently(tester);

    final label = destination('Tickets');
    final inBar = tester.element(label);
    expect(MediaQuery.textScalerOf(inBar).scale(10), 10);

    final before = find.text('Tickets').evaluate().length;
    await tester.longPress(label);
    await tester.pumpAndSettle();
    // One more: the tooltip over the bar.
    expect(find.text('Tickets'), findsNWidgets(before + 1));
  });
}
