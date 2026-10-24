import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:evently/core/design_system/theme/app_spacing.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:material_ui/material_ui.dart';

/// Picks a time the platform's way: Material's clock dialog on Android, a
/// wheel in a bottom sheet on iOS (as in DevJourney and Momentum). `null`
/// if dismissed.
Future<TimeOfDayValue?> pickTime(
  BuildContext context,
  TimeOfDayValue initial, {
  required String title,
}) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showModalBottomSheet<TimeOfDayValue>(
      context: context,
      // Above the tab bar, like every modal (conventions §11.46).
      useRootNavigator: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _CupertinoTimeSheet(initial: initial, title: title),
    );
  }
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    helpText: title,
  );
  return picked == null ? null : TimeOfDayValue(picked.hour, picked.minute);
}

class _CupertinoTimeSheet extends StatefulWidget {
  const _CupertinoTimeSheet({required this.initial, required this.title});

  final TimeOfDayValue initial;
  final String title;

  @override
  State<_CupertinoTimeSheet> createState() => _CupertinoTimeSheetState();
}

class _CupertinoTimeSheetState extends State<_CupertinoTimeSheet> {
  late TimeOfDayValue _time = widget.initial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        0,
        AppSpacing.medium,
        AppSpacing.medium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.title, style: theme.textTheme.titleLarge),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(_time),
                child: const Text('Done'),
              ),
            ],
          ),
          SizedBox(
            height: 216,
            child: CupertinoTheme(
              data: CupertinoThemeData(brightness: theme.brightness),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
                initialDateTime: DateTime(
                  2026,
                  1,
                  1,
                  widget.initial.hour,
                  widget.initial.minute,
                ),
                onDateTimeChanged: (value) =>
                    _time = TimeOfDayValue(value.hour, value.minute),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
