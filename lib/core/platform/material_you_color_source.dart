import 'package:dynamic_color/dynamic_color.dart';
import 'package:evently/domain/service/dynamic_color_source.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Material You's wallpaper colors, through `dynamic_color` (as in
/// DevJourney and Momentum).
///
/// **Android 12+ only.** iOS has no system palette to follow (its accent is
/// per app), so there the app keeps its own indigo and Settings doesn't
/// offer the switch.
///
/// Only the palette is taken from the plugin, not its ready-made
/// `ColorScheme`: that one is `package:flutter/material.dart`'s class, not
/// `material_ui`'s (conventions §11.55). The app builds its own scheme from
/// the wallpaper's primary color instead.
@LazySingleton(as: DynamicColorSource)
class MaterialYouColorSource implements DynamicColorSource {
  const MaterialYouColorSource();

  @override
  Future<int?> wallpaperColor() async {
    if (defaultTargetPlatform != TargetPlatform.android) return null;
    try {
      final palette = await DynamicColorPlugin.getCorePalette();
      return palette?.primary.get(40);
    } on Object {
      // No plugin (tests) or no palette (older Android): no dynamic color.
      return null;
    }
  }
}
