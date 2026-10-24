import 'package:evently/core/design_system/theme/app_radius.dart';
import 'package:evently/core/design_system/theme/category_palette.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:material_ui/material_ui.dart';

/// An event's banner: its category's color with the category's icon (and,
/// when [showLabel], its name). Evently shows no network images, so a
/// banner works offline and costs nothing.
///
/// Decorative: the card or screen around it says the category in words.
class EventBanner extends StatelessWidget {
  const EventBanner({
    super.key,
    required this.category,
    this.iconSize = 32,
    this.showLabel = false,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppRadius.medium),
    ),
  });

  final EventCategory category;
  final double iconSize;
  final bool showLabel;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = CategoryPalette.style(category.name, theme.brightness);
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.container,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: iconSize, color: style.onContainer),
              if (showLabel)
                Text(
                  category.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: style.onContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
