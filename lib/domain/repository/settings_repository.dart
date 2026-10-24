import 'package:evently/domain/model/app_settings.dart';

/// The device's preferences.
abstract interface class SettingsRepository {
  /// The settings now, synchronously: they were loaded before the first
  /// frame, so the router can decide where the app opens without waiting.
  AppSettings get current;

  /// The current settings on listen, then every change.
  Stream<AppSettings> watch();

  /// Applies [change] to the current settings, and saves what it changed.
  Future<void> update(AppSettings Function(AppSettings settings) change);
}
