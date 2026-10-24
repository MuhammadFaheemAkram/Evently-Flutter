import 'package:evently/core/design_system/theme/app_colors.dart';
import 'package:evently/core/design_system/theme/app_radius.dart';
import 'package:material_ui/material_ui.dart';

/// Builds the app's Material 3 light and dark themes.
///
/// Screens style themselves through `Theme.of(context)`, never with hard-coded
/// colors. The default scheme comes from one seed (an indigo-violet);
/// [fromScheme] takes any scheme, so the wallpaper-based "dynamic color" of
/// Android 12+ can replace it in Phase 6 without touching a screen.
abstract final class AppTheme {
  static const Color seedColor = Color(0xFF5B4FE9);

  static ThemeData light() => fromScheme(_seeded(Brightness.light));

  static ThemeData dark() => fromScheme(_seeded(Brightness.dark));

  static ColorScheme _seeded(Brightness brightness) => ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    // `fidelity` keeps the primary color close to the seed; the default
    // variant (`tonalSpot`) would noticeably mute it.
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  );

  static ThemeData fromScheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      extensions: [
        if (colorScheme.brightness == Brightness.light)
          AppColors.light
        else
          AppColors.dark,
      ],
      cardTheme: const CardThemeData(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
        ),
      ),
      chipTheme: const ChipThemeData(shape: StadiumBorder()),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.small)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
