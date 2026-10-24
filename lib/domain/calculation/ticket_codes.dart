import 'dart:math';

/// Ticket codes: "EVT-" and two groups of four characters, the last a check
/// character over the seven before it.
///
/// - The alphabet leaves out 0, O, 1 and I: read aloud at a door, or typed
///   from a screenshot, they're too easy to confuse.
/// - The check character is Luhn mod N over the 32-character alphabet:
///   it catches every mistyped character, and nearly every swap of two
///   neighbours, before a lookup. (A plain weighted sum mod 32 doesn't:
///   with an even weight, two characters 16 apart look the same.)
abstract final class TicketCodes {
  static const alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';

  static const _prefix = 'EVT-';
  static final _shape = RegExp(
    r'^EVT-([2-9A-HJ-NP-Z]{4})-([2-9A-HJ-NP-Z]{4})$',
  );

  /// A new random code. The server makes them; nothing on the device does.
  static String generate(Random random) {
    final body = String.fromCharCodes([
      for (var i = 0; i < 7; i++)
        alphabet.codeUnitAt(random.nextInt(alphabet.length)),
    ]);
    final full = '$body${_check(body)}';
    return '$_prefix${full.substring(0, 4)}-${full.substring(4)}';
  }

  /// Whether [code] is shaped right and its check character matches.
  static bool isValid(String code) {
    final match = _shape.firstMatch(code);
    if (match == null) return false;
    final chars = '${match[1]}${match[2]}';
    return _luhnSum(chars, doubleFirst: false) % alphabet.length == 0;
  }

  /// The character that makes the Luhn mod N sum of [body] + it zero.
  static String _check(String body) {
    const n = alphabet.length;
    // From the right, every other character is doubled, starting with the
    // last one of the body (the check character itself isn't doubled).
    final sum = _luhnSum(body, doubleFirst: true);
    return alphabet[(n - sum % n) % n];
  }

  static int _luhnSum(String chars, {required bool doubleFirst}) {
    const n = alphabet.length;
    var sum = 0;
    var double = doubleFirst;
    for (var i = chars.length - 1; i >= 0; i--) {
      var addend = alphabet.indexOf(chars[i]);
      if (double) {
        addend *= 2;
        // "Digits" of the doubled value in base n: keeps each position's
        // values a permutation, so no change goes unseen.
        addend = addend ~/ n + addend % n;
      }
      sum += addend;
      double = !double;
    }
    return sum;
  }
}
