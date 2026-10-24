import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// One event ([eventId]): a placeholder until Phase 3. Opened by a link (or,
/// later, a notification) it has nothing to go back to, so it offers Close.
class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const DiscoverRoute().go(context),
        ),
        title: const Text('Event'),
      ),
      body: const EmptyStateView(
        icon: Icons.event_outlined,
        title: 'Event',
        message: 'Its time, place, tickets and agenda arrive in Phase 3.',
      ),
    );
  }
}
