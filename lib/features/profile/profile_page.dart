import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:material_ui/material_ui.dart';

/// Profile (the last tab): a placeholder until Phase 6, with its two ways
/// out already in place: Edit profile and Settings.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => const SettingsRoute().push<void>(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.medium),
            child: Text(
              'Your name, email and counts of tickets, saved events and '
              'followed organizers arrive in Phase 6.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('Edit profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => const ProfileEditRoute().push<void>(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => const SettingsRoute().push<void>(context),
          ),
        ],
      ),
    );
  }
}
