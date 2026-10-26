import 'package:evently/features/about/about_page.dart';
import 'package:evently/features/agenda/agenda_page.dart';
import 'package:evently/features/discover/discover_page.dart';
import 'package:evently/features/event_detail/event_detail_page.dart';
import 'package:evently/features/following/following_page.dart';
import 'package:evently/features/organizer/organizer_page.dart';
import 'package:evently/features/profile/profile_page.dart';
import 'package:evently/features/profile_edit/profile_edit_page.dart';
import 'package:evently/features/rsvp/rsvp_page.dart';
import 'package:evently/features/saved/saved_page.dart';
import 'package:evently/features/search/search_page.dart';
import 'package:evently/features/settings/settings_page.dart';
import 'package:evently/features/shell/main_shell.dart';
import 'package:evently/features/ticket_detail/ticket_detail_page.dart';
import 'package:evently/features/tickets/tickets_page.dart';
import 'package:evently/features/welcome/welcome_page.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

part 'app_routes.g.dart';

// Typed routes: every destination is a class, and `go_router_builder`
// generates its path parsing, `location` getter and `go`/`push` helpers. A
// typo or a missing parameter is a compile error instead of a runtime "page
// not found".
//
// The tree has three parts:
// 1. Welcome, shown until the user has started (first launch);
// 2. the tab shell: Discover, Search, Saved, Tickets, Profile;
// 3. root-level screens, pushed *above* the shell: an event with its RSVP
//    flow and agenda, a ticket, an organizer, and the drawer's destinations
//    (Following, Settings, About).

// ---------------------------------------------------------------------------
// 1. Welcome

@TypedGoRoute<WelcomeRoute>(path: '/welcome')
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomePage();
}

// ---------------------------------------------------------------------------
// 2. The tab shell

/// `StatefulShellRoute` gives every tab its own Navigator and keeps inactive
/// tabs alive in an IndexedStack, so switching tabs preserves each tab's
/// state (a search, its filters, a scroll position).
@TypedStatefulShellRoute<MainShellRoute>(
  branches: [
    TypedStatefulShellBranch<DiscoverBranch>(
      routes: [TypedGoRoute<DiscoverRoute>(path: '/discover')],
    ),
    TypedStatefulShellBranch<SearchBranch>(
      routes: [TypedGoRoute<SearchRoute>(path: '/search')],
    ),
    TypedStatefulShellBranch<SavedBranch>(
      routes: [TypedGoRoute<SavedRoute>(path: '/saved')],
    ),
    TypedStatefulShellBranch<TicketsBranch>(
      routes: [TypedGoRoute<TicketsRoute>(path: '/tickets')],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [TypedGoRoute<ProfileRoute>(path: '/profile')],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainShell(navigationShell: navigationShell);
  }
}

// A named navigator key per tab makes each back stack addressable (and
// readable in debugging tools).

class DiscoverBranch extends StatefulShellBranchData {
  const DiscoverBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'discoverTab');
}

class SearchBranch extends StatefulShellBranchData {
  const SearchBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'searchTab');
}

class SavedBranch extends StatefulShellBranchData {
  const SavedBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'savedTab');
}

class TicketsBranch extends StatefulShellBranchData {
  const TicketsBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'ticketsTab');
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profileTab');
}

class DiscoverRoute extends GoRouteData with $DiscoverRoute {
  const DiscoverRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DiscoverPage();
}

class SearchRoute extends GoRouteData with $SearchRoute {
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SearchPage();
}

class SavedRoute extends GoRouteData with $SavedRoute {
  const SavedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SavedPage();
}

class TicketsRoute extends GoRouteData with $TicketsRoute {
  const TicketsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TicketsPage();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

// ---------------------------------------------------------------------------
// 3. Root-level screens
//
// Declared at the top level, so they live in the *root* Navigator: pushing
// one covers the tab bar, and Back (or the iOS swipe) returns to the tab it
// came from with its state intact. An event opens from Discover, Search,
// Saved, a ticket, an organizer and a notification, so one route beats a
// copy per tab.

/// `/events/:eventId`: an event, with its RSVP flow and agenda as children,
/// so a link to either opens with the event underneath and Close returns to
/// it.
@TypedGoRoute<EventDetailRoute>(
  path: '/events/:eventId',
  routes: [
    TypedGoRoute<RsvpRoute>(path: 'rsvp'),
    TypedGoRoute<AgendaRoute>(path: 'agenda'),
  ],
)
class EventDetailRoute extends GoRouteData with $EventDetailRoute {
  const EventDetailRoute({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EventDetailPage(eventId: eventId);
}

/// `/events/:eventId/rsvp`: booking as a full-screen dialog (it slides up and
/// has a Close button), Material's counterpart of an iOS sheet.
class RsvpRoute extends GoRouteData with $RsvpRoute {
  const RsvpRoute({required this.eventId});

  final String eventId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage<void>(
        key: state.pageKey,
        fullscreenDialog: true,
        child: RsvpPage(eventId: eventId),
      );
}

/// `/events/:eventId/agenda`: the event's sessions, day by day.
class AgendaRoute extends GoRouteData with $AgendaRoute {
  const AgendaRoute({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AgendaPage(eventId: eventId);
}

/// `/tickets/:ticketId`: one ticket with its QR code. (The Tickets tab is
/// `/tickets`.)
@TypedGoRoute<TicketDetailRoute>(path: '/tickets/:ticketId')
class TicketDetailRoute extends GoRouteData with $TicketDetailRoute {
  const TicketDetailRoute({required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TicketDetailPage(ticketId: ticketId);
}

/// `/organizers/:organizerId`.
@TypedGoRoute<OrganizerRoute>(path: '/organizers/:organizerId')
class OrganizerRoute extends GoRouteData with $OrganizerRoute {
  const OrganizerRoute({required this.organizerId});

  final String organizerId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      OrganizerPage(organizerId: organizerId);
}

/// `/following` (from the drawer): the organizers you follow.
@TypedGoRoute<FollowingRoute>(path: '/following')
class FollowingRoute extends GoRouteData with $FollowingRoute {
  const FollowingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FollowingPage();
}

/// `/profile/edit`: the profile form as a full-screen dialog. (The Profile
/// tab is `/profile`.)
@TypedGoRoute<ProfileEditRoute>(path: '/profile/edit')
class ProfileEditRoute extends GoRouteData with $ProfileEditRoute {
  const ProfileEditRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage<void>(
        key: state.pageKey,
        fullscreenDialog: true,
        child: const ProfileEditPage(),
      );
}

/// `/settings` (from the drawer, and Profile).
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

/// `/about` (from the drawer, and Settings).
@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AboutPage();
}
