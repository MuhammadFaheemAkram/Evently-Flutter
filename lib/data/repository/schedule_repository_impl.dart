import 'package:clock/clock.dart';
import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/session_bookmarks_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/calculation/agenda_builder.dart';
import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/repository/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  const ScheduleRepositoryImpl(this._bookmarks, this._clock);

  final SessionBookmarksDao _bookmarks;
  final Clock _clock;

  @override
  Stream<Agenda?> watchAgenda(String eventId) =>
      _bookmarks.watchAgenda(eventId).map((found) {
        if (found == null) return null;
        final (event, sessions) = found;
        return Agenda(
          eventId: event.id,
          eventTitle: event.title,
          zone: event.timeZone,
          days: buildAgenda(
            [for (final (session, _) in sessions) session.toDomain()],
            bookmarked: {
              for (final (session, bookmarked) in sessions)
                if (bookmarked) session.id,
            },
            zone: event.timeZone,
          ),
        );
      });

  @override
  Future<Result<void>> setBookmarked(
    String sessionId, {
    required bool bookmarked,
  }) => guardWrite(
    'Bookmarking $sessionId',
    () => _bookmarks.setBookmarked(
      sessionId,
      bookmarked: bookmarked,
      at: _clock.now().toUtc(),
    ),
  );
}
