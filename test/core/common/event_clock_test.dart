import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  EventClock clockIn(String zone, DateTime now) =>
      EventClock(Clock.fixed(now), DeviceTimeZone(tz.getLocation(zone)));

  test('now is an instant, whatever the clock was given', () {
    final clock = clockIn('Asia/Karachi', DateTime.utc(2026, 10, 21, 14));

    expect(clock.now(), DateTime.utc(2026, 10, 21, 14));
    expect(clock.now().isUtc, isTrue);
  });

  test("today is the user's day: 20:00 UTC is already tomorrow in Lahore", () {
    final now = DateTime.utc(2026, 10, 21, 20);

    expect(clockIn('Europe/London', now).today(), CalendarDate(2026, 10, 21));
    expect(clockIn('Asia/Karachi', now).today(), CalendarDate(2026, 10, 22));
    expect(
      clockIn('America/New_York', now).today(),
      CalendarDate(2026, 10, 21),
    );
  });

  test('23:30 in New York falls on the next day in London', () {
    final clock = clockIn('Europe/London', DateTime.utc(2026, 10, 21, 14));
    // Wednesday 23:30 EDT is Thursday 03:30 UTC, 04:30 BST.
    final jam = DateTime.utc(2026, 10, 22, 3, 30);

    expect(clock.dayOf(jam), CalendarDate(2026, 10, 22));
    expect(clock.inLocal(jam).hour, 4);
  });
}
