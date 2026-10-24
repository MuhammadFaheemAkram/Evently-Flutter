import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/features/following/cubit/following_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FollowingCubit>()..load(),
      child: const FollowingView(),
    );
  }
}

/// Following (from the drawer): the organizers you follow, each with their
/// next event.
class FollowingView extends StatelessWidget {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    final followed = context.watch<FollowingCubit>().state;
    return Scaffold(
      appBar: AppBar(
        leading: fallbackCloseButton(
          context,
          () => const DiscoverRoute().go(context),
        ),
        title: const Text('Following'),
      ),
      body: switch (followed) {
        null => const LoadingView(),
        [] => EmptyStateView(
          icon: Icons.person_add_alt_outlined,
          title: "You don't follow anyone yet",
          message: 'Follow an organizer from their page to see them here.',
          action: FilledButton.tonal(
            onPressed: () => const DiscoverRoute().go(context),
            child: const Text('Discover events'),
          ),
        ),
        _ => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.medium),
          itemCount: followed.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.small),
          itemBuilder: (context, index) => _FollowedRow(item: followed[index]),
        ),
      },
    );
  }
}

class _FollowedRow extends StatelessWidget {
  const _FollowedRow({required this.item});

  final FollowedOrganizer item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = item.nextEvent;
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OrganizerCard(
          organizer: item.organizer,
          onTap: () =>
              OrganizerRoute(organizerId: item.organizer.id)
                  .push<void>(context),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.xxSmall,
            AppSpacing.medium,
            0,
          ),
          child: next == null
              ? Text('Nothing coming up', style: theme.textTheme.bodyMedium)
              : InkWell(
                  onTap: () =>
                      EventDetailRoute(eventId: next.event.id)
                          .push<void>(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.small,
                    ),
                    child: Text(
                      'Next: ${next.event.title}, '
                      '${EventFormats.start(next.event.time, use24HourFormat: use24, zone: EventFormats.zoneFor(next.event, UserTimeZone.of(context)))}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
