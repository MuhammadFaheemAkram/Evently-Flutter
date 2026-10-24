import 'package:evently/core/common/result.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:injectable/injectable.dart';

/// Fetches the catalog into the cache; the number of events it holds.
/// Welcome runs it before anything else, Discover on pull to refresh and
/// the background sync on its schedule.
///
/// A refresh records the moves and cancellations of events you hold
/// tickets for; whichever refresh recorded them alerts them, at once
/// (`AlertCatalogChangesUseCase`), so a pull to refresh doesn't leave the
/// news for the next background sync.
@injectable
class RefreshCatalogUseCase {
  const RefreshCatalogUseCase(this._catalog, this._alertChanges);

  final CatalogRepository _catalog;
  final AlertCatalogChangesUseCase _alertChanges;

  Future<Result<int>> call() async {
    final result = await _catalog.refresh();
    if (result is Ok) await _alertChanges();
    return result;
  }
}

/// The cities a user can choose as theirs: those with in-person events in
/// the cache, A to Z.
@injectable
class ListCitiesUseCase {
  const ListCitiesUseCase(this._catalog);

  final CatalogRepository _catalog;

  Future<List<String>> call() => _catalog.cities();
}
