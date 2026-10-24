import 'package:evently/app/evently_app.dart';
import 'package:evently/di/injection.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // Bindings must exist before any setup touches plugins or assets.
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const EventlyApp());
}
