import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/first_launch_redirect.dart';
import 'package:evently/core/navigation/placeholder_onboarding.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Creates the app's [GoRouter], gated by the first launch.
///
/// - [onboarding] is a `Listenable`, so the router re-runs
///   [firstLaunchRedirect] whenever it changes. Starting needs no navigation
///   code: the gate moves the user to Discover.
/// - This is a factory rather than a global: the app widget owns one router
///   for its lifetime, and every widget test starts from a fresh one.
GoRouter createAppRouter({
  required PlaceholderOnboarding onboarding,
  String? initialLocation,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? const DiscoverRoute().location,
    routes: $appRoutes,
    refreshListenable: onboarding,
    redirect: (context, state) => firstLaunchRedirect(
      onboarded: onboarding.onboarded,
      location: state.uri,
    ),
    errorBuilder: (context, state) =>
        _NotFoundPage(location: state.uri.toString()),
  );
}

/// Shown when a location matches no route, e.g. a mistyped deep link.
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: EmptyStateView(
        icon: Icons.explore_off_outlined,
        title: 'Page not found',
        message: 'Nothing lives at "$location".',
        action: FilledButton.tonal(
          onPressed: () => const DiscoverRoute().go(context),
          child: const Text('Go to Discover'),
        ),
      ),
    );
  }
}
