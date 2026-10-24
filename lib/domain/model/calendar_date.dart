/// A day on the calendar, with no time and no time zone: 14 October 2026 is
/// `20261014`.
///
/// Evently stores *instants* for events (they happen at one moment
/// everywhere) and turns them into days only to show them: an event's days
/// in its own time zone (an agenda's Day 1, Day 2), Discover's "Today" and
/// "Tomorrow" in the user's. A `yyyymmdd` integer sorts and compares like
/// the dates it stands for, and makes a range a plain `BETWEEN` in SQL. (The
/// same type as in SpendWise, DevJourney and Momentum.)
///
/// An extension type over `int`, so it costs nothing at runtime. The private
/// representation constructor means every value goes through a factory that
/// checks it is a real date.
extension type const CalendarDate._(int yyyymmdd) {
  /// The day [year]-[month]-[day]. Throws an [ArgumentError] for a date that
  /// doesn't exist (31 April, 29 February 2027).
  factory CalendarDate(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) {
      throw ArgumentError('Not a date: $year-$month-$day');
    }
    return CalendarDate._(year * 10000 + month * 100 + day);
  }

  /// [day] of [year]-[month], moved back to the month's last day when the
  /// month is shorter: day 31 of February 2027 is the 28th.
  factory CalendarDate.clamped(int year, int month, int day) =>
      CalendarDate(year, month, day.clamp(1, daysInMonth(year, month)));

  /// The day a stored `yyyymmdd` integer stands for.
  factory CalendarDate.fromInt(int yyyymmdd) =>
      CalendarDate(yyyymmdd ~/ 10000, yyyymmdd ~/ 100 % 100, yyyymmdd % 100);

  /// The calendar day of [dateTime] *in its own time zone*: pass a local
  /// time (`clock.now()`) to get the user's "today".
  factory CalendarDate.fromDateTime(DateTime dateTime) =>
      CalendarDate(dateTime.year, dateTime.month, dateTime.day);

  int get year => yyyymmdd ~/ 10000;

  int get month => yyyymmdd ~/ 100 % 100;

  int get day => yyyymmdd % 100;

  /// 1 (Monday) to 7 (Sunday), as `DateTime.weekday`.
  int get weekday => _utc.weekday;

  /// [days] later (or earlier, when negative). Computed in UTC, which has no
  /// daylight-saving jumps, so adding a day is always exactly one day.
  CalendarDate addDays(int days) =>
      CalendarDate.fromDateTime(_utc.add(Duration(days: days)));

  /// The Monday of this day's ISO week (weeks run Monday to Sunday).
  ///
  /// A week is always the same seven days, whatever the locale's first day
  /// ("This weekend" is its Saturday and Sunday).
  CalendarDate get weekStart => addDays(1 - weekday);

  /// The first day of this day's month.
  CalendarDate get monthStart => CalendarDate(year, month, 1);

  /// The days from this one to [other], negative when [other] is earlier.
  int daysUntil(CalendarDate other) => other._utc.difference(_utc).inDays;

  /// The same day [months] later (or earlier), clamped to the end of a
  /// shorter month: one month after 31 January is 28 (or 29) February.
  CalendarDate addMonths(int months) {
    final index = year * 12 + (month - 1) + months;
    return CalendarDate.clamped(index ~/ 12, index % 12 + 1, day);
  }

  bool operator <(CalendarDate other) => yyyymmdd < other.yyyymmdd;

  bool operator <=(CalendarDate other) => yyyymmdd <= other.yyyymmdd;

  bool operator >(CalendarDate other) => yyyymmdd > other.yyyymmdd;

  bool operator >=(CalendarDate other) => yyyymmdd >= other.yyyymmdd;

  /// Local midnight of this day, for formatting with `intl`.
  DateTime toDateTime() => DateTime(year, month, day);

  /// `2026-10-14`.
  String toIso() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  DateTime get _utc => DateTime.utc(year, month, day);

  /// The number of days in [month] of [year] (leap years included).
  static int daysInMonth(int year, int month) =>
      DateTime.utc(year, month + 1, 0).day;
}
