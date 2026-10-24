import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_router.dart';
import 'package:evently/core/navigation/placeholder_onboarding.dart';
import 'package:evently/di/injection.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The root widget: themes and the router.
///
/// This `State` owns the router and disposes it. The router is created once,
/// not in `build`: a new router on every rebuild would reset navigation.
/// Phase 6 adds the app-scoped `SettingsCubit` here, above
/// `MaterialApp.router`, for the theme mode and dynamic color.
class EventlyApp extends StatefulWidget {
  const EventlyApp({super.key, this.initialLocation});

  /// Lets tests start on a deep link. The app itself starts on Discover, and
  /// the first-launch gate redirects from there.
  final String? initialLocation;

  @override
  State<EventlyApp> createState() => _EventlyAppState();
}

class _EventlyAppState extends State<EventlyApp> {
  late final GoRouter _router = createAppRouter(
    onboarding: getIt<PlaceholderOnboarding>(),
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Evently',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
