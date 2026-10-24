import 'package:clock/clock.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

/// The device's time zone, read once at launch (`flutter_timezone`).
///
/// A `DateTime` can only be UTC or the device's zone, and the device's zone
/// has no *name* in Dart. Its IANA name lets `timezone` say what the user's
/// clock reads at any instant ("19:30 CET"), and lets tests fix it.
class DeviceTimeZone {
  const DeviceTimeZone(this.location);

  final tz.Location location;
}

/// "Now" and "today" for the user: the injected [Clock] read in the
/// device's zone.
///
/// Two calendars meet in this app. An event's own days are its venue's
/// (`EventTime`); Discover's "Today" and "Tomorrow" are the *user's*, so an
/// event at 23:30 in New York is listed under tomorrow in London.
@lazySingleton
class EventClock {
  EventClock(this._clock, DeviceTimeZone zone) : local = zone.location;

  final Clock _clock;

  /// The user's zone.
  final tz.Location local;

  /// Now, as an instant (UTC).
  DateTime now() => _clock.now().toUtc();

  /// The user's day now.
  CalendarDate today() => dayOf(now());

  /// The user's day at [instant].
  CalendarDate dayOf(DateTime instant) =>
      CalendarDate.fromDateTime(inLocal(instant));

  /// [instant] as the user's clock shows it.
  tz.TZDateTime inLocal(DateTime instant) => tz.TZDateTime.from(instant, local);
}
