import 'package:evently/core/common/result.dart';

/// The event catalog: fetched from the API, cached in drift.
abstract interface class CatalogRepository {
  /// Fetches the catalog and writes it over the cache in one transaction;
  /// the number of events it holds. On any failure the cache is as it was.
  Future<Result<int>> refresh();

  /// The cities with in-person events in the cache, A to Z.
  Future<List<String>> cities();
}
