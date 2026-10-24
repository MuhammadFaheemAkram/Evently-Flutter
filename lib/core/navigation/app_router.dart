import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/first_launch_redirect.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Creates the app's [GoRouter], gated by the first launch.
///
/// - The gate reads [settings] synchronously (they were loaded before the
///   first frame), so the app opens straight on Welcome or Discover.
/// - [refreshListenable] notifies on every settings change, so the router
///   re-runs [firstLaunchRedirect]. Starting needs no navigation code: the
///   gate moves the user to Discover.
/// - This is a factory rather than a global: the app widget owns one router
///   for its lifetime, and every widget test starts from a fresh one.
GoRouter createAppRouter({
  required SettingsRepository settings,
  required Listenable refreshListenable,
  String? initialLocation,
}) {
  return GoRouter(
    initialLocation: initialLocation ?? const DiscoverRoute().location,
    routes: $appRoutes,
    refreshListenable: refreshListenable,
    redirect: (context, state) => firstLaunchRedirect(
      onboarded: settings.current.onboarded,
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
