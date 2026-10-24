import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/data/mapper/event_card_mappers.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/search_criteria.dart';
import 'package:evently/domain/repository/search_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._events);

  final EventsDao _events;

  @override
  Stream<List<EventCardItem>> watch(SearchCriteria criteria) => _events
      .watchSearch(criteria)
      .map((rows) => [for (final row in rows) row.toDomain()]);
}
