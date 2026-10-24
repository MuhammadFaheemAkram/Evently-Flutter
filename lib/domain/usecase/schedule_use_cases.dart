import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/repository/schedule_repository.dart';
import 'package:injectable/injectable.dart';

/// An event's agenda, by its days, with bookmarks and clashes, kept
/// current.
@injectable
class WatchAgendaUseCase {
  const WatchAgendaUseCase(this._schedule);

  final ScheduleRepository _schedule;

  Stream<Agenda?> call(String eventId) => _schedule.watchAgenda(eventId);
}

/// Bookmarks a session, or removes its bookmark.
@injectable
class SetSessionBookmarkedUseCase {
  const SetSessionBookmarkedUseCase(this._schedule);

  final ScheduleRepository _schedule;

  Future<Result<void>> call(String sessionId, {required bool bookmarked}) =>
      _schedule.setBookmarked(sessionId, bookmarked: bookmarked);
}
