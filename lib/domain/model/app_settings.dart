import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// The device's preferences. Phases 6 and 7 add the appearance and the
/// notifications.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// Whether the user has left Welcome (with the demo, or fresh).
    @Default(false) bool onboarded,

    /// The city Discover leads with; `null` is "Anywhere".
    String? preferredCity,
  }) = _AppSettings;
}
