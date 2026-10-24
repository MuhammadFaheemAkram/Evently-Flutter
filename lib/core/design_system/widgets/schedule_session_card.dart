import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/theme/app_colors.dart';
import 'package:evently/core/design_system/theme/app_spacing.dart';
import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:material_ui/material_ui.dart';

/// A session in an agenda: its slot on the venue's clock, title, speaker
/// and room, a bookmark, and the bookmarked sessions it clashes with.
class ScheduleSessionCard extends StatelessWidget {
  const ScheduleSessionCard({
    super.key,
    required this.item,
    required this.zone,
    required this.onToggleBookmark,
  });

  final AgendaSession item;

  /// The event's zone: its times are the venue's.
  final String zone;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = item.session;
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final clashes = item.clashesWith;
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.xxSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.small,
          AppSpacing.small,
          0,
          AppSpacing.small,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    EventFormats.slot(
                      EventTime(
                        start: session.start,
                        end: session.end,
                        zone: zone,
                      ),
                      use24HourFormat: use24,
                    ),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(session.title, style: theme.textTheme.titleMedium),
                  Text(
                    '${session.speaker} · ${session.room}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (clashes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxSmall),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: MediaQuery.textScalerOf(context).scale(16),
                            color: context.appColors.moved,
                          ),
                          const SizedBox(width: AppSpacing.xxSmall),
                          Expanded(
                            child: Text(
                              'Clashes with '
                              '${clashes.map((s) => s.title).join(', ')}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.appColors.moved,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: item.isBookmarked
                  ? 'Remove bookmark: ${session.title}'
                  : 'Bookmark: ${session.title}',
              isSelected: item.isBookmarked,
              icon: const Icon(Icons.star_border),
              selectedIcon: const Icon(Icons.star),
              onPressed: onToggleBookmark,
            ),
          ],
        ),
      ),
    );
  }
}
