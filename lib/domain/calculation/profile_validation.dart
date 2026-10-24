import 'package:characters/characters.dart';

/// The profile's rules, shared by the form (its field errors) and the use
/// case (which asks again before saving).
abstract final class ProfileRules {
  static const maxNameLength = 50;

  // Something@something.something, no spaces: catches typos, not every
  // address the RFC allows (a real backend would send a confirmation).
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Why [name] can't be saved, or `null`.
  static String? nameError(String name) {
    final length = name.trim().characters.length;
    if (length == 0) return 'Enter your name.';
    if (length > maxNameLength) {
      return 'Keep it to $maxNameLength characters.';
    }
    return null;
  }

  /// Why [email] can't be saved, or `null`.
  static String? emailError(String email) {
    final value = email.trim();
    if (value.isEmpty) return 'Enter your email.';
    if (!_email.hasMatch(value)) return 'Enter an email like name@example.com.';
    return null;
  }

  /// Why [url] can't be saved, or `null`. Empty is fine: the avatar is
  /// optional (and only a real backend would use it; the app shows
  /// initials).
  static String? avatarUrlError(String url) {
    final value = url.trim();
    if (value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.isScheme('https') || uri.host.isEmpty) {
      return 'Use an https:// address, or leave it empty.';
    }
    return null;
  }
}
