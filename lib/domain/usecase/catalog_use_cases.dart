import 'package:evently/core/common/result.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:injectable/injectable.dart';

/// Fetches the catalog into the cache; the number of events it holds.
/// Welcome runs it before anything else, Discover on pull to refresh
/// (Phase 3) and the background sync on its schedule (Phase 7).
@injectable
class RefreshCatalogUseCase {
  const RefreshCatalogUseCase(this._catalog);

  final CatalogRepository _catalog;

  Future<Result<int>> call() => _catalog.refresh();
}

/// The cities a user can choose as theirs: those with in-person events in
/// the cache, A to Z.
@injectable
class ListCitiesUseCase {
  const ListCitiesUseCase(this._catalog);

  final CatalogRepository _catalog;

  Future<List<String>> call() => _catalog.cities();
}
