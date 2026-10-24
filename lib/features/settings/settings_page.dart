import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// Settings (from the drawer, and Profile): so far only About. Appearance,
/// dynamic color, preferred city, the data tools and the developer tools
/// arrive in Phase 6, notifications in Phase 7.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const ProfileRoute().go(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.medium),
            child: Text(
              'Appearance, your city and the data tools arrive in Phase 6, '
              'notifications in Phase 7.',
            ),
          ),
          const SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Evently'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => const AboutRoute().push<void>(context),
          ),
        ],
      ),
    );
  }
}
