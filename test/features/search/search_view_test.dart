import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/features/search/bloc/search_bloc.dart';
import 'package:evently/features/search/bloc/search_event.dart';
import 'package:evently/features/search/bloc/search_state.dart';
import 'package:evently/features/search/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  late _MockSearchBloc bloc;

  final jazz = card(event(id: 'ev_jazz', title: 'Late Jazz'));
  final results = SearchState(
    status: SearchStatus.results,
    filter: const EventFilter(query: 'jazz'),
    results: [jazz],
    now: DateTime.utc(2026, 10, 21, 14),
  );

  setUpAll(() => registerFallbackValue(const SearchResultOpened()));

  setUp(() => bloc = _MockSearchBloc());

  Future<void> pump(WidgetTester tester, SearchState state) {
    when(() => bloc.state).thenReturn(state);
    tester.usePhoneSurface();
    return tester.pumpThemed(
      BlocProvider<SearchBloc>.value(
        value: bloc,
        child: SearchView(today: () => CalendarDate(2026, 10, 21)),
      ),
    );
  }

  testWidgets('nothing searched and no recent searches: how to search', (
    tester,
  ) async {
    await pump(tester, const SearchState());

    expect(find.text('Find an event'), findsOneWidget);
    expect(find.byTooltip('Filters'), findsOneWidget);
  });

  testWidgets('recent searches: tap one to search it again at once', (
    tester,
  ) async {
    await pump(tester, const SearchState(recentSearches: ['jazz', 'design']));

    await tester.tap(find.text('design'));

    verify(
      () => bloc.add(
        any(
          that: isA<SearchQueryChanged>()
              .having((e) => e.query, 'query', 'design')
              .having((e) => e.immediate, 'immediate', isTrue),
        ),
      ),
    ).called(1);
    expect(find.widgetWithText(TextField, 'design'), findsOneWidget);
  });

  testWidgets('recent searches: Clear all', (tester) async {
    await pump(tester, const SearchState(recentSearches: ['jazz']));

    await tester.tap(find.text('Clear all'));

    verify(() => bloc.add(any(that: isA<SearchRecentSearchesCleared>())))
        .called(1);
  });

  testWidgets('typing goes to the Bloc, which debounces it', (tester) async {
    await pump(tester, const SearchState());

    await tester.enterText(find.byType(TextField), 'ja');

    verify(
      () => bloc.add(
        any(
          that: isA<SearchQueryChanged>()
              .having((e) => e.query, 'query', 'ja')
              .having((e) => e.immediate, 'immediate', isFalse),
        ),
      ),
    ).called(1);
  });

  testWidgets('results: the count, then the cards', (tester) async {
    await pump(tester, results);

    expect(find.text('1 event'), findsOneWidget);
    expect(find.text('Late Jazz'), findsOneWidget);
  });

  testWidgets('searching with nothing yet: a spinner', (tester) async {
    await pump(
      tester,
      const SearchState(
        status: SearchStatus.searching,
        filter: EventFilter(query: 'jazz'),
      ),
    );

    expect(find.text('Searching'), findsOneWidget);
  });

  testWidgets('searching again keeps the previous results on screen', (
    tester,
  ) async {
    await pump(tester, results.copyWith(status: SearchStatus.searching));

    expect(find.text('Late Jazz'), findsOneWidget);
  });

  testWidgets('no match with filters: Clear filters keeps the text', (
    tester,
  ) async {
    await pump(
      tester,
      const SearchState(
        status: SearchStatus.results,
        filter: EventFilter(query: 'jazz', price: PriceFilter.free),
      ),
    );

    expect(find.text('No events match'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));

    verify(
      () => bloc.add(
        any(
          that: isA<SearchFiltersChanged>().having(
            (e) => e.filter,
            'filter',
            const EventFilter(query: 'jazz'),
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('filters on: a badge counts them, and each chip removes '
      'itself', (tester) async {
    await pump(
      tester,
      results.copyWith(
        filter: const EventFilter(
          query: 'jazz',
          categories: {EventCategory.music},
          rsvp: RsvpFilter.going,
        ),
      ),
    );

    expect(find.byTooltip('Filters, 2 on'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove Music'));

    verify(
      () => bloc.add(
        any(
          that: isA<SearchFiltersChanged>().having(
            (e) => e.filter,
            'filter',
            const EventFilter(query: 'jazz', rsvp: RsvpFilter.going),
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('the filter button opens the sheet, and Apply sends the '
      'filters', (tester) async {
    await pump(tester, results);

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Free'));
    await tester.pump();
    final apply = find.text('Apply');
    await tester.ensureVisible(apply);
    await tester.tap(apply);
    await tester.pumpAndSettle();

    verify(
      () => bloc.add(
        any(
          that: isA<SearchFiltersChanged>().having(
            (e) => e.filter.price,
            'price',
            PriceFilter.free,
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('a failure says so', (tester) async {
    await pump(tester, const SearchState(status: SearchStatus.failure));

    expect(find.text("Couldn't search the events."), findsOneWidget);
  });

  testWidgets('saving a result goes to the Bloc', (tester) async {
    await pump(tester, results);

    await tester.tap(find.byTooltip('Save'));

    verify(
      () => bloc.add(
        any(that: isA<SearchSaveToggled>().having((e) => e.item, 'item', jazz)),
      ),
    ).called(1);
  });
}
