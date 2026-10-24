import 'package:evently/core/common/result.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/settings_use_cases.dart';
import 'package:evently/features/settings/cubit/settings_tools_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Settings' actions: the cities to choose from, the data tools and the
/// developer tools. The appearance and the city themselves are the
/// app-wide `SettingsCubit`'s.
@injectable
class SettingsToolsCubit extends Cubit<SettingsToolsState> {
  SettingsToolsCubit(
    this._listCities,
    this._clearCache,
    this._resetDemoData,
    this._developer,
  ) : super(const SettingsToolsState());

  final ListCitiesUseCase _listCities;
  final ClearCacheUseCase _clearCache;
  final ResetDemoDataUseCase _resetDemoData;
  final DeveloperToolsUseCase _developer;

  Future<void> load() async {
    emit(state.copyWith(failingRequests: _developer.failingRequests));
    final cities = await _listCities();
    if (isClosed) return;
    emit(state.copyWith(cities: cities));
  }

  Future<void> clearCache() => _run(SettingsTask.clearCache, () async {
    final result = await _clearCache();
    return switch (result) {
      Ok(:final value) =>
        'Cleared $value cached ${value == 1 ? 'event' : 'events'}. Yours '
            'stay; pull to refresh Discover for the rest.',
      Err(:final exception) => exception.message,
    };
  });

  Future<void> resetDemoData() => _run(SettingsTask.resetDemo, () async {
    final result = await _resetDemoData();
    return switch (result) {
      Ok() => 'The demo data is back.',
      Err(:final exception) => exception.message,
    };
  });

  void setFailingRequests({required bool fail}) {
    _developer.setFailingRequests(fail: fail);
    emit(state.copyWith(failingRequests: fail));
  }

  Future<void> publishCatalogUpdate() =>
      _run(SettingsTask.publishUpdate, () async {
        final summary = await _developer.publishCatalogUpdate();
        return 'Published: $summary. Pull to refresh to see it.';
      });

  /// Runs [task] unless another is running, and says what came of it.
  Future<void> _run(SettingsTask task, Future<String> Function() work) async {
    if (state.running != null) return;
    emit(state.copyWith(running: task));
    final message = await work();
    if (isClosed) return;
    emit(
      state.copyWith(
        running: null,
        message: message,
        messageSerial: state.messageSerial + 1,
      ),
    );
  }
}
