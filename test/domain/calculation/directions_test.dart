import 'package:evently/domain/calculation/directions.dart';
import 'package:evently/domain/model/event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const venue = Venue(
    name: 'Jazz Vaults',
    address: '12 Old Street & Co',
    city: 'London',
  );

  test('Apple Maps on iOS, with the place encoded', () {
    final url = directionsTo(venue, appleMaps: true);

    expect(url.scheme, 'https');
    expect(url.host, 'maps.apple.com');
    expect(url.queryParameters['q'], 'Jazz Vaults, 12 Old Street & Co, London');
    expect(url.toString(), contains('%26'));
  });

  test('Google Maps elsewhere', () {
    final url = directionsTo(venue, appleMaps: false);

    expect(url.scheme, 'https');
    expect(url.host, 'www.google.com');
    expect(url.path, '/maps/search/');
    expect(url.queryParameters, {
      'api': '1',
      'query': 'Jazz Vaults, 12 Old Street & Co, London',
    });
  });
}
