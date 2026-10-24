import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:material_ui/material_ui.dart';

/// Saved events (a tab): a placeholder until Phase 4.
class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Saved'),
      ),
      body: const EmptyStateView(
        icon: Icons.bookmark_border,
        title: 'Saved',
        message: 'The events you save, available offline, arrive in Phase 4.',
      ),
    );
  }
}
