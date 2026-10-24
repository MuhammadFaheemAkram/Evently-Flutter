import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/usecase/background_use_cases.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:evently/domain/usecase/settings_use_cases.dart';
import 'package:evently/features/settings/cubit/settings_tools_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Settings' actions: the notification switch and its permission, the
/// cities to choose from, the data tools and the developer tools. The
/// appearance, the city and the notification preferences themselves are
/// the app-wide `SettingsCubit`'s.
@injectable
class SettingsToolsCubit extends Cubit<SettingsToolsState> {
  SettingsToolsCubit(
    this._listCities,
    this._clearCache,
    this._resetDemoData,
    this._developer,
    this._setNotificationsEnabled,
    this._openNotificationSettings,
    this._runBackgroundSync,
    this._previewPlan,
  ) : super(const SettingsToolsState());

  final ListCitiesUseCase _listCities;
  final ClearCacheUseCase _clearCache;
  final ResetDemoDataUseCase _resetDemoData;
  final DeveloperToolsUseCase _developer;
  final SetNotificationsEnabledUseCase _setNotificationsEnabled;
  final OpenNotificationSettingsUseCase _openNotificationSettings;
  final RunBackgroundSyncUseCase _runBackgroundSync;
  final PreviewNotificationPlanUseCase _previewPlan;

  Future<void> load() async {
    emit(state.copyWith(failingRequests: _developer.failingRequests));
    final cities = await _listCities();
    if (isClosed) return;
    emit(state.copyWith(cities: cities));
  }

  /// Turns notifications on (the system asks for permission the first
  /// time) or off. Denied, the switch stays off and the card explains how
  /// to allow them.
  Future<void> setNotificationsEnabled({required bool enabled}) async {
    if (state.running != null) return;
    emit(state.copyWith(running: SettingsTask.notifications));
    final applied = await _setNotificationsEnabled(enabled: enabled);
    if (isClosed) return;
    emit(state.copyWith(running: null, notificationsDenied: !applied));
  }

  Future<void> openNotificationSettings() => _openNotificationSettings();

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

  /// What the OS runs every few hours, run now, in the app's isolate.
  Future<void> runBackgroundSync() =>
      _run(SettingsTask.backgroundSync, () async {
        final report = await _runBackgroundSync();
        return switch (report.refresh) {
          Err(:final exception) =>
            'Sync failed: ${exception.message} '
                '${_planned(report.notifications)}',
          Ok() =>
            'Synced. ${_alerts(report.alerted)} '
                '${_planned(report.notifications)}',
        };
      });

  /// The plan as it stands, for the developer's sheet.
  Future<NotificationPlanPreview> previewPlan() => _previewPlan();

  static String _alerts(int count) => switch (count) {
    0 => 'No change alerts.',
    1 => '1 change alert.',
    _ => '$count change alerts.',
  };

  static String _planned(Result<NotificationSyncReport> result) =>
      switch (result) {
        Ok(value: NotificationSyncReport(enabled: false)) =>
          'Notifications are off.',
        Ok(:final value) =>
          '${value.planned} '
              '${value.planned == 1 ? 'notification' : 'notifications'} '
              'planned.',
        Err() => "Notifications couldn't be planned.",
      };

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
