import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_details.dart';

/// The event catalog: fetched from the API, cached in drift. Screens watch
/// the cache; only [refresh] talks to the API.
abstract interface class CatalogRepository {
  /// Fetches the catalog and writes it over the cache in one transaction,
  /// recording the moves and cancellations of events the user holds tickets
  /// for (for the change alerts); the number of events it holds. On any
  /// failure the cache is as it was.
  Future<Result<int>> refresh();

  /// Deletes the cached events nothing of the user's points at; how many
  /// went. The next refresh fetches them again.
  Future<Result<int>> clearCache();

  /// The cities with in-person events in the cache, A to Z.
  Future<List<String>> cities();

  /// Every cached event with what the user did about it, soonest first; a
  /// new list after every change (a refresh, a save, a booking).
  Stream<List<EventCardItem>> watchEventCards();

  /// One event with its organizer and the start of its agenda, or `null`
  /// when it isn't cached.
  Stream<EventDetails?> watchEventDetails(String eventId);
}
