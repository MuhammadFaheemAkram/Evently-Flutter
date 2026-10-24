import 'package:material_ui/material_ui.dart';

/// Event-state colors that Material's [ColorScheme] has no slot for.
///
/// A [ThemeExtension] travels inside [ThemeData], so the light and dark
/// variants switch automatically (and animate via [lerp]) when the theme
/// changes. Widgets ask for an *intent* (`going`, `soldOut`) instead of
/// hard-coding raw colors.
///
/// All are text and icon colors: they sit on the page and on cards, so each
/// must reach WCAG AA (4.5:1) against those surfaces in both themes (checked
/// by a test). Color is never the only signal: "Going" also has a check
/// icon and the word, "Sold out" its own icon.
@immutable
final class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.going,
    required this.soldOut,
    required this.moved,
    required this.cancelled,
  });

  /// You hold a ticket: "Going", a confirmed booking.
  final Color going;

  /// No places left, or only a few ("3 places left").
  final Color soldOut;

  /// The organizer changed the event's time.
  final Color moved;

  /// The event is off, or you cancelled your place.
  final Color cancelled;

  static const light = AppColors(
    going: Color(0xFF146C2E),
    soldOut: Color(0xFF9C4400),
    moved: Color(0xFF7A5900),
    cancelled: Color(0xFFB3261E),
  );

  static const dark = AppColors(
    going: Color(0xFF86D993),
    soldOut: Color(0xFFFFB68C),
    moved: Color(0xFFF2C14E),
    cancelled: Color(0xFFFF9C92),
  );

  @override
  AppColors copyWith({
    Color? going,
    Color? soldOut,
    Color? moved,
    Color? cancelled,
  }) {
    return AppColors(
      going: going ?? this.going,
      soldOut: soldOut ?? this.soldOut,
      moved: moved ?? this.moved,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      going: Color.lerp(going, other.going, t)!,
      soldOut: Color.lerp(soldOut, other.soldOut, t)!,
      moved: Color.lerp(moved, other.moved, t)!,
      cancelled: Color.lerp(cancelled, other.cancelled, t)!,
    );
  }
}

/// Shorthand for `Theme.of(context).extension<AppColors>()!`.
extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
