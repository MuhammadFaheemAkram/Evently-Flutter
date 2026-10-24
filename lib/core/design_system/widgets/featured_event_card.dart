import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/theme/app_spacing.dart';
import 'package:evently/core/design_system/theme/category_palette.dart';
import 'package:evently/core/design_system/user_time_zone.dart';
import 'package:evently/core/design_system/widgets/attendance_label.dart';
import 'package:evently/core/design_system/widgets/event_banner.dart';
import 'package:evently/core/design_system/widgets/save_button.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:material_ui/material_ui.dart';

/// A large event card for a carousel: the banner on top (with Save), then
/// the title, start and place.
///
/// In a pager of fixed height the banner takes whatever the text leaves
/// ([fillHeight]); in a row that sizes itself, it has a fixed height.
class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleSaved,
    this.fillHeight = true,
  });

  /// The banner's height when it doesn't [fillHeight].
  static const bannerHeight = 88.0;

  final EventCardItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = item.event;
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final onBanner = CategoryPalette.style(
      event.category.name,
      theme.brightness,
    ).onContainer;
    final banner = Stack(
      fit: StackFit.expand,
      children: [
        EventBanner(
          category: event.category,
          iconSize: 40,
          showLabel: true,
          borderRadius: BorderRadius.zero,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SaveButton(
            isSaved: item.isSaved,
            onPressed: onToggleSaved,
            color: onBanner,
          ),
        ),
      ],
    );
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xSmall),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (fillHeight)
              Expanded(child: banner)
            else
              SizedBox(height: bannerHeight, child: banner),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    EventFormats.start(
                      event.time,
                      use24HourFormat: use24,
                      zone: EventFormats.zoneFor(
                        event,
                        UserTimeZone.of(context),
                      ),
                    ),
                    style: secondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    EventFormats.place(event.location),
                    style: secondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.isGoing) const GoingBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
