import 'package:material_ui/material_ui.dart';

/// An event's reminder: an adaptive switch (an iOS switch on iOS) that
/// says when it rings, or why it can't.
///
/// With notifications off in Settings the switch is disabled, and the
/// subtitle says so: a reminder that can't ring shouldn't read "on".
class ReminderToggle extends StatelessWidget {
  const ReminderToggle({
    super.key,
    required this.value,
    required this.lead,
    required this.notificationsOn,
    required this.onChanged,
  });

  /// Whether this event has a reminder.
  final bool value;

  /// "1 hour", the lead time from Settings.
  final String lead;

  final bool notificationsOn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      secondary: Icon(
        notificationsOn && value
            ? Icons.notifications_active_outlined
            : Icons.notifications_off_outlined,
      ),
      title: const Text('Remind me'),
      subtitle: Text(
        !notificationsOn
            ? 'Notifications are off. Turn them on in Settings.'
            : value
            ? '$lead before it starts'
            : 'No reminder for this event',
      ),
      value: notificationsOn && value,
      onChanged: notificationsOn ? onChanged : null,
    );
  }
}
