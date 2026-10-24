import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/repository/api_guard.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._api, this._catalog);

  final EventlyApi _api;
  final CatalogDao _catalog;

  /// Fetch → check and map → write. The checks run before the write, so
  /// damaged data never reaches the cache, and a failure at any step leaves
  /// the cache as it was: offline, the app keeps showing it.
  @override
  Future<Result<int>> refresh() =>
      guardApiCall('Refreshing the catalog', () async {
        final catalog = (await _api.fetchCatalog()).toCatalog();
        await _catalog.upsertCatalog(catalog.toRows());
        return catalog.events.length;
      });

  @override
  Future<List<String>> cities() => _catalog.cities();
}
