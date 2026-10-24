import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/features/profile/cubit/profile_cubit.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: const ProfileView(),
    );
  }
}

/// Profile (the last tab): who you are, your counts (each leading to its
/// list), Edit profile and Settings.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final counts = state.counts;
    final profile = state.profile;
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => const SettingsRoute().push<void>(context),
          ),
        ],
      ),
      body: state.loading
          ? const LoadingView()
          : ListView(
              children: [
                if (profile == null)
                  const _NoProfile()
                else
                  _Header(profile: profile),
                const SectionHeader('Yours'),
                _CountTile(
                  icon: Icons.confirmation_number_outlined,
                  count: counts.upcomingTickets,
                  one: 'upcoming ticket',
                  many: 'upcoming tickets',
                  onTap: () => const TicketsRoute().go(context),
                ),
                _CountTile(
                  icon: Icons.bookmark_border,
                  count: counts.savedEvents,
                  one: 'saved event',
                  many: 'saved events',
                  onTap: () => const SavedRoute().go(context),
                ),
                _CountTile(
                  icon: Icons.people_outline,
                  count: counts.organizersFollowed,
                  one: 'organizer followed',
                  many: 'organizers followed',
                  onTap: () => const FollowingRoute().push<void>(context),
                ),
                _CountTile(
                  icon: Icons.star_border,
                  count: counts.sessionsBookmarked,
                  one: 'session bookmarked',
                  many: 'sessions bookmarked',
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: const Text('Edit profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => const ProfileEditRoute().push<void>(context),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => const SettingsRoute().push<void>(context),
                ),
              ],
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Row(
        children: [
          InitialsAvatar(name: profile.name, radius: 36),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  container: true,
                  header: true,
                  child: Text(
                    profile.name,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                Text(
                  profile.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A fresh start has no profile yet.
class _NoProfile extends StatelessWidget {
  const _NoProfile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No profile yet', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xxSmall),
          Text(
            'Add your name and email: organizers see them on your bookings.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          FilledButton.tonal(
            onPressed: () => const ProfileEditRoute().push<void>(context),
            child: const Text('Add your profile'),
          ),
        ],
      ),
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.icon,
    required this.count,
    required this.one,
    required this.many,
    this.onTap,
  });

  final IconData icon;
  final int count;
  final String one;
  final String many;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text('$count ${count == 1 ? one : many}'),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
