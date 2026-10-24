import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/app_harness.dart';

// Welcome on the real DI graph: the catalog fetched by the fake API into an
// in-memory database, the choice saved in (in-memory) preferences, and the
// router's gate taking the user on.
void main() {
  tearDown(getIt.reset);

  Future<UserRows> userRows(WidgetTester tester) async =>
      (await tester.runAsync(() => getIt<UserDataDao>().readAll()))!;

  SharedPreferencesWithCache saved() => getIt<SharedPreferencesWithCache>();

  testWidgets('demo data in a chosen city: Discover, with the demo user and '
      'the city saved', (tester) async {
    await pumpEvently(tester, onboarded: false);
    await tester.pumpUntilFound(find.text('London'));

    await tester.tapAndSettle(find.text('London'));
    await tester.startFromWelcome('Explore with demo data');

    expect(tester.selectedTab, 0);
    expect(saved().getBool('settings.onboarded'), isTrue);
    expect(saved().getString('settings.preferredCity'), 'London');
    final user = await userRows(tester);
    expect(user.profile?.name, 'Sara Ahmed');
    expect(user.tickets, hasLength(4));
  });

  testWidgets('start fresh, anywhere: Discover, with nothing of the '
      "user's", (tester) async {
    await pumpEvently(tester, onboarded: false);

    await tester.startFromWelcome('Start fresh');

    expect(saved().getBool('settings.onboarded'), isTrue);
    expect(saved().getString('settings.preferredCity'), isNull);
    final user = await userRows(tester);
    expect(user.profile, isNull);
    expect(user.tickets, isEmpty);
  });

  testWidgets('offline: Welcome says why, and Try again recovers', (
    tester,
  ) async {
    await pumpEvently(
      tester,
      onboarded: false,
      beforeLaunch: () => getIt<NetworkSimulator>().failRequests = true,
    );
    await tester.pumpUntilFound(find.text('Try again'));
    expect(find.textContaining("Couldn't reach the server"), findsOneWidget);
    expect(find.text('Start fresh'), findsNothing);

    getIt<NetworkSimulator>().failRequests = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpUntilFound(find.text('Anywhere'));

    expect(find.text('Explore with demo data'), findsOneWidget);
  });

  testWidgets('a demo that fails to load keeps the user on Welcome, and '
      'Try again finishes it', (tester) async {
    await pumpEvently(tester, onboarded: false);
    await tester.pumpUntilFound(find.text('Explore with demo data'));

    getIt<NetworkSimulator>().failRequests = true;
    await tester.tap(find.text('Explore with demo data'));
    await tester.pumpUntilFound(find.text('Try again'));
    expect(find.byType(NavigationBar), findsNothing);
    expect(saved().getBool('settings.onboarded'), isNull);

    getIt<NetworkSimulator>().failRequests = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpUntilFound(appBarTitled('Discover'));

    expect((await userRows(tester)).tickets, hasLength(4));
  });

  testWidgets('once started, the app opens on Discover', (tester) async {
    await pumpEvently(tester, initialLocation: '/welcome');

    expect(appBarTitled('Discover'), findsOneWidget);
  });
}
