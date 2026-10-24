import 'package:material_ui/material_ui.dart';

/// A round avatar with someone's initials ("Flutter London" → "FL").
/// Evently shows no network images; the name beside it says who it is, so
/// the avatar is decorative.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.radius = 24});

  final String name;
  final double radius;

  /// The first letters of the first two words, upper-case.
  static String initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words
        .take(2)
        .map((word) => String.fromCharCode(word.runes.first).toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: radius,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: Text(
          initialsOf(name),
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: radius * 0.75,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
