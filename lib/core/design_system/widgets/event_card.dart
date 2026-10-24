import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/large_text.dart';
import 'package:evently/core/design_system/theme/app_radius.dart';
import 'package:evently/core/design_system/theme/app_spacing.dart';
import 'package:evently/core/design_system/user_time_zone.dart';
import 'package:evently/core/design_system/widgets/attendance_label.dart';
import 'package:evently/core/design_system/widgets/event_banner.dart';
import 'package:evently/core/design_system/widgets/save_button.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:material_ui/material_ui.dart';

/// An event in a list: its banner, title, start on the venue's clock,
/// place, price and how full it is, with Save and RSVP (or "Going").
///
/// [rsvpBlock] is why it can't be booked (`null`: it can). RSVP shows only
/// when it can; "Going" when you hold a ticket.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.item,
    required this.rsvpBlock,
    required this.onTap,
    required this.onToggleSaved,
    required this.onRsvp,
  });

  final EventCardItem item;
  final RsvpBlock? rsvpBlock;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;
  final VoidCallback onRsvp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = item.event;
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final attendance = AttendanceLabel(
      event: event,
      ended: rsvpBlock == RsvpBlock.ended,
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SaveButton(isSaved: item.isSaved, onPressed: onToggleSaved),
        if (item.isGoing)
          const Padding(
            padding: EdgeInsets.only(left: AppSpacing.xxSmall),
            child: GoingBadge(),
          )
        else if (rsvpBlock == null)
          FilledButton.tonal(onPressed: onRsvp, child: const Text('RSVP')),
      ],
    );
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.xxSmall,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: 64,
                    child: EventBanner(
                      category: event.category,
                      iconSize: 28,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppRadius.small),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xxSmall),
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
                        ),
                        Text(
                          EventFormats.place(event.location),
                          style: secondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          EventFormats.priceSummary(event),
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxSmall),
              if (context.prefersStackedLayout) ...[
                attendance,
                Align(alignment: Alignment.centerRight, child: actions),
              ] else
                Row(
                  children: [
                    Expanded(child: attendance),
                    actions,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
