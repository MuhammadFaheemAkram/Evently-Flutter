import 'package:material_ui/material_ui.dart';
import 'package:timezone/timezone.dart' as tz;

/// The user's time zone, for any widget that tells a time: provided once,
/// above the app, from the zone read at launch.
///
/// Times are formatted in a zone the *screen* picks: an in-person event in
/// its venue's, an online one in the user's. Views reach the user's here,
/// without a clock or a service.
class UserTimeZone extends InheritedWidget {
  const UserTimeZone({super.key, required this.location, required super.child});

  final tz.Location location;

  /// The nearest zone above [context]; UTC when there is none (a widget
  /// tested on its own).
  static tz.Location of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserTimeZone>()?.location ??
      tz.UTC;

  @override
  bool updateShouldNotify(UserTimeZone oldWidget) =>
      location != oldWidget.location;
}
