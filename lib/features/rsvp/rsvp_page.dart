import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:material_ui/material_ui.dart';

/// Booking a place at [eventId], as a full-screen dialog: a placeholder until
/// Phase 5.
///
/// Its Close button is always there (an app bar adds one only when it can
/// pop), and for a deep link with nothing underneath it goes to the event
/// instead of popping the router's last page (conventions §11.47).
class RsvpPage extends StatelessWidget {
  const RsvpPage({super.key, required this.eventId});

  final String eventId;

  void _close(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      EventDetailRoute(eventId: eventId).go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: () => _close(context)),
        title: const Text('RSVP'),
      ),
      body: const EmptyStateView(
        icon: Icons.how_to_reg_outlined,
        title: 'RSVP',
        message: 'Choosing a ticket type and booking it arrive in Phase 5.',
      ),
    );
  }
}
