import 'package:evently/domain/model/time_of_day_value.dart';
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

/// How long before an event its reminder rings.
enum ReminderLead {
  fifteenMinutes(Duration(minutes: 15), '15 minutes'),
  oneHour(Duration(hours: 1), '1 hour'),
  threeHours(Duration(hours: 3), '3 hours'),
  oneDay(Duration(days: 1), '1 day');

  const ReminderLead(this.duration, this.label);

  final Duration duration;

  /// "1 hour", as in "1 hour before it starts".
  final String label;
}

/// The device's preferences.
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

    /// Off until the user turns them on, so the system's permission prompt
    /// comes with a reason. Reads "on" only while the system allows them:
    /// a sync that finds the permission gone turns it off.
    @Default(false) bool notificationsEnabled,
    @Default(ReminderLead.oneHour) ReminderLead reminderLead,

    /// "Today: Flutter London at 18:30, and 1 more", at [summaryTime] on
    /// days with events you're going to.
    @Default(true) bool summaryEnabled,

    /// The user's local time.
    @Default(TimeOfDayValue.eightAm) TimeOfDayValue summaryTime,
  }) = _AppSettings;
}
