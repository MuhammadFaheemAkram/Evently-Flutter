import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_state.freezed.dart';

/// Where the catalog fetch that opens Welcome stands.
enum CatalogStatus { loading, failed, ready }

/// How the user chose to start.
enum StartChoice { demo, fresh }

@freezed
abstract class WelcomeState with _$WelcomeState {
  const factory WelcomeState({
    /// The catalog is fetched first: its cities are the choices, and both
    /// starts need its events.
    @Default(CatalogStatus.loading) CatalogStatus catalog,

    /// The cities to choose from, A to Z (once [catalog] is ready).
    @Default(<String>[]) List<String> cities,

    /// The chosen city; `null` is "Anywhere".
    String? city,

    /// The start in progress, if any: every control waits for it.
    StartChoice? starting,

    /// Why the catalog or the demo couldn't be loaded. The matching button
    /// then reads "Try again".
    String? errorMessage,
  }) = _WelcomeState;

  const WelcomeState._();

  bool get isStarting => starting != null;

  /// Whether the user can choose a city and start.
  bool get canStart => catalog == CatalogStatus.ready && !isStarting;
}
