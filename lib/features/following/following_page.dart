import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// The organizers you follow (from the drawer): a placeholder until Phase 6.
class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const DiscoverRoute().go(context),
        ),
        title: const Text('Following'),
      ),
      body: const EmptyStateView(
        icon: Icons.favorite_border,
        title: 'Following',
        message: 'The organizers you follow arrive in Phase 6.',
      ),
    );
  }
}
