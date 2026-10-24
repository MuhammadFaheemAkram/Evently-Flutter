import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// The appearance the user chose. "System" follows the device.
enum AppThemeMode {
  system('System'),
  light('Light'),
  dark('Dark');

  const AppThemeMode(this.label);

  final String label;
}

/// The device's preferences. Phase 7 adds the notifications.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// Whether the user has left Welcome (with the demo, or fresh).
    @Default(false) bool onboarded,

    /// The city Discover leads with; `null` is "Anywhere".
    String? preferredCity,
    @Default(AppThemeMode.system) AppThemeMode themeMode,

    /// Colors from the wallpaper (Android 12+). On by default, as Material
    /// You apps are; ignored where the device has none.
    @Default(true) bool dynamicColor,
  }) = _AppSettings;
}
