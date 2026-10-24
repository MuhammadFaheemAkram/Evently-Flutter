import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:material_ui/material_ui.dart';

/// Your tickets (a tab): a placeholder until Phase 5.
class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Tickets'),
      ),
      body: const EmptyStateView(
        icon: Icons.confirmation_number_outlined,
        title: 'Tickets',
        message: 'Your tickets, upcoming and past, arrive in Phase 5.',
      ),
    );
  }
}
