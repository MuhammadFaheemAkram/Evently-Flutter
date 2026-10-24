import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:material_ui/material_ui.dart';

/// About: what Evently is, its version, the same app on other platforms,
/// and the open-source licenses.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _editions = [
    ('Android', 'Kotlin, Jetpack Compose, Room, WorkManager'),
    ('iOS', 'Swift, SwiftUI, SwiftData, BGTaskScheduler'),
    ('Flutter', 'Dart, material_ui, drift, workmanager (this app)'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = getIt<AppInfo>();
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const DiscoverRoute().go(context),
        ),
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Evently', style: theme.textTheme.headlineSmall),
                Text(
                  'Version ${info.versionLabel}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'An event app: discover events, save them, book a place, '
                  'keep your tickets and follow the agenda, even offline. An '
                  'open-source learning project.',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SectionHeader('The same app on other platforms'),
          for (final (platform, stack) in _editions)
            ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: Text(platform),
              subtitle: Text(stack),
            ),
          const SizedBox(height: AppSpacing.medium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: () => showLicensePage(
                  context: context,
                  applicationName: 'Evently',
                  applicationVersion: info.versionLabel,
                ),
                icon: const Icon(Icons.article_outlined),
                label: const Text('Open-source licenses'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
