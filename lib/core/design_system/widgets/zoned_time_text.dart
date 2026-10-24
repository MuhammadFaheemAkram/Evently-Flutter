import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/user_time_zone.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:material_ui/material_ui.dart';

/// An in-person event's time on the venue's clock ("Sat 31 Oct,
/// 18:30–21:00 GMT"), and on the user's clock below it when the two read
/// differently ("Your time: Sat 31 Oct, 19:30–22:00 CET"). An online
/// event ([online]) is told on the user's clock only: they join from where
/// they are.
///
/// For an in-person event the poster's time comes first: it's what the
/// organizer, the venue and every other attendee say. Screen readers hear
/// the times in full words.
class ZonedTimeText extends StatelessWidget {
  const ZonedTimeText({super.key, required this.time, this.online = false});

  final EventTime time;
  final bool online;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final userZone = UserTimeZone.of(context);
    if (online) {
      return Text(
        EventFormats.range(time, use24HourFormat: use24, zone: userZone),
        style: theme.textTheme.bodyLarge,
        semanticsLabel: EventFormats.spokenRange(
          time,
          use24HourFormat: use24,
          zone: userZone,
        ),
      );
    }
    final differs = EventFormats.differsIn(time, userZone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          EventFormats.range(time, use24HourFormat: use24),
          style: theme.textTheme.bodyLarge,
          semanticsLabel: EventFormats.spokenRange(
            time,
            use24HourFormat: use24,
          ),
        ),
        if (differs)
          Text(
            'Your time: '
            '${EventFormats.range(time, use24HourFormat: use24, zone: userZone)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            semanticsLabel:
                'Your time: '
                '${EventFormats.spokenRange(time, use24HourFormat: use24, zone: userZone)}',
          ),
      ],
    );
  }
}
