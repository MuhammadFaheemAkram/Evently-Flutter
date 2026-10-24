import 'dart:async';

import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/domain/usecase/search_use_cases.dart';
import 'package:evently/features/search/bloc/search_bloc.dart';
import 'package:evently/features/search/bloc/search_event.dart';
import 'package:evently/features/search/bloc/search_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/data_stack.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/wait_for.dart';

class _MockSearchEvents extends Mock implements SearchEventsUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;
  late _MockSearchEvents searchEvents;

  /// One result per search, named after what was asked.
  List<EventCardItem> resultsFor(EventFilter filter) => [
    card(event(id: 'for "${filter.query}" ${filter.activeCount}')),
  ];

  setUpAll(() => registerFallbackValue(const EventFilter()));

  setUp(() {
    stack = DataStack();
    searchEvents = _MockSearchEvents();
    when(() => searchEvents(any())).thenAnswer(
      (invocation) => Stream.value(
        resultsFor(invocation.positionalArguments.single as EventFilter),
      ),
    );
  });
  tearDown(() => stack.close());

  SearchBloc build({
    Duration debounce = const Duration(milliseconds: 10),
    bool closeAfterTest = true,
    SearchEventsUseCase? search,
  }) {
    final bloc = SearchBloc(
      search ?? searchEvents,
      stack.watchRecentSearches,
      stack.saveRecentSearch,
      stack.clearRecentSearches,
      stack.setEventSaved,
      stack.eventClock,
      debounce: debounce,
    );
    if (closeAfterTest) addTearDown(bloc.close);
    return bloc;
  }

  List<EventFilter> searched() => [
    for (final call in verify(() => searchEvents(captureAny())).captured)
      call as EventFilter,
  ];

  group('timing (fake time)', () {
    test('typed text waits out 300 ms, then runs', () {
      fakeAsync((time) {
        // Closed inside the fake zone it was made in: a close awaited after
        // the test would wait on fake timers forever.
        final bloc = build(
          debounce: const Duration(milliseconds: 300),
          closeAfterTest: false,
        );
        final states = <SearchState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const SearchQueryChanged('jazz'));
        time.elapse(const Duration(milliseconds: 299));
        verifyNever(() => searchEvents(any()));
        expect(states, isEmpty);

        time.elapse(const Duration(milliseconds: 1));
        expect(searched(), [const EventFilter(query: 'jazz')]);
        expect(states.map((s) => s.status), [
          SearchStatus.searching,
          SearchStatus.results,
        ]);

        unawaited(subscription.cancel());
        unawaited(bloc.close());
        time.flushMicrotasks();
      });
    });

    test('applied filters and a tapped recent search run at once', () {
      fakeAsync((time) {
        final bloc = build(
          debounce: const Duration(milliseconds: 300),
          closeAfterTest: false,
        );

        bloc.add(
          const SearchFiltersChanged(EventFilter(price: PriceFilter.free)),
        );
        time.flushMicrotasks();
        expect(searched(), [const EventFilter(price: PriceFilter.free)]);

        bloc.add(const SearchQueryChanged('jazz', immediate: true));
        time.flushMicrotasks();
        expect(searched(), [
          const EventFilter(query: 'jazz', price: PriceFilter.free),
        ]);

        unawaited(bloc.close());
        time.flushMicrotasks();
      });
    });

    test('clearing the field goes idle at once, dropping a pending query', () {
      fakeAsync((time) {
        final bloc = build(
          debounce: const Duration(milliseconds: 300),
          closeAfterTest: false,
        );

        bloc
          ..add(const SearchQueryChanged('jazz'))
          ..add(const SearchQueryChanged(''));
        time.elapse(const Duration(seconds: 1));

        verifyNever(() => searchEvents(any()));
        expect(bloc.state.status, SearchStatus.idle);

        unawaited(bloc.close());
        time.flushMicrotasks();
      });
    });
  });

  // Switching from one search to the next awaits a real cancel, which never
  // finishes in fake time (conventions §11.45): tested in real time with a
  // short debounce.
  group('searching', () {
    test('only the last text typed within the debounce runs', () async {
      final bloc = build()
        ..add(const SearchQueryChanged('ja'))
        ..add(const SearchQueryChanged('jaz'))
        ..add(const SearchQueryChanged('jazz'));

      await waitFor(bloc, (s) => s.status == SearchStatus.results);

      expect(searched(), [const EventFilter(query: 'jazz')]);
    });

    test('fewer than two characters and no filter: idle, no search', () async {
      final bloc = build()..add(const SearchQueryChanged(' j '));

      await waitFor(bloc, (s) => s.filter.query == 'j');

      expect(bloc.state.status, SearchStatus.idle);
      verifyNever(() => searchEvents(any()));
    });

    test(
      'filters alone search, and too-short text is left out of it',
      () async {
        final bloc = build()
          ..add(const SearchQueryChanged('j', immediate: true))
          ..add(
            const SearchFiltersChanged(
              EventFilter(categories: {EventCategory.music}),
            ),
          );

        await waitFor(bloc, (s) => s.status == SearchStatus.results);

        expect(
          searched().last,
          const EventFilter(categories: {EventCategory.music}),
        );
        // The field still says "j".
        expect(bloc.state.filter.query, 'j');
      },
    );

    test('new filters keep the text; new text keeps the filters', () async {
      final bloc = build()
        ..add(const SearchQueryChanged('jazz', immediate: true))
        ..add(const SearchFiltersChanged(EventFilter(rsvp: RsvpFilter.going)));
      await waitFor(
        bloc,
        (s) => s.status == SearchStatus.results && s.filter.hasFilters,
      );
      expect(
        bloc.state.filter,
        const EventFilter(query: 'jazz', rsvp: RsvpFilter.going),
      );

      bloc.add(const SearchQueryChanged('blues', immediate: true));
      await waitFor(bloc, (s) => s.filter.query == 'blues');
      expect(bloc.state.filter.rsvp, RsvpFilter.going);
    });

    test("a newer search stops the older one's live results", () async {
      final older = StreamController<List<EventCardItem>>();
      addTearDown(older.close);
      when(() => searchEvents(const EventFilter(query: 'older')))
          .thenAnswer((_) => older.stream);
      final bloc = build()
        ..add(const SearchQueryChanged('older', immediate: true));
      await waitFor(bloc, (s) => s.status == SearchStatus.searching);

      bloc.add(const SearchQueryChanged('newer', immediate: true));
      await waitFor(bloc, (s) => s.status == SearchStatus.results);
      older.add([card(event(id: 'stale'))]);
      await pumpEventQueue();

      expect(bloc.state.results.single.event.id, 'for "newer" 0');
    });

    test('an error in the results: failure', () async {
      when(() => searchEvents(any()))
          .thenAnswer((_) => Stream.error(StateError('broken')));
      final bloc = build()
        ..add(const SearchQueryChanged('jazz', immediate: true));

      await waitFor(bloc, (s) => s.status == SearchStatus.failure);

      expect(bloc.state.results, isEmpty);
    });
  });

  group('on the real stack', () {
    test('finds the bundled events, and follows a save', () async {
      await stack.catalog.refresh();
      final bloc = build(search: stack.searchEvents)
        ..add(const SearchQueryChanged('jazz', immediate: true));

      final found = await waitFor(
        bloc,
        (s) => s.status == SearchStatus.results,
      );
      expect([for (final r in found.results) r.event.id], ['ev_jazz_vaults']);
      expect(found.now, stack.eventClock.now());

      bloc.add(SearchSaveToggled(found.results.single));
      await waitFor(bloc, (s) => s.results.single.isSaved);
    });

    test('recent searches: an opened result remembers the text; clear '
        'forgets them all', () async {
      final bloc = build()..add(const SearchSubscriptionRequested());
      bloc.add(const SearchQueryChanged(' jazz ', immediate: true));
      await waitFor(bloc, (s) => s.status == SearchStatus.results);

      bloc.add(const SearchResultOpened());
      await waitFor(bloc, (s) => s.recentSearches.isNotEmpty);
      expect(bloc.state.recentSearches, ['jazz']);

      bloc.add(const SearchRecentSearchesCleared());
      await waitFor(bloc, (s) => s.recentSearches.isEmpty);
    });

    test('a save that fails says why', () async {
      final bloc = build()
        ..add(SearchSaveToggled(card(event(id: 'ev_nowhere'))));

      await waitFor(bloc, (s) => s.messageSerial == 1);

      expect(bloc.state.message, isNotEmpty);
    });
  });
}
