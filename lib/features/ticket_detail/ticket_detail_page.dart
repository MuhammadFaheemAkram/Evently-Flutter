import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// One ticket ([ticketId]): a placeholder until Phase 5.
class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const TicketsRoute().go(context),
        ),
        title: const Text('Ticket'),
      ),
      body: const EmptyStateView(
        icon: Icons.qr_code_2,
        title: 'Ticket',
        message: 'The ticket\'s QR code and its event arrive in Phase 5.',
      ),
    );
  }
}
