import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// An event's sessions, day by day: a placeholder until Phase 5.
class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => EventDetailRoute(eventId: eventId).go(context),
        ),
        title: const Text('Agenda'),
      ),
      body: const EmptyStateView(
        icon: Icons.view_agenda_outlined,
        title: 'Agenda',
        message: 'Sessions, speakers, bookmarks and clashes arrive in Phase 5.',
      ),
    );
  }
}
