import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/search_criteria.dart';

/// Search, over the cache: it works offline, and finds what the cache holds.
abstract interface class SearchRepository {
  /// The upcoming events matching [criteria], soonest first, kept current
  /// (a save or a booking updates the results).
  Stream<List<EventCardItem>> watch(SearchCriteria criteria);
}
