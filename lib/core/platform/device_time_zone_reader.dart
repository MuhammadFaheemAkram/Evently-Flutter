import 'dart:developer';

import 'package:evently/core/common/event_clock.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

/// The device's time zone, from `flutter_timezone`. The time-zone database
/// must be loaded first. A zone the database doesn't know (or a platform
/// error) falls back to UTC rather than stopping the app or the sync.
Future<DeviceTimeZone> readDeviceTimeZone() async {
  try {
    final zone = await FlutterTimezone.getLocalTimezone();
    return DeviceTimeZone(tz.getLocation(zone.identifier));
  } on Object catch (error, stackTrace) {
    log('Reading the time zone failed', error: error, stackTrace: stackTrace);
    return DeviceTimeZone(tz.UTC);
  }
}
