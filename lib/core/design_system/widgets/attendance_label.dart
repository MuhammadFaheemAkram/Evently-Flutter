import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/theme/app_colors.dart';
import 'package:evently/core/design_system/theme/app_spacing.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:material_ui/material_ui.dart';

/// How full an event is: "124 going · 26 places left", "3 places left"
/// (few: in the sold-out color, with an icon), "Sold out", or "124 went"
/// once it's over ([ended]). An event the organizer cancelled says only
/// that: its places no longer matter.
class AttendanceLabel extends StatelessWidget {
  const AttendanceLabel({
    super.key,
    required this.event,
    required this.ended,
    this.style,
  });

  /// At most this many places left counts as "few".
  static const fewPlaces = 10;

  final Event event;
  final bool ended;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodySmall;
    final soldOutColor = context.appColors.soldOut;
    if (event.status == EventStatus.cancelled) {
      return _IconLabel(
        icon: Icons.event_busy,
        text: 'Cancelled',
        style: base?.copyWith(
          color: context.appColors.cancelled,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    if (ended) {
      return Text('${event.attendeeCount} went', style: base);
    }
    if (event.isSoldOut) {
      return _IconLabel(
        icon: Icons.block,
        text: 'Sold out',
        style: base?.copyWith(color: soldOutColor, fontWeight: FontWeight.w600),
      );
    }
    final left = event.placesLeft;
    if (left <= fewPlaces) {
      return _IconLabel(
        icon: Icons.local_fire_department_outlined,
        text: EventFormats.placesLeft(left),
        style: base?.copyWith(color: soldOutColor, fontWeight: FontWeight.w600),
      );
    }
    return Text(
      '${event.attendeeCount} going · ${EventFormats.placesLeft(left)}',
      style: base,
    );
  }
}

/// The organizer's word on an event, with an icon: "Moved" (the start
/// shown is the new one) or "Cancelled". Nothing for a scheduled event.
class EventStatusBadge extends StatelessWidget {
  const EventStatusBadge({super.key, required this.status});

  final EventStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = Theme.of(context).textTheme.labelLarge;
    return switch (status) {
      EventStatus.scheduled => const SizedBox.shrink(),
      EventStatus.moved => _IconLabel(
        icon: Icons.update,
        text: 'Moved',
        style: style?.copyWith(color: colors.moved),
      ),
      EventStatus.cancelled => _IconLabel(
        icon: Icons.event_busy,
        text: 'Cancelled',
        style: style?.copyWith(color: colors.cancelled),
      ),
    };
  }
}

/// "You're going" on a card: a check icon and the word, never the color
/// alone.
class GoingBadge extends StatelessWidget {
  const GoingBadge({super.key, this.text = 'Going'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _IconLabel(
      icon: Icons.check_circle,
      text: text,
      style: Theme.of(context).textTheme.labelLarge
          ?.copyWith(color: context.appColors.going),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({required this.icon, required this.text, this.style});

  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.textScalerOf(context).scale(16);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size, color: style?.color),
        const SizedBox(width: AppSpacing.xxSmall),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}
