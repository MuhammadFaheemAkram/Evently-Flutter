import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/placeholder_onboarding.dart';
import 'package:evently/di/injection.dart';
import 'package:material_ui/material_ui.dart';

/// First launch: explore with demo data, or start fresh.
///
/// Neither button navigates. Each records the choice, and the router's
/// first-launch gate moves the user to Discover. In Phase 1 both only set the
/// in-memory [PlaceholderOnboarding]; Phase 2 adds the preferred city,
/// fetches the catalog first (with a progress indicator and a retry) and
/// saves the choice.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = getIt<PlaceholderOnboarding>();
    return WelcomeView(
      onExploreDemo: onboarding.complete,
      onStartFresh: onboarding.complete,
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({
    super.key,
    required this.onExploreDemo,
    required this.onStartFresh,
  });

  final VoidCallback onExploreDemo;
  final VoidCallback onStartFresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: AppIconSize.large * 1.5,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'Evently',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  Text(
                    'Find events worth going to: save them, book your place, '
                    'keep your tickets and follow the agenda.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xLarge),
                  FilledButton(
                    onPressed: onExploreDemo,
                    child: const Text('Explore with demo data'),
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  TextButton(
                    onPressed: onStartFresh,
                    child: const Text('Start fresh'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
