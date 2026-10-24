import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:material_ui/material_ui.dart';

/// Search (a tab): a placeholder until Phase 4.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Search'),
      ),
      body: const EmptyStateView(
        icon: Icons.search,
        title: 'Search',
        message: 'Search by title, organizer, venue or city, with filters, arrives in Phase 4.',
      ),
    );
  }
}
