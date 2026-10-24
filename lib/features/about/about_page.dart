import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:material_ui/material_ui.dart';

/// About: what Evently is, and the open-source licenses. Phase 6 adds the
/// version and the editions on other platforms.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const DiscoverRoute().go(context),
        ),
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          Text('Evently', style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            'An event app: discover events, save them, book a place, keep '
            'your tickets and follow the agenda, even offline. An open-source '
            'learning project.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.large),
          OutlinedButton.icon(
            onPressed: () =>
                showLicensePage(context: context, applicationName: 'Evently'),
            icon: const Icon(Icons.article_outlined),
            label: const Text('Open-source licenses'),
          ),
        ],
      ),
    );
  }
}
