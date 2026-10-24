import 'package:evently/domain/calculation/profile_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('name', () {
    test('required', () {
      expect(ProfileRules.nameError(''), 'Enter your name.');
      expect(ProfileRules.nameError('   '), 'Enter your name.');
    });

    test('50 characters as a reader counts them; 51 is too many', () {
      expect(ProfileRules.nameError('a' * 50), isNull);
      expect(ProfileRules.nameError('a' * 51), isNotNull);
      expect(ProfileRules.nameError('👩‍👩‍👧' * 50), isNull);
    });
  });

  group('email', () {
    test('required, and shaped like one', () {
      expect(ProfileRules.emailError(''), 'Enter your email.');
      for (final bad in [
        'sara',
        'sara@',
        '@example.com',
        'sara@example',
        'sa ra@x.com',
      ]) {
        expect(ProfileRules.emailError(bad), isNotNull, reason: bad);
      }
      expect(ProfileRules.emailError(' sara.ahmed@example.com '), isNull);
    });
  });

  group('avatar URL', () {
    test('optional', () {
      expect(ProfileRules.avatarUrlError(''), isNull);
      expect(ProfileRules.avatarUrlError('  '), isNull);
    });

    test('https only, with a host', () {
      expect(ProfileRules.avatarUrlError('https://example.com/a.png'), isNull);
      for (final bad in [
        'http://example.com/a.png',
        'example.com',
        'https://',
      ]) {
        expect(ProfileRules.avatarUrlError(bad), isNotNull, reason: bad);
      }
    });
  });
}
