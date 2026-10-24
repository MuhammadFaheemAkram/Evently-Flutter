import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/day_group.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:evently/features/discover/cubit/discover_state.dart';
import 'package:evently/features/discover/discover_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockDiscoverCubit extends MockCubit<DiscoverState>
    implements DiscoverCubit {}

void main() {
  late _MockDiscoverCubit cubit;

  final today = CalendarDate(2026, 10, 21);
  final now = DateTime.utc(2026, 10, 21, 14);
  final meetup = card(
    event(id: 'ev_meetup', title: 'Flutter meetup', featured: true),
  );
  final jazz = card(
    event(id: 'ev_jazz', title: 'Jazz night', category: EventCategory.music),
    isGoing: true,
  );
  final ready = DiscoverState(
    status: DiscoverStatus.ready,
    featured: [meetup],
    upcoming: [
      DayGroup(day: today, items: [meetup]),
      DayGroup(day: today.addDays(1), items: [jazz]),
      DayGroup(day: today.addDays(3), items: [meetup]),
    ],
    now: now,
    today: today,
  );

  setUp(() {
    cubit = _MockDiscoverCubit();
    when(() => cubit.refresh()).thenAnswer((_) async {});
    when(() => cubit.tryAgain()).thenAnswer((_) async {});
    when(() => cubit.toggleSaved(any())).thenAnswer((_) async {});
  });

  setUpAll(() => registerFallbackValue(meetup));

  Future<void> pump(WidgetTester tester, DiscoverState state) {
    when(() => cubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(1170, 6000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      BlocProvider<DiscoverCubit>.value(
        value: cubit,
        child: const DiscoverView(),
      ),
    );
  }

  testWidgets('filling an empty cache: loading', (tester) async {
    await pump(tester, const DiscoverState());

    expect(find.text('Loading events'), findsOneWidget);
  });

  testWidgets('an empty cache offline: why, and Try again', (tester) async {
    await pump(
      tester,
      const DiscoverState(
        status: DiscoverStatus.failed,
        errorMessage: "Couldn't reach the server.",
      ),
    );

    expect(find.text("Couldn't reach the server."), findsOneWidget);
    await tester.tap(find.text('Try again'));
    verify(() => cubit.tryAgain()).called(1);
  });

  testWidgets('no events at all: says so, with Refresh', (tester) async {
    await pump(tester, const DiscoverState(status: DiscoverStatus.empty));

    expect(find.text('No events yet'), findsOneWidget);
    await tester.tap(find.text('Refresh'));
    verify(() => cubit.refresh()).called(1);
  });

  testWidgets('ready: featured, then coming up under day headings', (
    tester,
  ) async {
    await pump(tester, ready);

    expect(find.text('Featured'), findsOneWidget);
    expect(find.text('Coming up'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('Sat, 24 Oct'), findsOneWidget);
    expect(find.text('Jazz night'), findsOneWidget);
    expect(find.text('Going'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('"Anywhere": no city section', (tester) async {
    await pump(tester, ready);

    expect(find.textContaining('In '), findsNothing);
  });

  testWidgets('a city: its section', (tester) async {
    await pump(tester, ready.copyWith(city: 'London', inYourCity: [meetup]));

    expect(find.text('In London'), findsOneWidget);
  });

  testWidgets('a city with nothing coming up says so', (tester) async {
    await pump(tester, ready.copyWith(city: 'Berlin'));

    expect(find.text('In Berlin'), findsOneWidget);
    expect(find.text('Nothing coming up in Berlin yet.'), findsOneWidget);
  });

  testWidgets('a category chip filters', (tester) async {
    await pump(tester, ready);

    final music = find.widgetWithText(ChoiceChip, 'Music');
    await tester.ensureVisible(music);
    await tester.pumpAndSettle();
    await tester.tap(music);

    verify(() => cubit.selectCategory(EventCategory.music)).called(1);
  });

  testWidgets('a category with nothing coming up says so, and "Show all" '
      'undoes it', (tester) async {
    await pump(
      tester,
      ready.copyWith(category: EventCategory.health, upcoming: []),
    );

    expect(find.text('No health events coming up.'), findsOneWidget);
    await tester.tap(find.text('Show all'));
    verify(() => cubit.selectCategory(null)).called(1);
  });

  testWidgets('saving from a card goes to the Cubit', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.byTooltip('Save').first);

    verify(() => cubit.toggleSaved(meetup)).called(1);
  });

  testWidgets('a bookable card offers RSVP; a going one does not', (
    tester,
  ) async {
    await pump(tester, ready);

    expect(ready.rsvpBlockFor(meetup), isNull);
    expect(ready.rsvpBlockFor(jazz), RsvpBlock.going);
    // Two meetup cards in the upcoming list.
    expect(find.text('RSVP'), findsNWidgets(2));
  });

  testWidgets('a message shows once, as a SnackBar', (tester) async {
    whenListen(
      cubit,
      Stream.value(ready.copyWith(message: 'Offline.', messageSerial: 1)),
      initialState: ready,
    );
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpThemed(
      BlocProvider<DiscoverCubit>.value(
        value: cubit,
        child: const DiscoverView(),
      ),
    );
    await tester.pump();

    expect(find.widgetWithText(SnackBar, 'Offline.'), findsOneWidget);
  });
}
