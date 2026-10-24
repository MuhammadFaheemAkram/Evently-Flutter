import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// An organizer's profile ([organizerId]): a placeholder until Phase 6.
class OrganizerPage extends StatelessWidget {
  const OrganizerPage({super.key, required this.organizerId});

  final String organizerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const DiscoverRoute().go(context),
        ),
        title: const Text('Organizer'),
      ),
      body: const EmptyStateView(
        icon: Icons.groups_outlined,
        title: 'Organizer',
        message: 'The organizer, their events and Follow arrive in Phase 6.',
      ),
    );
  }
}
