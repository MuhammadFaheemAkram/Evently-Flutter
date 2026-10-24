import 'dart:async';

import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:evently/domain/usecase/settings_use_cases.dart';
import 'package:evently/features/settings/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// The settings, app-wide: provided above `MaterialApp.router`, so the
/// theme mode and dynamic color apply to every screen at once, and Settings
/// reads and changes them (as in DevJourney and Momentum).
///
/// It starts from the settings loaded before the first frame, so the theme
/// never flashes the wrong mode.
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._settings,
    this._updateThemeMode,
    this._updateDynamicColor,
    this._updatePreferredCity,
    this._updateReminderLead,
    this._updateSummary,
    DeviceColors deviceColors,
  ) : super(
        SettingsState(settings: _settings.current, deviceColors: deviceColors),
      );

  final SettingsRepository _settings;
  final UpdateThemeModeUseCase _updateThemeMode;
  final UpdateDynamicColorUseCase _updateDynamicColor;
  final UpdatePreferredCityUseCase _updatePreferredCity;
  final UpdateReminderLeadUseCase _updateReminderLead;
  final UpdateSummaryUseCase _updateSummary;

  StreamSubscription<AppSettings>? _changes;

  void load() {
    _changes ??= _settings.watch().listen(
      (settings) => emit(state.copyWith(settings: settings)),
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) => _updateThemeMode(mode);

  Future<void> setDynamicColor({required bool enabled}) =>
      _updateDynamicColor(enabled: enabled);

  Future<void> setPreferredCity(String? city) => _updatePreferredCity(city);

  Future<void> setReminderLead(ReminderLead lead) => _updateReminderLead(lead);

  /// The daily summary on or off, or its time.
  Future<void> setSummary({bool? enabled, TimeOfDayValue? time}) =>
      _updateSummary(enabled: enabled, time: time);

  @override
  Future<void> close() async {
    await _changes?.cancel();
    return super.close();
  }
}
