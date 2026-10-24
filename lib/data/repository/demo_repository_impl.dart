import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/data/repository/api_guard.dart';
import 'package:evently/domain/repository/demo_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DemoRepository)
class DemoRepositoryImpl implements DemoRepository {
  const DemoRepositoryImpl(this._api, this._userData);

  final EventlyApi _api;
  final UserDataDao _userData;

  /// Fetch → check and map → write, like the catalog. A demo row pointing
  /// at an event the cache doesn't hold breaks a foreign key, and the whole
  /// write is undone.
  @override
  Future<Result<void>> loadDemoUser() =>
      guardApiCall('Loading the demo user', () async {
        final data = (await _api.fetchDemoUser()).toUserData();
        await _userData.replaceAll(data.toRows());
      });
}
