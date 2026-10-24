import 'dart:async';

import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_router.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/stream_listenable.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The root widget: themes, the router, and the work that lasts as long as
/// the app runs.
///
/// The app-wide `SettingsCubit` sits above `MaterialApp.router`: the theme
/// mode and dynamic color apply to every screen at once.
///
/// This `State` owns the router and the [StreamListenable] that lets it
/// follow the settings, and disposes both. The router is created once, not
/// in `build`: a new router on every rebuild would reset navigation.
///
/// While the app runs, it:
/// - keeps the notifications in step with the data
///   (`KeepNotificationsInSyncUseCase`), and again on every resume, after
///   reloading the settings the background isolate may have changed (a
///   permission revoked in the system settings);
/// - follows notification taps: a reminder opens its event, a confirmation
///   or a change alert its ticket, the summary Tickets. A tap that
///   *launched* the app arrives as [initialLocation].
class EventlyApp extends StatefulWidget {
  const EventlyApp({super.key, this.initialLocation});

  /// A notification's screen on a cold start, or a test's deep link. The
  /// app otherwise starts on Discover, and the first-launch gate redirects
  /// from there.
  final String? initialLocation;

  /// Where a notification's [target] opens the app on a cold start: an
  /// event's page, a ticket, or Tickets (`null`: no notification, the
  /// usual start).
  static String? locationFor(NotificationTarget? target) => switch (target) {
    OpenEvent(:final eventId) => EventDetailRoute(eventId: eventId).location,
    OpenTicket(:final ticketId) => TicketDetailRoute(
      ticketId: ticketId,
    ).location,
    OpenTickets() => const TicketsRoute().location,
    null => null,
  };

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
  final _subscriptions = <StreamSubscription<Object?>>[];
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _subscriptions.addAll([
      getIt<KeepNotificationsInSyncUseCase>()().listen((_) {}),
      getIt<NotificationInteractions>().taps.listen(_follow),
    ]);
    _lifecycle = AppLifecycleListener(onResume: _resumed);
  }

  Future<void> _resumed() async {
    await _settings.reload();
    await getIt<SyncNotificationsUseCase>()();
  }

  /// A tap while the app runs. The event and the ticket are pushed, so Back
  /// returns to wherever the user was; the summary switches to Tickets.
  void _follow(NotificationTarget target) {
    switch (target) {
      case OpenEvent(:final eventId):
        unawaited(_router.push(EventDetailRoute(eventId: eventId).location));
      case OpenTicket(:final ticketId):
        unawaited(_router.push(TicketDetailRoute(ticketId: ticketId).location));
      case OpenTickets():
        _router.go(const TicketsRoute().location);
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
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
