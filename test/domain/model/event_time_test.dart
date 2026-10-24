import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  EventTime local(
    String zone,
    CalendarDate day,
    String from,
    String to, {
    CalendarDate? endDay,
  }) => EventTime.local(
    zone: zone,
    startDay: day,
    startTime: TimeOfDayValue.parse(from),
    endDay: endDay,
    endTime: TimeOfDayValue.parse(to),
  );

  final saturday = CalendarDate(2026, 10, 24);
  final sunday = CalendarDate(2026, 10, 25);
  final monday = CalendarDate(2026, 10, 26);

  group('a poster time becomes an instant', () {
    test('London in summer time is UTC+1', () {
      final time = local('Europe/London', saturday, '18:30', '21:00');

      expect(time.start, DateTime.utc(2026, 10, 24, 17, 30));
      expect(time.end, DateTime.utc(2026, 10, 24, 20));
      expect(time.start.isUtc, isTrue);
    });

    test('the same poster time after the clocks go back is an hour later '
        'in UTC', () {
      final time = local('Europe/London', monday, '18:30', '21:00');

      expect(time.start, DateTime.utc(2026, 10, 26, 18, 30));
    });

    test('Lahore has no summer time: UTC+5 all year', () {
      final october = local('Asia/Karachi', saturday, '19:30', '22:30');
      final june = local(
        'Asia/Karachi',
        CalendarDate(2026, 6, 6),
        '19:30',
        '22:30',
      );

      expect(october.start, DateTime.utc(2026, 10, 24, 14, 30));
      expect(june.start, DateTime.utc(2026, 6, 6, 14, 30));
    });

    test('New York keeps summer time a week longer than Europe', () {
      final time = local('America/New_York', monday, '09:00', '17:30');

      expect(time.start, DateTime.utc(2026, 10, 26, 13));
    });

    test('a time skipped when the clocks go forward moves an hour later', () {
      final time = local(
        'Europe/London',
        CalendarDate(2026, 3, 29),
        '01:30',
        '04:00',
      );

      expect(time.start, DateTime.utc(2026, 3, 29, 1, 30));
      expect(time.localStart.hour, 2);
    });

    test('a time that happens twice when the clocks go back is the second, '
        'in standard time', () {
      final time = local('Europe/London', sunday, '01:30', '04:00');

      expect(time.start, DateTime.utc(2026, 10, 25, 1, 30));
      expect(time.localStart.timeZoneOffset, Duration.zero);
    });
  });

  group('told in the venue\'s zone', () {
    test('a late event ends on the next day, and lasts 3 h 30', () {
      final jam = local(
        'America/New_York',
        saturday,
        '23:30',
        '03:00',
        endDay: sunday,
      );

      expect(jam.startDay, saturday);
      expect(jam.endDay, sunday);
      expect(jam.duration, const Duration(hours: 3, minutes: 30));
    });

    test('the venue\'s day, not UTC\'s: 23:30 in New York is already '
        'tomorrow in UTC', () {
      final jam = local(
        'America/New_York',
        saturday,
        '23:30',
        '03:00',
        endDay: sunday,
      );

      expect(jam.start.day, 25);
      expect(jam.startDay, saturday);
      expect(jam.localStart.hour, 23);
      expect(jam.localStart.minute, 30);
    });

    test('a night across the clock change lasts by instants: midnight to '
        '03:00 is 4 hours', () {
      final night = local('Europe/London', sunday, '00:00', '03:00');

      expect(night.duration, const Duration(hours: 4));
    });

    test('an instant reads differently in each zone, and the instants are '
        'the truth', () {
      final london = EventTime(
        start: DateTime.utc(2026, 10, 24, 17, 30),
        end: DateTime.utc(2026, 10, 24, 20),
        zone: 'Europe/London',
      );
      final lahore = london.copyWith(zone: 'Asia/Karachi');

      expect(london.localStart.hour, 18);
      expect(lahore.localStart.hour, 22);
      expect(lahore.startDay, london.startDay);
      expect(lahore.hasStarted(london.start), isTrue);
    });

    test('an unknown zone is refused', () {
      final time = EventTime(
        start: DateTime.utc(2026),
        end: DateTime.utc(2026, 1, 2),
        zone: 'Mars/Olympus_Mons',
      );

      expect(() => time.location, throwsA(isA<tz.LocationNotFoundException>()));
    });
  });

  group('started, ended, ongoing: by instants, end-exclusive', () {
    final time = EventTime(
      start: DateTime.utc(2026, 10, 24, 17, 30),
      end: DateTime.utc(2026, 10, 24, 20),
      zone: 'Europe/London',
    );
    const tick = Duration(microseconds: 1);

    test('just before the start', () {
      final now = time.start.subtract(tick);
      expect(time.hasStarted(now), isFalse);
      expect(time.isOngoing(now), isFalse);
    });

    test('at the start', () {
      expect(time.hasStarted(time.start), isTrue);
      expect(time.isOngoing(time.start), isTrue);
    });

    test('just before the end', () {
      final now = time.end.subtract(tick);
      expect(time.hasEnded(now), isFalse);
      expect(time.isOngoing(now), isTrue);
    });

    test('at the end', () {
      expect(time.hasEnded(time.end), isTrue);
      expect(time.isOngoing(time.end), isFalse);
    });

    test('a local DateTime for the same instant gives the same answers', () {
      final now = time.start.toLocal();
      expect(time.hasStarted(now), isTrue);
      expect(time.hasStarted(now.subtract(tick)), isFalse);
    });
  });
}
