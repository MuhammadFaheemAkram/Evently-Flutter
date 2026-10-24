import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_tools_state.freezed.dart';

/// A Settings action that takes a moment.
enum SettingsTask {
  notifications,
  clearCache,
  resetDemo,
  publishUpdate,
  backgroundSync,
}

@freezed
abstract class SettingsToolsState with _$SettingsToolsState {
  const factory SettingsToolsState({
    /// The cities a user can choose, A to Z.
    @Default(<String>[]) List<String> cities,

    /// The action under way; the others wait.
    SettingsTask? running,

    /// "Simulate network failure".
    @Default(false) bool failingRequests,

    /// The system refused notifications when the user turned them on: only
    /// its settings can change that now.
    @Default(false) bool notificationsDenied,

    /// A one-time SnackBar; [messageSerial] makes each one distinct.
    String? message,
    @Default(0) int messageSerial,
  }) = _SettingsToolsState;
}
