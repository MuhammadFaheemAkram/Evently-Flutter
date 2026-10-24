import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_details.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:evently/domain/repository/saved_event_repository.dart';
import 'package:injectable/injectable.dart';

/// Every cached event, with what the user did about it, kept current.
@injectable
class WatchEventCardsUseCase {
  const WatchEventCardsUseCase(this._catalog);

  final CatalogRepository _catalog;

  Stream<List<EventCardItem>> call() => _catalog.watchEventCards();
}

/// One event for its detail screen, kept current; `null` when it isn't
/// cached (a stale link).
@injectable
class WatchEventDetailsUseCase {
  const WatchEventDetailsUseCase(this._catalog);

  final CatalogRepository _catalog;

  Stream<EventDetails?> call(String eventId) =>
      _catalog.watchEventDetails(eventId);
}

/// The events you saved, soonest first, kept current. Works offline.
@injectable
class WatchSavedEventsUseCase {
  const WatchSavedEventsUseCase(this._saved);

  final SavedEventRepository _saved;

  Stream<List<EventCardItem>> call() => _saved.watch();
}

/// Saves or unsaves an event. Works offline.
@injectable
class SetEventSavedUseCase {
  const SetEventSavedUseCase(this._saved);

  final SavedEventRepository _saved;

  Future<Result<void>> call(String eventId, {required bool saved}) =>
      saved ? _saved.save(eventId) : _saved.unsave(eventId);
}
