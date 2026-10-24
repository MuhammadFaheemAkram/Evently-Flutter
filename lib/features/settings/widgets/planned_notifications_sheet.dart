import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:material_ui/material_ui.dart';

/// Settings → Developer → Show planned notifications: the plan as the
/// planner made it, and how many the device holds.
class PlannedNotificationsSheet extends StatelessWidget {
  const PlannedNotificationsSheet({super.key, required this.preview});

  final NotificationPlanPreview preview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final zone = UserTimeZone.of(context);
    final use24Hour = MediaQuery.alwaysUse24HourFormatOf(context);
    final plan = preview.plan;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  container: true,
                  header: true,
                  child: Text(
                    'Planned notifications',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxSmall),
                Text(
                  preview.enabled
                      ? '${plan.length} planned for the next 7 days; '
                            '${preview.pending} scheduled on this device.'
                      : 'Notifications are off, so nothing is scheduled. '
                            'This is what would be.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Expanded(
            child: plan.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.medium),
                    child: Text(
                      'Nothing to plan: no event you are going to (or saved '
                      'with a reminder) in the next 7 days.',
                    ),
                  )
                : ListView.builder(
                    itemCount: plan.length,
                    itemBuilder: (context, index) {
                      final n = plan[index];
                      final when = EventFormats.instant(
                        n.at,
                        zone,
                        use24HourFormat: use24Hour,
                      );
                      return ListTile(
                        leading: Icon(switch (n.kind) {
                          NotificationKind.reminder =>
                            Icons.notifications_outlined,
                          NotificationKind.summary => Icons.today_outlined,
                          NotificationKind.confirmation ||
                          NotificationKind.change => Icons.info_outline,
                        }),
                        title: Text(n.title),
                        subtitle: Text('$when · ${n.kind.label}\n${n.body}'),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
