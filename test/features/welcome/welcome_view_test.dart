import 'package:bloc_test/bloc_test.dart';
import 'package:evently/features/welcome/cubit/welcome_cubit.dart';
import 'package:evently/features/welcome/cubit/welcome_state.dart';
import 'package:evently/features/welcome/welcome_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockWelcomeCubit extends MockCubit<WelcomeState>
    implements WelcomeCubit {}

void main() {
  late _MockWelcomeCubit cubit;

  const ready = WelcomeState(
    catalog: CatalogStatus.ready,
    cities: ['Berlin', 'London'],
  );

  setUp(() {
    cubit = _MockWelcomeCubit();
    when(() => cubit.loadCatalog()).thenAnswer((_) async {});
    when(() => cubit.exploreDemo()).thenAnswer((_) async {});
    when(() => cubit.startFresh()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, WelcomeState state) {
    when(() => cubit.state).thenReturn(state);
    tester.usePhoneSurface();
    return tester.pumpThemed(
      BlocProvider<WelcomeCubit>.value(
        value: cubit,
        child: const WelcomeView(),
      ),
    );
  }

  ChoiceChip chip(WidgetTester tester, String label) =>
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, label));

  FilledButton demoButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  TextButton freshButton(WidgetTester tester) =>
      tester.widget<TextButton>(find.byType(TextButton));

  testWidgets('while the catalog loads: a progress indicator, no choices '
      'yet', (tester) async {
    await pump(tester, const WelcomeState());

    expect(find.text('Loading events'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.text('Explore with demo data'), findsNothing);
    expect(find.text('Start fresh'), findsNothing);
  });

  testWidgets('a failed catalog says why, and Try again fetches it again', (
    tester,
  ) async {
    await pump(
      tester,
      const WelcomeState(
        catalog: CatalogStatus.failed,
        errorMessage: "Couldn't reach the server.",
      ),
    );

    expect(find.text("Couldn't reach the server."), findsOneWidget);
    expect(find.text('Start fresh'), findsNothing);
    await tester.tap(find.text('Try again'));
    verify(() => cubit.loadCatalog()).called(1);
  });

  testWidgets('ready: "Anywhere" and the cities, in order, the chosen one '
      'selected', (tester) async {
    await pump(tester, ready.copyWith(city: 'London'));

    final labels = [
      for (final chip in tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)))
        ((chip.label as Text).data, chip.selected),
    ];
    expect(labels, [('Anywhere', false), ('Berlin', false), ('London', true)]);
  });

  testWidgets('a chip chooses its city, "Anywhere" none', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.text('Berlin'));
    await tester.tap(find.text('Anywhere'));

    verifyInOrder([
      () => cubit.selectCity('Berlin'),
      () => cubit.selectCity(null),
    ]);
  });

  testWidgets('each start goes to the Cubit', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.text('Explore with demo data'));
    await tester.tap(find.text('Start fresh'));

    verify(() => cubit.exploreDemo()).called(1);
    verify(() => cubit.startFresh()).called(1);
  });

  testWidgets('while the demo loads, its button spins and everything '
      'waits', (tester) async {
    await pump(tester, ready.copyWith(starting: StartChoice.demo));

    expect(find.text('Explore with demo data'), findsNothing);
    expect(find.bySemanticsLabel('Loading the demo'), findsOneWidget);
    expect(demoButton(tester).onPressed, isNull);
    expect(freshButton(tester).onPressed, isNull);
    expect(chip(tester, 'Berlin').onSelected, isNull);
  });

  testWidgets('while starting fresh, everything waits', (tester) async {
    await pump(tester, ready.copyWith(starting: StartChoice.fresh));

    expect(find.bySemanticsLabel('Starting'), findsOneWidget);
    expect(demoButton(tester).onPressed, isNull);
    expect(chip(tester, 'Anywhere').onSelected, isNull);
  });

  testWidgets('a failed demo shows why, offers Try again, and still allows '
      'starting fresh', (tester) async {
    await pump(
      tester,
      ready.copyWith(errorMessage: "Couldn't reach the server."),
    );

    expect(find.text("Couldn't reach the server."), findsOneWidget);
    expect(find.text('Explore with demo data'), findsNothing);
    await tester.tap(find.text('Try again'));
    verify(() => cubit.exploreDemo()).called(1);
    expect(freshButton(tester).onPressed, isNotNull);
  });

  testWidgets('the error is announced, and "Your city" is a heading', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester, ready.copyWith(errorMessage: 'Offline.'));

    expect(
      tester.getSemantics(find.text('Offline.')),
      isSemantics(label: 'Offline.', isLiveRegion: true),
    );
    expect(
      tester.getSemantics(find.text('Your city')),
      isSemantics(label: 'Your city', isHeader: true),
    );
    handle.dispose();
  });
}
