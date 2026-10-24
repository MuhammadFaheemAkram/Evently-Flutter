import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_router.dart';
import 'package:evently/core/navigation/stream_listenable.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The root widget: themes and the router.
///
/// The app-wide `SettingsCubit` sits above `MaterialApp.router`: the theme
/// mode and dynamic color apply to every screen at once.
///
/// This `State` owns the router and the [StreamListenable] that lets it
/// follow the settings, and disposes both. The router is created once, not
/// in `build`: a new router on every rebuild would reset navigation.
class EventlyApp extends StatefulWidget {
  const EventlyApp({super.key, this.initialLocation});

  /// Lets tests start on a deep link. The app itself starts on Discover, and
  /// the first-launch gate redirects from there.
  final String? initialLocation;

  @override
  State<EventlyApp> createState() => _EventlyAppState();
}

class _EventlyAppState extends State<EventlyApp> {
  final _settings = getIt<SettingsRepository>();
  late final _settingsChanges = StreamListenable(_settings.watch());
  late final GoRouter _router = createAppRouter(
    settings: _settings,
    refreshListenable: _settingsChanges,
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    _settingsChanges.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.dynamicSeed != current.dynamicSeed ||
            previous.settings.themeMode != current.settings.themeMode,
        builder: (context, state) {
          final seed = state.dynamicSeed;
          return MaterialApp.router(
            title: 'Evently',
            debugShowCheckedModeBanner: false,
            theme: seed == null
                ? AppTheme.light()
                : AppTheme.fromSeed(Color(seed), Brightness.light),
            darkTheme: seed == null
                ? AppTheme.dark()
                : AppTheme.fromSeed(Color(seed), Brightness.dark),
            themeMode: switch (state.settings.themeMode) {
              AppThemeMode.system => ThemeMode.system,
              AppThemeMode.light => ThemeMode.light,
              AppThemeMode.dark => ThemeMode.dark,
            },
            routerConfig: _router,
            builder: (context, child) => UserTimeZone(
              location: getIt<EventClock>().local,
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
