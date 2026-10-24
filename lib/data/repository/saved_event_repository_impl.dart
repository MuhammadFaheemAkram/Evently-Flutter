import 'package:clock/clock.dart';
import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/saved_events_dao.dart';
import 'package:evently/domain/repository/saved_event_repository.dart';
import 'package:injectable/injectable.dart';

/// Saving writes straight to the database, with no server round trip: a
/// save is the user's own note, unlike a booking, which only the server can
/// grant (Phase 5).
@LazySingleton(as: SavedEventRepository)
class SavedEventRepositoryImpl implements SavedEventRepository {
  const SavedEventRepositoryImpl(this._saved, this._clock);

  final SavedEventsDao _saved;
  final Clock _clock;

  @override
  Future<Result<void>> save(String eventId) => guardWrite(
    'Saving an event',
    () => _saved.save(eventId, _clock.now().toUtc()),
  );

  @override
  Future<Result<void>> unsave(String eventId) =>
      guardWrite('Removing a saved event', () => _saved.unsave(eventId));
}
