/// Where Material You colors come from: the wallpaper, on Android 12+.
abstract interface class DynamicColorSource {
  /// The wallpaper's main color (ARGB), or `null` where the device offers
  /// none (iOS, older Android).
  Future<int?> wallpaperColor();
}
