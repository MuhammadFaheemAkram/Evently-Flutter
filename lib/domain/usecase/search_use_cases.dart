import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/date_presets.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/domain/repository/recent_searches_repository.dart';
import 'package:evently/domain/repository/search_repository.dart';
import 'package:injectable/injectable.dart';

/// The upcoming events matching [EventFilter], kept current. The date
/// presets are resolved here, against the user's clock: "this weekend" is
/// the user's weekend.
@injectable
class SearchEventsUseCase {
  const SearchEventsUseCase(this._search, this._clock);

  final SearchRepository _search;
  final EventClock _clock;

  Stream<List<EventCardItem>> call(EventFilter filter) =>
      _search.watch(criteriaFor(filter, _clock));
}

@injectable
class WatchRecentSearchesUseCase {
  const WatchRecentSearchesUseCase(this._recent);

  final RecentSearchesRepository _recent;

  Stream<List<String>> call() => _recent.watch();
}

/// Remembers a search the user acted on: trimmed, and only when it's long
/// enough to have been a search.
@injectable
class SaveRecentSearchUseCase {
  const SaveRecentSearchUseCase(this._recent);

  /// Shorter text shows the recent searches instead of searching.
  static const minLength = 2;

  final RecentSearchesRepository _recent;

  Future<Result<void>> call(String query) async {
    final text = query.trim();
    if (text.length < minLength) return const Ok(null);
    return _recent.save(text);
  }
}

@injectable
class ClearRecentSearchesUseCase {
  const ClearRecentSearchesUseCase(this._recent);

  final RecentSearchesRepository _recent;

  Future<Result<void>> call() => _recent.clear();
}
