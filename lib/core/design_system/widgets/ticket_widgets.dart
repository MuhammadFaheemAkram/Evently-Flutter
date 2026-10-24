import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/theme/app_colors.dart';
import 'package:evently/core/design_system/theme/app_radius.dart';
import 'package:evently/core/design_system/theme/app_spacing.dart';
import 'package:evently/core/design_system/user_time_zone.dart';
import 'package:evently/core/design_system/widgets/event_banner.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A ticket's state in words, with an icon: never the color alone.
class TicketStatusLabel extends StatelessWidget {
  const TicketStatusLabel({super.key, required this.status});

  final TicketStatus status;

  static String textOf(TicketStatus status) => switch (status) {
    TicketStatus.confirmed => 'Confirmed',
    TicketStatus.moved => 'Moved',
    TicketStatus.cancelledByOrganizer => 'Cancelled by the organizer',
    TicketStatus.cancelledByYou => 'Cancelled by you',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (icon, color) = switch (status) {
      TicketStatus.confirmed => (Icons.check_circle, colors.going),
      TicketStatus.moved => (Icons.update, colors.moved),
      TicketStatus.cancelledByOrganizer => (Icons.event_busy, colors.cancelled),
      TicketStatus.cancelledByYou => (
        Icons.cancel_outlined,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    };
    final style = Theme.of(context).textTheme.labelLarge
        ?.copyWith(color: color);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: MediaQuery.textScalerOf(context).scale(16),
          color: color,
        ),
        const SizedBox(width: AppSpacing.xxSmall),
        Flexible(child: Text(textOf(status), style: style)),
      ],
    );
  }
}

/// A ticket in a list: its event, when, the ticket type and its state.
class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.item, required this.onTap});

  final TicketItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = item.event;
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 56,
                child: EventBanner(
                  category: event.category,
                  iconSize: 24,
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
                    Text(item.ticket.type.label, style: secondary),
                    const SizedBox(height: AppSpacing.xxSmall),
                    TicketStatusLabel(status: item.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A ticket's QR code, of its [code]: what the door scans.
///
/// Always black square modules on white, in both themes: scanners expect
/// it. `QrImageView`'s own defaults are black squares; a style passed with
/// only a color would turn them round. The white comes from here, not from
/// a theme: `qr_flutter` builds on `flutter/material.dart`, which doesn't
/// see `material_ui`'s (conventions §11.55).
/// Screen readers hear the code instead of an unlabelled image.
class TicketQr extends StatelessWidget {
  const TicketQr({super.key, required this.code, this.size = 220});

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'QR code for ticket $code',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.small),
            child: QrImageView(
              data: code,
              size: size,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
