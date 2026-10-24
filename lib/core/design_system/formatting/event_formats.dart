import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

/// How events read on screen. Formatting lives here, never in the domain:
/// the model holds instants and a zone, and the screen picks which zone to
/// tell them in. (A notification's words are the exception: they are part
/// of the plan the sync compares, see `planNotifications`.)
abstract final class EventFormats {
  /// A list's day heading, in the user's calendar: "Today", "Tomorrow",
  /// "Sat, 31 Oct", and the year when it isn't this year's.
  static String day(CalendarDate date, {required CalendarDate today}) {
    if (date == today) return 'Today';
    if (date == today.addDays(1)) return 'Tomorrow';
    final pattern = date.year == today.year ? 'EEE, d MMM' : 'EEE, d MMM y';
    return DateFormat(pattern).format(date.toDateTime());
  }

  /// The zone [event]'s time is told in: an in-person event's venue (the
  /// poster's time, the same for everyone going), an online event's viewer
  /// ([userZone]: they join from wherever they are).
  static tz.Location zoneFor(Event event, tz.Location userZone) =>
      event.isOnline ? userZone : event.time.location;

  /// When an event starts, on [zone]'s clock (the venue's by default): "Sat
  /// 31 Oct, 18:30 GMT".
  static String start(
    EventTime time, {
    required bool use24HourFormat,
    tz.Location? zone,
  }) => instant(
    time.start,
    zone ?? time.location,
    use24HourFormat: use24HourFormat,
  );

  /// [instant] on [zone]'s clock: "Sat 31 Oct, 18:30 GMT".
  static String instant(
    DateTime instant,
    tz.Location zone, {
    required bool use24HourFormat,
  }) {
    final local = tz.TZDateTime.from(instant, zone);
    return '${_date(local)}, ${_clock(local, use24HourFormat)} '
        '${local.timeZoneName}';
  }

  /// An event's time in [zone] (the venue's by default): "Sat 31 Oct,
  /// 18:30–21:00 GMT", or with both days when it ends on another: "Wed 21
  /// Oct, 23:30 – Thu 22 Oct, 03:00 EDT".
  static String range(
    EventTime time, {
    required bool use24HourFormat,
    tz.Location? zone,
  }) {
    final location = zone ?? time.location;
    final start = tz.TZDateTime.from(time.start, location);
    final end = tz.TZDateTime.from(time.end, location);
    final from = _clock(start, use24HourFormat);
    final to = _clock(end, use24HourFormat);
    final sameDay =
        CalendarDate.fromDateTime(start) == CalendarDate.fromDateTime(end);
    return sameDay
        ? '${_date(start)}, $from–$to ${end.timeZoneName}'
        : '${_date(start)}, $from – ${_date(end)}, $to ${end.timeZoneName}';
  }

  /// [range] for a screen reader, in full words: "Saturday 31 October, 6:30
  /// PM to 9:00 PM, GMT".
  static String spokenRange(
    EventTime time, {
    required bool use24HourFormat,
    tz.Location? zone,
  }) {
    final location = zone ?? time.location;
    final start = tz.TZDateTime.from(time.start, location);
    final end = tz.TZDateTime.from(time.end, location);
    final from = _clock(start, use24HourFormat);
    final to = _clock(end, use24HourFormat);
    final sameDay =
        CalendarDate.fromDateTime(start) == CalendarDate.fromDateTime(end);
    return sameDay
        ? '${_longDate(start)}, $from to $to, ${end.timeZoneName}'
        : '${_longDate(start)}, $from, to ${_longDate(end)}, $to, '
              '${end.timeZoneName}';
  }

  /// Whether the user's clock reads [time] differently from the venue's:
  /// then Event detail shows both.
  static bool differsIn(EventTime time, tz.Location zone) {
    tz.TZDateTime inZone(DateTime instant) => tz.TZDateTime.from(instant, zone);
    return inZone(time.start).timeZoneOffset !=
            time.localStart.timeZoneOffset ||
        inZone(time.end).timeZoneOffset != time.localEnd.timeZoneOffset;
  }

  /// A session's slot on the venue's clock: "09:00–09:45".
  static String slot(EventTime time, {required bool use24HourFormat}) =>
      '${_clock(time.localStart, use24HourFormat)}–'
      '${_clock(time.localEnd, use24HourFormat)}';

  /// A price in minor units: "£18", "£18.50", "Rs3,000", "Free".
  static String price(int priceMinor, String currency) {
    if (priceMinor == 0) return 'Free';
    return NumberFormat.simpleCurrency(
      locale: 'en',
      name: currency,
      decimalDigits: priceMinor % 100 == 0 ? 0 : 2,
    ).format(priceMinor / 100);
  }

  /// A card's price: "Free", "£18", or "From £18" when the offers differ.
  static String priceSummary(Event event) {
    if (event.isFree) return 'Free';
    final paid = [
      for (final offer in event.offers)
        if (!offer.isFree) offer,
    ]..sort((a, b) => a.priceMinor.compareTo(b.priceMinor));
    final cheapest = price(paid.first.priceMinor, paid.first.currency);
    final mixed =
        paid.length < event.offers.length ||
        paid.first.priceMinor != paid.last.priceMinor;
    return mixed ? 'From $cheapest' : cheapest;
  }

  /// "950", "1.2k", "8.9k".
  static String count(int value) =>
      NumberFormat.compact(locale: 'en').format(value).toLowerCase();

  /// "1.2k followers", "1 follower".
  static String followers(int value) =>
      '${count(value)} ${value == 1 ? 'follower' : 'followers'}';

  /// "1 place left", "26 places left".
  static String placesLeft(int places) =>
      '$places ${places == 1 ? 'place' : 'places'} left';

  /// Where it happens, briefly: "Vaults, London" or "Online".
  static String place(EventLocation location) => switch (location) {
    Venue(:final name, :final city) => '$name, $city',
    Online() => 'Online',
  };

  /// Why the RSVP button is off.
  static String rsvpBlock(RsvpBlock block) => switch (block) {
    RsvpBlock.going => "You're going",
    RsvpBlock.cancelled => 'This event was cancelled',
    RsvpBlock.ended => 'This event has ended',
    RsvpBlock.started => 'Bookings closed when it started',
    RsvpBlock.soldOut => 'Sold out',
  };

  /// A time of day from Settings, on the user's clock style: "08:00" or
  /// "8:00 AM".
  static String time(TimeOfDayValue time, {required bool use24HourFormat}) =>
      _clock(DateTime(2026, 1, 1, time.hour, time.minute), use24HourFormat);

  static String _date(DateTime local) => DateFormat('EEE d MMM').format(local);

  static String _longDate(DateTime local) =>
      DateFormat('EEEE d MMMM').format(local);

  static String _clock(DateTime local, bool use24HourFormat) =>
      (use24HourFormat ? DateFormat.Hm() : DateFormat.jm()).format(local);
}
