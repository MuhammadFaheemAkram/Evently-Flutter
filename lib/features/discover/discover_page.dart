import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:material_ui/material_ui.dart';

/// Discover (the first tab): a placeholder until Phase 3.
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Discover'),
      ),
      body: const EmptyStateView(
        icon: Icons.explore_outlined,
        title: 'Discover',
        message: 'Featured events, events in your city and what\'s coming up arrive in Phase 3.',
      ),
    );
  }
}
