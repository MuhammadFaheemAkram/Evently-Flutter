import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_state.dart';
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

/// Settings (from the drawer, and Profile): appearance, your city, the data
/// tools, the developer tools and About. Notifications arrive in Phase 7.
/// Switches are adaptive (an iOS switch on iOS), as are the confirm
/// dialogs.
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
            'follows',
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
      ],
    );
  }
}
