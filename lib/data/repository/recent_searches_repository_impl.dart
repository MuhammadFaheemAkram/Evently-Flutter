import 'package:clock/clock.dart';
import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/recent_searches_dao.dart';
import 'package:evently/domain/repository/recent_searches_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RecentSearchesRepository)
class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  const RecentSearchesRepositoryImpl(this._recent, this._clock);

  final RecentSearchesDao _recent;
  final Clock _clock;

  @override
  Stream<List<String>> watch() => _recent.watch();

  @override
  Future<Result<void>> save(String query) => guardWrite(
    'Saving a recent search',
    () => _recent.save(query, _clock.now().toUtc()),
  );

  @override
  Future<Result<void>> clear() =>
      guardWrite('Clearing recent searches', _recent.clear);
}
