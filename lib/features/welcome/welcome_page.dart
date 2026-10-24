import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/features/welcome/cubit/welcome_cubit.dart';
import 'package:evently/features/welcome/cubit/welcome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WelcomeCubit>()..loadCatalog(),
      child: const WelcomeView(),
    );
  }
}

/// First launch: the catalog is fetched, then the user picks a city and
/// explores with demo data or starts fresh.
///
/// Nothing here navigates: the choice is saved, and the router's
/// first-launch gate moves the user to Discover. Both fetches go through
/// the fake API, so they take a moment and can fail: the reason appears
/// above the buttons, and the button that failed reads "Try again".
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WelcomeCubit>().state;
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
                  ...switch (state.catalog) {
                    CatalogStatus.loading => const [_LoadingCatalog()],
                    CatalogStatus.failed => [
                      _ErrorCard(message: state.errorMessage ?? ''),
                      const SizedBox(height: AppSpacing.medium),
                      FilledButton(
                        onPressed: context.read<WelcomeCubit>().loadCatalog,
                        child: const Text(
                          'Try again',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    CatalogStatus.ready => [_StartChoices(state: state)],
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// While the catalog loads. A live region, so a screen reader hears it.
class _LoadingCatalog extends StatelessWidget {
  const _LoadingCatalog();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Column(
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Loading events',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// The city, then the two ways to start.
class _StartChoices extends StatelessWidget {
  const _StartChoices({required this.state});

  final WelcomeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WelcomeCubit>();
    final theme = Theme.of(context);
    final enabled = state.canStart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text('Your city', style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.xxSmall),
        Text(
          'Discover leads with events there. You can change it later in '
          'Settings.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Wrap(
          spacing: AppSpacing.xSmall,
          runSpacing: AppSpacing.xSmall,
          children: [
            for (final city in <String?>[null, ...state.cities])
              ChoiceChip(
                label: Text(city ?? 'Anywhere'),
                selected: state.city == city,
                onSelected: enabled ? (_) => cubit.selectCity(city) : null,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        if (state.errorMessage case final message?) ...[
          _ErrorCard(message: message),
          const SizedBox(height: AppSpacing.medium),
        ],
        FilledButton(
          onPressed: enabled ? cubit.exploreDemo : null,
          child: _Label(
            text: state.errorMessage == null
                ? 'Explore with demo data'
                : 'Try again',
            busyText: 'Loading the demo',
            busy: state.starting == StartChoice.demo,
          ),
        ),
        const SizedBox(height: AppSpacing.xSmall),
        TextButton(
          onPressed: enabled ? cubit.startFresh : null,
          child: _Label(
            text: 'Start fresh',
            busyText: 'Starting',
            busy: state.starting == StartChoice.fresh,
          ),
        ),
      ],
    );
  }
}

/// Why a fetch failed. A live region, so a screen reader announces it when
/// it appears.
class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.errorContainer,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, color: scheme.onErrorContainer),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  message,
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A button's label, or a small spinner while its start runs.
class _Label extends StatelessWidget {
  const _Label({
    required this.text,
    required this.busyText,
    required this.busy,
  });

  final String text;
  final String busyText;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    // Centred: at large text the label wraps inside the full-width button.
    if (!busy) return Text(text, textAlign: TextAlign.center);
    return Semantics(
      label: busyText,
      child: const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }
}
