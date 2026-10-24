import 'package:evently/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';

void main() {
  tearDown(getIt.reset);

  const tabs = ['Discover', 'Search', 'Saved', 'Tickets', 'Profile'];

  group('first launch', () {
    testWidgets('opens on Welcome, without the tab bar', (tester) async {
      await pumpEvently(tester, onboarded: false);

      await tester.pumpUntilFound(find.text('Explore with demo data'));
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('a deep link waits behind Welcome', (tester) async {
      await pumpEvently(
        tester,
        onboarded: false,
        initialLocation: '/events/e1',
      );

      await tester.pumpUntilFound(find.text('Explore with demo data'));
    });

    for (final choice in ['Explore with demo data', 'Start fresh']) {
      testWidgets('"$choice" lands on Discover, and Welcome is gone', (
        tester,
      ) async {
        await pumpEvently(tester, onboarded: false);

        await tester.startFromWelcome(choice);

        expect(appBarTitled('Discover'), findsOneWidget);
        expect(tester.selectedTab, 0);
        expect(find.text(choice), findsNothing);
      });
    }
  });

  group('tabs', () {
    testWidgets('the app opens on Discover', (tester) async {
      await pumpEvently(tester);

      expect(appBarTitled('Discover'), findsOneWidget);
      expect(tester.selectedTab, 0);
    });

    testWidgets('each tab shows its own screen', (tester) async {
      await pumpEvently(tester);

      for (final (index, tab) in [...tabs.indexed.skip(1), (0, 'Discover')]) {
        await tester.tapAndSettle(destination(tab));
        expect(tester.selectedTab, index);
        expect(appBarTitled(tab), findsOneWidget);
      }
    });
  });

  group('the drawer', () {
    testWidgets('opens over the whole screen, tab bar included, from every '
        'tab', (tester) async {
      await pumpEvently(tester);

      for (final tab in tabs) {
        await tester.tapAndSettle(destination(tab));
        await tester.openDrawer();
        expect(find.byType(Drawer), findsOneWidget);
        // The modal barrier sits above the tab bar.
        expect(destination(tab).hitTestable(), findsNothing);
        await tester.tapAndSettle(drawerItem(tab));
        expect(find.byType(Drawer), findsNothing);
      }
    });

    testWidgets('marks the current tab, and switches tabs', (tester) async {
      await pumpEvently(tester);
      await tester.openDrawer();

      final selected = tester
          .widgetList<ListTile>(
            find.descendant(
              of: find.byType(Drawer),
              matching: find.byType(ListTile),
            ),
          )
          .where((tile) => tile.selected);
      expect(selected.map((tile) => (tile.title! as Text).data), ['Discover']);

      await tester.tapAndSettle(drawerItem('Tickets'));
      expect(appBarTitled('Tickets'), findsOneWidget);
      expect(tester.selectedTab, 3);
    });

    for (final screen in ['Following', 'Settings', 'About']) {
      testWidgets('$screen opens above the tabs, and Back returns to the '
          'tab', (tester) async {
        await pumpEvently(tester);
        await tester.tapAndSettle(destination('Saved'));
        await tester.openDrawer();

        await tester.tapAndSettle(drawerItem(screen));
        expect(appBarTitled(screen), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);

        await tester.tapAndSettle(find.byType(BackButton));
        expect(appBarTitled('Saved'), findsOneWidget);
        expect(tester.selectedTab, 2);
      });
    }
  });

  group('profile', () {
    testWidgets('Edit profile opens as a full-screen dialog, and Close '
        'returns', (tester) async {
      await pumpEvently(tester);
      await tester.tapAndSettle(destination('Profile'));

      await tester.tapAndSettle(find.text('Edit profile'));
      expect(appBarTitled('Edit profile'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tapAndSettle(find.byType(CloseButton));
      expect(appBarTitled('Profile'), findsOneWidget);
    });

    testWidgets("Profile's app bar opens Settings, and Settings opens "
        'About', (tester) async {
      await pumpEvently(tester);
      await tester.tapAndSettle(destination('Profile'));

      await tester.tapAndSettle(find.byTooltip('Settings'));
      expect(appBarTitled('Settings'), findsOneWidget);
      // Built below the screen already: scroll it on screen (§11.78).
      await tester.scrollUntilVisible(find.text('About Evently'), 300);
      await tester.ensureVisible(find.text('About Evently'));
      await tester.pumpAndSettle();
      await tester.tapAndSettle(find.text('About Evently'));
      expect(appBarTitled('About'), findsOneWidget);

      await tester.tapAndSettle(find.byType(BackButton));
      await tester.tapAndSettle(find.byType(BackButton));
      expect(appBarTitled('Profile'), findsOneWidget);
    });

    testWidgets('"/profile/edit" by link: Close goes to Profile', (
      tester,
    ) async {
      await pumpEvently(tester, initialLocation: '/profile/edit');

      expect(appBarTitled('Edit profile'), findsOneWidget);
      await tester.tapAndSettle(find.byType(CloseButton));
      expect(appBarTitled('Profile'), findsOneWidget);
    });
  });

  group("an event's screens", () {
    testWidgets('an RSVP link opens the dialog over its event, and Close '
        'returns to it', (tester) async {
      await pumpEvently(tester, initialLocation: '/events/e1/rsvp');

      expect(appBarTitled('RSVP'), findsOneWidget);
      await tester.tapAndSettle(find.byType(CloseButton));
      expect(appBarTitled('Event'), findsOneWidget);
    });

    testWidgets('an agenda link opens over its event, and Back returns to '
        'it', (tester) async {
      await pumpEvently(tester, initialLocation: '/events/e1/agenda');

      expect(appBarTitled('Agenda'), findsOneWidget);
      await tester.tapAndSettle(find.byType(BackButton));
      expect(appBarTitled('Event'), findsOneWidget);
    });
  });

  group('deep links above the tabs', () {
    for (final (location, title, home) in [
      ('/events/e1', 'Event', 'Discover'),
      ('/tickets/t1', 'Ticket', 'Tickets'),
      ('/organizers/o1', 'Organizer', 'Discover'),
      ('/following', 'Following', 'Discover'),
      ('/settings', 'Settings', 'Profile'),
      ('/about', 'About', 'Discover'),
    ]) {
      testWidgets('$location opens with a Close button to $home', (
        tester,
      ) async {
        await pumpEvently(tester, initialLocation: location);
        expect(appBarTitled(title), findsOneWidget);

        await tester.tapAndSettle(find.byTooltip('Close'));

        expect(appBarTitled(home), findsOneWidget);
      });
    }
  });

  testWidgets('an unknown location shows "Page not found", with a way back', (
    tester,
  ) async {
    await pumpEvently(tester, initialLocation: '/nowhere');
    expect(find.text('Page not found'), findsOneWidget);

    await tester.tapAndSettle(find.text('Go to Discover'));
    expect(appBarTitled('Discover'), findsOneWidget);
  });
}
