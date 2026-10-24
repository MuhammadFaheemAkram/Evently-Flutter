import 'package:evently/core/design_system/formatting/event_formats.dart';
import 'package:evently/core/design_system/widgets/initials_avatar.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:material_ui/material_ui.dart';

/// An organizer in a list or on an event: initials, name, followers and
/// events. Tap opens the organizer.
class OrganizerCard extends StatelessWidget {
  const OrganizerCard({super.key, required this.organizer, this.onTap});

  final Organizer organizer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final events = organizer.eventsCount;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: InitialsAvatar(name: organizer.name),
        title: Text(organizer.name),
        subtitle: Text(
          '${EventFormats.followers(organizer.followers)} · '
          '$events ${events == 1 ? 'event' : 'events'}',
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
