import 'package:material_ui/material_ui.dart';

/// How a category is drawn: a [container] fill (an event's banner, its
/// chip) and an [onContainer] color for the icon or text on it, plus the
/// category's [icon].
@immutable
final class CategoryStyle {
  const CategoryStyle({
    required this.container,
    required this.onContainer,
    required this.icon,
  });

  final Color container;
  final Color onContainer;
  final IconData icon;
}

/// The eight event categories' looks, by the category's name (the API's
/// value, so a palette tweak never needs a migration).
///
/// Evently shows no network images: an event's banner is its category's
/// color with its icon, which works offline and needs no image cache (see
/// the spec's Divergence Decisions).
///
/// Each tone comes from Material's own tonal system: a [ColorScheme] seeded
/// with the category's color gives its `primaryContainer` and
/// `onPrimaryContainer`, a pair designed to be readable together in light
/// and dark (a test checks AA). The schemes are built once and cached.
abstract final class CategoryPalette {
  static const seeds = <String, Color>{
    'technology': Color(0xFF1E88E5),
    'business': Color(0xFF455A64),
    'design': Color(0xFF8E24AA),
    'sports': Color(0xFF43A047),
    'education': Color(0xFF3949AB),
    'music': Color(0xFFD81B60),
    'community': Color(0xFFF4511E),
    'health': Color(0xFF00897B),
  };

  static const _icons = <String, IconData>{
    'technology': Icons.memory_outlined,
    'business': Icons.business_center_outlined,
    'design': Icons.palette_outlined,
    'sports': Icons.sports_soccer_outlined,
    'education': Icons.school_outlined,
    'music': Icons.music_note_outlined,
    'community': Icons.groups_outlined,
    'health': Icons.self_improvement_outlined,
  };

  /// The names, in the order the category row shows them.
  static List<String> get names => seeds.keys.toList();

  static final _cache = <(String, Brightness), CategoryStyle>{};

  /// The style for [name] in [brightness]; an unknown name falls back to the
  /// first category.
  static CategoryStyle style(String name, Brightness brightness) =>
      _cache.putIfAbsent((name, brightness), () {
        final known = seeds.containsKey(name) ? name : seeds.keys.first;
        final scheme = ColorScheme.fromSeed(
          seedColor: seeds[known]!,
          brightness: brightness,
        );
        return CategoryStyle(
          container: scheme.primaryContainer,
          onContainer: scheme.onPrimaryContainer,
          icon: _icons[known]!,
        );
      });
}
