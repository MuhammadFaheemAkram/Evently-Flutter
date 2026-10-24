import 'package:evently/core/common/result.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/start_use_cases.dart';
import 'package:evently/features/welcome/cubit/welcome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// First launch: fetch the catalog, choose a city, then explore with demo
/// data or start fresh.
///
/// It never navigates: a successful start saves the onboarded setting, and
/// the router's gate reacts to it.
@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(
    this._refreshCatalog,
    this._listCities,
    this._startWithDemo,
    this._startFresh,
  ) : super(const WelcomeState());

  final RefreshCatalogUseCase _refreshCatalog;
  final ListCitiesUseCase _listCities;
  final StartWithDemoUseCase _startWithDemo;
  final StartFreshUseCase _startFresh;

  var _fetching = false;

  /// Fetches the catalog (again, after a failure). A call while one runs,
  /// or once the catalog is ready, does nothing.
  Future<void> loadCatalog() async {
    if (_fetching || state.catalog == CatalogStatus.ready) return;
    _fetching = true;
    emit(state.copyWith(catalog: CatalogStatus.loading, errorMessage: null));
    final Result<int> result;
    final List<String> cities;
    try {
      result = await _refreshCatalog();
      cities = result is Ok ? await _listCities() : const [];
    } finally {
      _fetching = false;
    }
    if (isClosed) return;
    emit(switch (result) {
      Ok() => state.copyWith(catalog: CatalogStatus.ready, cities: cities),
      Err(:final exception) => state.copyWith(
        catalog: CatalogStatus.failed,
        errorMessage: exception.message,
      ),
    });
  }

  /// Chooses [city]; `null` is "Anywhere".
  void selectCity(String? city) {
    if (!state.canStart) return;
    emit(state.copyWith(city: city));
  }

  /// Loads the demo user (again, after a failure). A second tap while a
  /// start is running does nothing.
  Future<void> exploreDemo() async {
    if (!state.canStart) return;
    emit(state.copyWith(starting: StartChoice.demo, errorMessage: null));
    final result = await _startWithDemo(city: state.city);
    if (isClosed) return;
    emit(switch (result) {
      Ok() => state.copyWith(starting: null),
      Err(:final exception) => state.copyWith(
        starting: null,
        errorMessage: exception.message,
      ),
    });
  }

  Future<void> startFresh() async {
    if (!state.canStart) return;
    emit(state.copyWith(starting: StartChoice.fresh, errorMessage: null));
    await _startFresh(city: state.city);
    if (isClosed) return;
    emit(state.copyWith(starting: null));
  }
}
