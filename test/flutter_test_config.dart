import 'dart:async';

import 'package:timezone/data/latest.dart' as tz_data;

/// Runs before every test file: the IANA time-zone database, as `main` loads
/// it before the app starts.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  tz_data.initializeTimeZones();
  await testMain();
}
