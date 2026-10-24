import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_state.dart';
import 'package:evently/features/settings/widgets/planned_notifications_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsToolsCubit>()..load(),
      child: SettingsView(version: getIt<AppInfo>().versionLabel),
    );
  }
}

/// Settings (from the drawer, and Profile): appearance, notifications, your
/// city, the data tools, the developer tools and About. Switches are
/// adaptive (an iOS switch on iOS), as are the confirm dialogs and the time
/// picker.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.version});

  /// "1.0.0 (1)".
  final String version;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsToolsCubit, SettingsToolsState>(
      listenWhen: (previous, current) =>
          previous.messageSerial != current.messageSerial,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message ?? ''))),
      child: Scaffold(
        appBar: AppBar(
          leading: fallbackCloseButton(
            context,
            () => const ProfileRoute().go(context),
          ),
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.large),
          children: [
            const SectionHeader('Appearance'),
            const _Appearance(),
            const SectionHeader('Notifications'),
            const _Notifications(),
            const SectionHeader('Your city'),
            const _City(),
            const SectionHeader('Data'),
            const _Data(),
            const SectionHeader('Developer'),
            const _Developer(),
            const SectionHeader('About'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Evently'),
              subtitle: Text('Version $version'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const AboutRoute().push<void>(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// A progress indicator the size of a tile's trailing icon.
const _busy = SizedBox.square(
  dimension: 24,
  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
);

class _Appearance extends StatelessWidget {
  const _Appearance();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final state = context.watch<SettingsCubit>().state;
    final mode = state.settings.themeMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Three segments fit a phone at normal sizes; at large text a radio
        // list keeps every label whole.
        if (context.prefersStackedLayout)
          RadioGroup<AppThemeMode>(
            groupValue: mode,
            onChanged: (mode) {
              if (mode != null) cubit.setThemeMode(mode);
            },
            child: Column(
              children: [
                for (final option in AppThemeMode.values)
                  RadioListTile<AppThemeMode>(
                    value: option,
                    title: Text(option.label),
                  ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.xSmall,
            ),
            child: SegmentedChoice<AppThemeMode>(
              values: AppThemeMode.values,
              labelOf: (mode) => mode.label,
              selected: mode,
              onSelected: cubit.setThemeMode,
            ),
          ),
        // Android 12+ only: elsewhere the device has no wallpaper palette.
        if (state.deviceColors.supportsDynamicColor)
          SwitchListTile.adaptive(
            title: const Text('Dynamic color'),
            subtitle: const Text('Use the colors of your wallpaper'),
            value: state.settings.dynamicColor,
            onChanged: (enabled) => cubit.setDynamicColor(enabled: enabled),
          ),
      ],
    );
  }
}

String _time(BuildContext context, TimeOfDayValue time) => EventFormats.time(
  time,
  use24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
);

class _Notifications extends StatelessWidget {
  const _Notifications();

  Future<void> _chooseLead(BuildContext context, ReminderLead current) async {
    final settings = context.read<SettingsCubit>();
    final chosen = await showDialog<ReminderLead>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Remind me before an event'),
        children: [
          RadioGroup<ReminderLead>(
            groupValue: current,
            onChanged: (lead) => Navigator.of(context).pop(lead),
            child: Column(
              children: [
                for (final lead in ReminderLead.values)
                  RadioListTile<ReminderLead>(
                    value: lead,
                    title: Text(lead.label),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (chosen != null) await settings.setReminderLead(chosen);
  }

  Future<void> _pickSummaryTime(
    BuildContext context,
    TimeOfDayValue current,
  ) async {
    final settings = context.read<SettingsCubit>();
    final picked = await pickTime(context, current, title: 'Summary time');
    if (picked != null) await settings.setSummary(time: picked);
  }

  @override
  Widget build(BuildContext context) {
    final tools = context.read<SettingsToolsCubit>();
    final toolsState = context.watch<SettingsToolsCubit>().state;
    final settingsCubit = context.read<SettingsCubit>();
    final settings = context.watch<SettingsCubit>().state.settings;
    final on = settings.notificationsEnabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile.adaptive(
          secondary: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          subtitle: const Text(
            'Reminders, RSVP confirmations, changes to your events and a '
            'daily summary',
          ),
          value: on,
          onChanged: toolsState.running == SettingsTask.notifications
              ? null
              : (enabled) => tools.setNotificationsEnabled(enabled: enabled),
        ),
        if (toolsState.notificationsDenied && !on)
          _DeniedCard(onOpenSettings: tools.openNotificationSettings),
        if (on) ...[
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Reminder lead time'),
            subtitle: Text('${settings.reminderLead.label} before an event'),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _chooseLead(context, settings.reminderLead),
          ),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.today_outlined),
            title: const Text('Daily summary'),
            subtitle: Text(
              'At ${_time(context, settings.summaryTime)}, on days with '
              "events you're going to",
            ),
            value: settings.summaryEnabled,
            onChanged: (enabled) => settingsCubit.setSummary(enabled: enabled),
          ),
          if (settings.summaryEnabled)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Summary time'),
              subtitle: Text(_time(context, settings.summaryTime)),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _pickSummaryTime(context, settings.summaryTime),
            ),
        ],
      ],
    );
  }
}

/// Permission was denied: only the system settings can change that now.
class _DeniedCard extends StatelessWidget {
  const _DeniedCard({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSecondaryContainer;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        0,
        AppSpacing.medium,
        AppSpacing.xSmall,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notifications_off_outlined, color: color),
                  const SizedBox(width: AppSpacing.xSmall),
                  Expanded(
                    child: Text(
                      'Notifications are off for Evently. Allow them in the '
                      'system settings to get reminders.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: color),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                // The card's own foreground: the theme's primary on this
                // container falls short of 4.5:1 in the light theme.
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: color),
                  onPressed: onOpenSettings,
                  child: const Text('Open settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _City extends StatelessWidget {
  const _City();

  Future<void> _choose(BuildContext context, String? current) async {
    final cities = context.read<SettingsToolsCubit>().state.cities;
    final settings = context.read<SettingsCubit>();
    final chosen = await showDialog<_CityChoice>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Your city'),
        children: [
          RadioGroup<String?>(
            groupValue: current,
            onChanged: (city) => Navigator.of(context).pop(_CityChoice(city)),
            child: Column(
              children: [
                for (final city in <String?>[null, ...cities])
                  RadioListTile<String?>(
                    value: city,
                    title: Text(city ?? 'Anywhere'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (chosen != null) await settings.setPreferredCity(chosen.city);
  }

  @override
  Widget build(BuildContext context) {
    final city = context.watch<SettingsCubit>().state.settings.preferredCity;
    return ListTile(
      leading: const Icon(Icons.location_city_outlined),
      title: const Text('Preferred city'),
      subtitle: Text(
        city == null
            ? 'Anywhere: Discover shows no city section'
            : '$city: Discover leads with it',
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => _choose(context, city),
    );
  }
}

/// A dialog's answer, so "Anywhere" (`null`) differs from no answer.
class _CityChoice {
  const _CityChoice(this.city);

  final String? city;
}

class _Data extends StatelessWidget {
  const _Data();

  @override
  Widget build(BuildContext context) {
    final tools = context.read<SettingsToolsCubit>();
    final running = context.watch<SettingsToolsCubit>().state.running;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.cleaning_services_outlined),
          title: const Text('Clear cache'),
          subtitle: const Text(
            "Frees cached events you haven't saved or booked. Yours stay.",
          ),
          trailing: running == SettingsTask.clearCache ? _busy : null,
          enabled: running == null,
          onTap: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'Clear the cache?',
              message:
                  'Events you saved, booked or bookmarked sessions of stay. '
                  'The rest are fetched again on the next refresh.',
              confirmLabel: 'Clear',
            );
            if (confirmed) await tools.clearCache();
          },
        ),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: const Text('Reset demo data'),
          subtitle: const Text(
            'Brings back the demo profile, saved events, tickets and '
            'follows, with its events counted from today',
          ),
          trailing: running == SettingsTask.resetDemo ? _busy : null,
          enabled: running == null,
          onTap: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'Reset the demo data?',
              message:
                  'Your saved events, tickets, bookmarks, follows and '
                  "profile are replaced by the demo's. This can't be undone.",
              confirmLabel: 'Reset',
              destructive: true,
            );
            if (confirmed) await tools.resetDemoData();
          },
        ),
      ],
    );
  }
}

class _Developer extends StatelessWidget {
  const _Developer();

  static Future<void> _showPlan(BuildContext context) async {
    final NotificationPlanPreview preview = await context
        .read<SettingsToolsCubit>()
        .previewPlan();
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => PlannedNotificationsSheet(preview: preview),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tools = context.read<SettingsToolsCubit>();
    final state = context.watch<SettingsToolsCubit>().state;
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Simulate network failure'),
          subtitle: const Text('Every request fails, as if offline'),
          value: state.failingRequests,
          onChanged: (fail) => tools.setFailingRequests(fail: fail),
        ),
        ListTile(
          leading: const Icon(Icons.publish_outlined),
          title: const Text('Publish a catalog update'),
          subtitle: const Text(
            "The server moves an event you're going to, cancels another "
            'and adds new ones',
          ),
          trailing: state.running == SettingsTask.publishUpdate ? _busy : null,
          enabled: state.running == null,
          onTap: tools.publishCatalogUpdate,
        ),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Run background sync now'),
          subtitle: const Text(
            'Refresh, alert changes and plan notifications, as the system '
            'does every few hours',
          ),
          trailing: state.running == SettingsTask.backgroundSync ? _busy : null,
          enabled: state.running == null,
          onTap: tools.runBackgroundSync,
        ),
        ListTile(
          leading: const Icon(Icons.event_note_outlined),
          title: const Text('Show planned notifications'),
          subtitle: const Text('The next 7 days, as planned now'),
          onTap: () => _showPlan(context),
        ),
      ],
    );
  }
}
