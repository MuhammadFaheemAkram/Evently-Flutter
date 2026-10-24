import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/first_launch_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tab routes have their own paths', () {
    expect(const DiscoverRoute().location, '/discover');
    expect(const SearchRoute().location, '/search');
    expect(const SavedRoute().location, '/saved');
    expect(const TicketsRoute().location, '/tickets');
    expect(const ProfileRoute().location, '/profile');
  });

  test('screens above the tabs build their locations from typed data', () {
    expect(const EventDetailRoute(eventId: 'e1').location, '/events/e1');
    expect(const RsvpRoute(eventId: 'e1').location, '/events/e1/rsvp');
    expect(const AgendaRoute(eventId: 'e1').location, '/events/e1/agenda');
    expect(const TicketDetailRoute(ticketId: 't1').location, '/tickets/t1');
    expect(const OrganizerRoute(organizerId: 'o1').location, '/organizers/o1');
    expect(const FollowingRoute().location, '/following');
    expect(const ProfileEditRoute().location, '/profile/edit');
    expect(const SettingsRoute().location, '/settings');
    expect(const AboutRoute().location, '/about');
  });

  test('ids are encoded in the path', () {
    expect(
      const EventDetailRoute(eventId: 'a b/c').location,
      '/events/a%20b%2Fc',
    );
  });

  test("the gate's constants match the typed routes", () {
    expect(const WelcomeRoute().location, welcomePath);
    expect(const DiscoverRoute().location, discoverPath);
  });
}
