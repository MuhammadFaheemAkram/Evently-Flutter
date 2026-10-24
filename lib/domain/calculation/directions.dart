import 'package:evently/domain/model/event.dart';

/// A maps link to [venue]: Apple Maps' web address on iOS ([appleMaps]),
/// Google Maps' everywhere else. Both are plain `https` links: the system
/// hands them to the maps app when there is one, or a browser.
Uri directionsTo(Venue venue, {required bool appleMaps}) {
  final place = '${venue.name}, ${venue.address}, ${venue.city}';
  return appleMaps
      ? Uri.https('maps.apple.com', '/', {'q': place})
      : Uri.https('www.google.com', '/maps/search/', {
          'api': '1',
          'query': place,
        });
}
