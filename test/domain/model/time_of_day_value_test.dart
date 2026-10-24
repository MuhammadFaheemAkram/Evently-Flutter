import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('holds a time as minutes since midnight', () {
    final time = TimeOfDayValue(7, 30);

    expect(time.minutesSinceMidnight, 450);
    expect((time.hour, time.minute), (7, 30));
  });

  test('refuses a time that is not on the clock', () {
    expect(() => TimeOfDayValue(24, 0), throwsArgumentError);
    expect(() => TimeOfDayValue(12, 60), throwsArgumentError);
    expect(() => TimeOfDayValue(-1, 0), throwsArgumentError);
  });

  test('writes and reads HH:mm, padded', () {
    expect(TimeOfDayValue(7, 5).toHhMm(), '07:05');
    expect(TimeOfDayValue(23, 59).toHhMm(), '23:59');
    expect(TimeOfDayValue.parse('00:00'), TimeOfDayValue(0, 0));
    expect(TimeOfDayValue.parse('21:30'), TimeOfDayValue(21, 30));
  });

  test('parses only exact HH:mm', () {
    for (final text in ['7:30', '24:00', '12:60', '12-30', '12:3', ' 12:30']) {
      expect(
        () => TimeOfDayValue.parse(text),
        throwsFormatException,
        reason: text,
      );
    }
  });

  test('compares like the times it stands for', () {
    expect(TimeOfDayValue(7, 0) < TimeOfDayValue(7, 1), isTrue);
    expect(TimeOfDayValue(21, 30) < TimeOfDayValue(9, 0), isFalse);
  });
}
