import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_details.dart';

/// The event catalog: fetched from the API, cached in drift. Screens watch
/// the cache; only [refresh] talks to the API.
abstract interface class CatalogRepository {
  /// Fetches the catalog and writes it over the cache in one transaction;
  /// the number of events it holds. On any failure the cache is as it was.
  Future<Result<int>> refresh();

  /// The cities with in-person events in the cache, A to Z.
  Future<List<String>> cities();

  /// Every cached event with what the user did about it, soonest first; a
  /// new list after every change (a refresh, a save, a booking).
  Stream<List<EventCardItem>> watchEventCards();

  /// One event with its organizer and the start of its agenda, or `null`
  /// when it isn't cached.
  Stream<EventDetails?> watchEventDetails(String eventId);
}
