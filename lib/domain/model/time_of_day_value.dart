/// A time on the clock, with no day and no time zone: 07:30 is `450`, the
/// minutes since midnight.
///
/// An event's start in the catalog's seed ("18:30" in its venue's zone), and
/// the daily summary's time, are times *of a day* in some zone. Stored
/// as `HH:mm` text, which reads well and sorts like the times it stands
/// for.
///
/// An extension type over `int`, like `CalendarDate`: free at runtime, and
/// every value goes through a factory that checks it.
extension type const TimeOfDayValue._(int minutesSinceMidnight) {
  /// [hour]:[minute]. Throws an [ArgumentError] outside 00:00–23:59.
  factory TimeOfDayValue(int hour, int minute) {
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw ArgumentError('Not a time: $hour:$minute');
    }
    return TimeOfDayValue._(hour * 60 + minute);
  }

  /// The time in `HH:mm` text (`07:30`). Throws a [FormatException] for
  /// anything else, including `7:30` and `24:00`.
  factory TimeOfDayValue.parse(String hhMm) {
    final match = _pattern.firstMatch(hhMm);
    final hour = int.tryParse(match?.group(1) ?? '');
    final minute = int.tryParse(match?.group(2) ?? '');
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      throw FormatException('Not an HH:mm time', hhMm);
    }
    return TimeOfDayValue(hour, minute);
  }

  /// The daily summary's default, as a constant so `AppSettings` can use
  /// it in `@Default`.
  static const eightAm = TimeOfDayValue._(8 * 60);

  int get hour => minutesSinceMidnight ~/ 60;

  int get minute => minutesSinceMidnight % 60;

  bool operator <(TimeOfDayValue other) =>
      minutesSinceMidnight < other.minutesSinceMidnight;

  /// `07:30`.
  String toHhMm() =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';

  static final _pattern = RegExp(r'^(\d{2}):(\d{2})$');
}
