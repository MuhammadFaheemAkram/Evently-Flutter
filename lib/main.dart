import 'dart:async';
import 'dart:developer';

import 'package:evently/app/evently_app.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/service/background_work.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/data/latest.dart' as tz_data;

Future<void> main() async {
  // Bindings must exist before any async setup touches plugins or assets.
  WidgetsFlutterBinding.ensureInitialized();
  // The IANA time-zone database, before anything reads an event's time.
  tz_data.initializeTimeZones();
  await configureDependencies();
  unawaited(_registerBackgroundWork());
  // A notification's tap that launched the app opens straight on its
  // screen.
  final launch = await _launchTarget();
  runApp(EventlyApp(initialLocation: EventlyApp.locationFor(launch)));
}

/// The notification tap that launched the app, if any. Best effort: the
/// app starts whatever the notification plugin says (a release build once
/// stopped here, on a missing icon, conventions §11.85).
Future<NotificationTarget?> _launchTarget() async {
  try {
    return await getIt<NotificationInteractions>().launchTarget();
  } on Object catch (error, stackTrace) {
    log(
      'Reading the launch notification failed',
      error: error,
      stackTrace: stackTrace,
    );
    return null;
  }
}

Future<void> _registerBackgroundWork() async {
  try {
    await getIt<BackgroundWork>().registerSync();
  } on Object catch (error, stackTrace) {
    // Best effort: the app works without it, and the next launch retries.
    log(
      'Registering background work failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
