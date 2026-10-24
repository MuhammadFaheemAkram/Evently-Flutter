import 'dart:math';

import 'package:evently/domain/calculation/ticket_codes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated codes are valid, shaped EVT-XXXX-XXXX', () {
    final random = Random(7);
    for (var i = 0; i < 500; i++) {
      final code = TicketCodes.generate(random);
      expect(
        code,
        matches(RegExp(r'^EVT-[2-9A-HJ-NP-Z]{4}-[2-9A-HJ-NP-Z]{4}$')),
      );
      expect(TicketCodes.isValid(code), isTrue, reason: code);
    }
  });

  test("the demo's codes are valid", () {
    for (final code in [
      'EVT-7KQ2-M9XH',
      'EVT-H4TW-8RCU',
      'EVT-P3VN-6ZEC',
      'EVT-B8DS-5LUF',
    ]) {
      expect(TicketCodes.isValid(code), isTrue, reason: code);
    }
  });

  test('any single changed character fails', () {
    const code = 'EVT-7KQ2-M9XH';
    final positions = [4, 5, 6, 7, 9, 10, 11, 12];
    for (final i in positions) {
      for (final replacement in TicketCodes.alphabet.split('')) {
        if (replacement == code[i]) continue;
        final changed = code.replaceRange(i, i + 1, replacement);
        expect(TicketCodes.isValid(changed), isFalse, reason: changed);
      }
    }
  });

  test('swapping two different neighbours fails', () {
    expect(TicketCodes.isValid('EVT-K7Q2-M9XH'), isFalse);
    expect(TicketCodes.isValid('EVT-7Q2K-M9XH'), isFalse);
    expect(TicketCodes.isValid('EVT-7KQ2-9MXH'), isFalse);
  });

  test('the wrong shape fails', () {
    for (final code in [
      '',
      'EVT7KQ2M9XX',
      'EVT-7KQ2-M9X',
      'evt-7kq2-m9xx',
      'EVT-0KQ2-M9XX',
      'EVT-IKQ2-M9XX',
      'ABC-7KQ2-M9XX',
    ]) {
      expect(TicketCodes.isValid(code), isFalse, reason: code);
    }
  });
}
