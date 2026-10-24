import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/core/database/daos/reminders_dao.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/event_card_mappers.dart';
import 'package:evently/data/repository/api_guard.dart';
import 'package:evently/domain/calculation/catalog_diff.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_details.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(
    this._api,
    this._catalog,
    this._events,
    this._reminders,
    this._clock,
  );

  /// Event detail previews this many sessions.
  static const agendaPreviewLength = 3;

  final EventlyApi _api;
  final CatalogDao _catalog;
  final EventsDao _events;
  final RemindersDao _reminders;
  final EventClock _clock;

  /// Fetch → check and map → write, noticing what changed. The checks run
  /// before the write, so damaged data never reaches the cache, and a
  /// failure at any step leaves the cache as it was: offline, the app keeps
  /// showing it.
  ///
  /// The write is **one transaction**: read the cache's versions, upsert
  /// the catalog, mark what's gone cancelled, compare ([diffCatalog]) and
  /// record the changes to events the user holds tickets for. A change is
  /// recorded once because the next refresh compares against a cache that
  /// already has it; and the comparison and the write can't be split by a
  /// crash or by the other isolate's sync, which would record a change
  /// twice or never.
  @override
  Future<Result<int>> refresh() =>
      guardApiCall('Refreshing the catalog', () async {
        final catalog = (await _api.fetchCatalog()).toCatalog();
        await _catalog.transaction(() async {
          final before = await _catalog.versions();
          await _catalog.upsertCatalog(catalog.toRows());
          await _catalog.cancelMissing({
            for (final event in catalog.events) event.id,
          });
          final diff = diffCatalog(before, await _catalog.versions());
          final changes = changesToRecord(
            diff,
            await _reminders.ticketedEventIds(),
          );
          if (changes.isNotEmpty) {
            await _reminders.recordChanges(changes, at: _clock.now());
          }
        });
        return catalog.events.length;
      });

  @override
  Future<Result<int>> clearCache() =>
      guardWrite('Clearing the cache', _catalog.clearUnowned);

  @override
  Future<List<String>> cities() => _catalog.cities();

  @override
  Stream<List<EventCardItem>> watchEventCards() => _events.watchCards().map(
    (rows) => [for (final row in rows) row.toDomain()],
  );

  @override
  Stream<EventDetails?> watchEventDetails(String eventId) =>
      _events.watchCard(eventId).asyncMap((row) async {
        if (row == null) return null;
        final organizer = await _events.organizer(row.event.organizerId);
        final (sessions, count) = await _events.agendaPreview(
          eventId,
          limit: agendaPreviewLength,
        );
        return EventDetails(
          item: row.toDomain(),
          // The foreign key guarantees the organizer.
          organizer: organizer!.toDomain(),
          agendaPreview: [for (final session in sessions) session.toDomain()],
          sessionCount: count,
          ticketId: row.activeTicketId,
        );
      });
}
