import 'package:evently/core/navigation/first_launch_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? redirect({required bool onboarded, required String to}) =>
      firstLaunchRedirect(onboarded: onboarded, location: Uri.parse(to));

  group('before the first start', () {
    test('every location goes to Welcome', () {
      expect(redirect(onboarded: false, to: '/discover'), welcomePath);
      expect(redirect(onboarded: false, to: '/events/e1'), welcomePath);
      expect(redirect(onboarded: false, to: '/events/e1/rsvp'), welcomePath);
    });

    test('Welcome itself stays', () {
      expect(redirect(onboarded: false, to: '/welcome'), isNull);
    });
  });

  group('after', () {
    test('Welcome goes to Discover', () {
      expect(redirect(onboarded: true, to: '/welcome'), discoverPath);
    });

    test('everything else stays where it is, query included', () {
      expect(redirect(onboarded: true, to: '/tickets'), isNull);
      expect(redirect(onboarded: true, to: '/search?q=jazz'), isNull);
    });
  });
}
