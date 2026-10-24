// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $welcomeRoute,
  $mainShellRoute,
  $eventDetailRoute,
  $ticketDetailRoute,
  $organizerRoute,
  $followingRoute,
  $profileEditRoute,
  $settingsRoute,
  $aboutRoute,
];

RouteBase get $welcomeRoute => GoRouteData.$route(
  path: '/welcome',
  hasOverriddenOnExit: false,
  factory: $WelcomeRoute._fromState,
);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
  factory: $MainShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: DiscoverBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/discover',
          hasOverriddenOnExit: false,
          factory: $DiscoverRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: SearchBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/search',
          hasOverriddenOnExit: false,
          factory: $SearchRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: SavedBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/saved',
          hasOverriddenOnExit: false,
          factory: $SavedRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: TicketsBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/tickets',
          hasOverriddenOnExit: false,
          factory: $TicketsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: ProfileBranch.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/profile',
          hasOverriddenOnExit: false,
          factory: $ProfileRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

mixin $DiscoverRoute on GoRouteData {
  static DiscoverRoute _fromState(GoRouterState state) => const DiscoverRoute();

  @override
  String get location => GoRouteData.$location('/discover');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SearchRoute on GoRouteData {
  static SearchRoute _fromState(GoRouterState state) => const SearchRoute();

  @override
  String get location => GoRouteData.$location('/search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SavedRoute on GoRouteData {
  static SavedRoute _fromState(GoRouterState state) => const SavedRoute();

  @override
  String get location => GoRouteData.$location('/saved');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TicketsRoute on GoRouteData {
  static TicketsRoute _fromState(GoRouterState state) => const TicketsRoute();

  @override
  String get location => GoRouteData.$location('/tickets');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $eventDetailRoute => GoRouteData.$route(
  path: '/events/:eventId',
  hasOverriddenOnExit: false,
  factory: $EventDetailRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'rsvp',
      hasOverriddenOnExit: false,
      factory: $RsvpRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'agenda',
      hasOverriddenOnExit: false,
      factory: $AgendaRoute._fromState,
    ),
  ],
);

mixin $EventDetailRoute on GoRouteData {
  static EventDetailRoute _fromState(GoRouterState state) =>
      EventDetailRoute(eventId: state.pathParameters['eventId']!);

  EventDetailRoute get _self => this as EventDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/events/${Uri.encodeComponent(_self.eventId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RsvpRoute on GoRouteData {
  static RsvpRoute _fromState(GoRouterState state) =>
      RsvpRoute(eventId: state.pathParameters['eventId']!);

  RsvpRoute get _self => this as RsvpRoute;

  @override
  String get location => GoRouteData.$location(
    '/events/${Uri.encodeComponent(_self.eventId)}/rsvp',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AgendaRoute on GoRouteData {
  static AgendaRoute _fromState(GoRouterState state) =>
      AgendaRoute(eventId: state.pathParameters['eventId']!);

  AgendaRoute get _self => this as AgendaRoute;

  @override
  String get location => GoRouteData.$location(
    '/events/${Uri.encodeComponent(_self.eventId)}/agenda',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $ticketDetailRoute => GoRouteData.$route(
  path: '/tickets/:ticketId',
  hasOverriddenOnExit: false,
  factory: $TicketDetailRoute._fromState,
);

mixin $TicketDetailRoute on GoRouteData {
  static TicketDetailRoute _fromState(GoRouterState state) =>
      TicketDetailRoute(ticketId: state.pathParameters['ticketId']!);

  TicketDetailRoute get _self => this as TicketDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/tickets/${Uri.encodeComponent(_self.ticketId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $organizerRoute => GoRouteData.$route(
  path: '/organizers/:organizerId',
  hasOverriddenOnExit: false,
  factory: $OrganizerRoute._fromState,
);

mixin $OrganizerRoute on GoRouteData {
  static OrganizerRoute _fromState(GoRouterState state) =>
      OrganizerRoute(organizerId: state.pathParameters['organizerId']!);

  OrganizerRoute get _self => this as OrganizerRoute;

  @override
  String get location => GoRouteData.$location(
    '/organizers/${Uri.encodeComponent(_self.organizerId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $followingRoute => GoRouteData.$route(
  path: '/following',
  hasOverriddenOnExit: false,
  factory: $FollowingRoute._fromState,
);

mixin $FollowingRoute on GoRouteData {
  static FollowingRoute _fromState(GoRouterState state) =>
      const FollowingRoute();

  @override
  String get location => GoRouteData.$location('/following');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileEditRoute => GoRouteData.$route(
  path: '/profile/edit',
  hasOverriddenOnExit: false,
  factory: $ProfileEditRoute._fromState,
);

mixin $ProfileEditRoute on GoRouteData {
  static ProfileEditRoute _fromState(GoRouterState state) =>
      const ProfileEditRoute();

  @override
  String get location => GoRouteData.$location('/profile/edit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute => GoRouteData.$route(
  path: '/settings',
  hasOverriddenOnExit: false,
  factory: $SettingsRoute._fromState,
);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aboutRoute => GoRouteData.$route(
  path: '/about',
  hasOverriddenOnExit: false,
  factory: $AboutRoute._fromState,
);

mixin $AboutRoute on GoRouteData {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  @override
  String get location => GoRouteData.$location('/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
