import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/domain/usecase/search_use_cases.dart';
import 'package:evently/features/search/bloc/search_event.dart';
import 'package:evently/features/search/bloc/search_state.dart';
import 'package:evently/features/search/bloc/search_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives Search: text plus a typed filter, over the cache.
///
/// The one Bloc in the app (every other screen is a Cubit), because typing
/// is a *stream* of events that needs shaping: debounced, with stale
/// searches cancelled. Event transformers say that declaratively
/// ([debounceRestartable]), where a Cubit would need hand-written timers.
///
/// The results are live (`emit.forEach`): a save, a booking or a refresh
/// elsewhere updates them, because drift re-runs the query.
@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
    this._search,
    this._watchRecent,
    this._saveRecent,
    this._clearRecent,
    this._setSaved,
    this._clock, {
    @ignoreParam Duration debounce = const Duration(milliseconds: 300),
  }) : super(const SearchState()) {
    on<SearchSubscriptionRequested>(_onSubscriptionRequested);
    on<SearchInputChanged>(
      _onInputChanged,
      transformer: debounceRestartable(debounce),
    );
    on<SearchResultOpened>((_, _) => _saveRecent(state.filter.query));
    on<SearchRecentSearchesCleared>((_, _) => _clearRecent());
    on<SearchSaveToggled>(_onSaveToggled);
  }

  final SearchEventsUseCase _search;
  final WatchRecentSearchesUseCase _watchRecent;
  final SaveRecentSearchUseCase _saveRecent;
  final ClearRecentSearchesUseCase _clearRecent;
  final SetEventSavedUseCase _setSaved;
  final EventClock _clock;

  /// Shorter text shows the recent searches: one letter matches nearly
  /// everything and helps no one. Filters alone still search.
  static const minQueryLength = SaveRecentSearchUseCase.minLength;

  Future<void> _onSubscriptionRequested(
    SearchSubscriptionRequested event,
    Emitter<SearchState> emit,
  ) => emit.forEach(
    _watchRecent(),
    onData: (recent) => state.copyWith(recentSearches: recent),
  );

  Future<void> _onInputChanged(
    SearchInputChanged event,
    Emitter<SearchState> emit,
  ) async {
    final filter = switch (event) {
      SearchQueryChanged(:final query) => state.filter.copyWith(
        query: query.trim(),
      ),
      SearchFiltersChanged(filter: final applied) => applied.copyWith(
        query: state.filter.query,
      ),
    };
    if (filter.query.length < minQueryLength && !filter.hasFilters) {
      emit(
        state.copyWith(
          status: SearchStatus.idle,
          filter: filter,
          results: const [],
        ),
      );
      return;
    }
    // The previous results stay on screen until the new ones arrive, so
    // typing doesn't flash a spinner over them.
    emit(state.copyWith(status: SearchStatus.searching, filter: filter));
    // Text too short to search by, with filters: search by the filters.
    final asked = filter.query.length < minQueryLength
        ? filter.withoutQuery
        : filter;
    await emit.forEach<List<EventCardItem>>(
      _search(asked),
      onData: (results) => state.copyWith(
        status: SearchStatus.results,
        results: results,
        now: _clock.now(),
      ),
      onError: (_, _) =>
          state.copyWith(status: SearchStatus.failure, results: const []),
    );
  }

  Future<void> _onSaveToggled(
    SearchSaveToggled event,
    Emitter<SearchState> emit,
  ) async {
    final item = event.item;
    final result = await _setSaved(item.event.id, saved: !item.isSaved);
    if (result case Err(:final exception)) {
      emit(
        state.copyWith(
          message: exception.message,
          messageSerial: state.messageSerial + 1,
        ),
      );
    }
  }
}
