import 'package:evently/app/evently_app.dart';
import 'package:evently/di/injection.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/data/latest.dart' as tz_data;

Future<void> main() async {
  // Bindings must exist before any async setup touches plugins or assets.
  WidgetsFlutterBinding.ensureInitialized();
  // The IANA time-zone database, before anything reads an event's time.
  tz_data.initializeTimeZones();
  await configureDependencies();
  runApp(const EventlyApp());
}
