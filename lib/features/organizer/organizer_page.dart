import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:evently/features/organizer/cubit/organizer_cubit.dart';
import 'package:evently/features/organizer/cubit/organizer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class OrganizerPage extends StatelessWidget {
  const OrganizerPage({super.key, required this.organizerId});

  final String organizerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrganizerCubit>()..load(organizerId),
      child: const OrganizerView(),
    );
  }
}

/// An organizer: initials, name, followers and events, Follow, their bio,
/// and their events (upcoming, then past). Opened by a link it offers
/// Close, to Discover.
class OrganizerView extends StatelessWidget {
  const OrganizerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrganizerCubit, OrganizerState>(
      listenWhen: (previous, current) =>
          previous.messageSerial != current.messageSerial,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message ?? ''))),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: fallbackCloseButton(
            context,
            () => const DiscoverRoute().go(context),
          ),
          title: const Text('Organizer'),
        ),
        body: switch (state.status) {
          OrganizerStatus.loading => const LoadingView(),
          OrganizerStatus.notFound => const EmptyStateView(
            icon: Icons.person_off_outlined,
            title: "This organizer isn't available",
          ),
          OrganizerStatus.ready => _OrganizerBody(state: state),
        },
      ),
    );
  }
}

class _OrganizerBody extends StatelessWidget {
  const _OrganizerBody({required this.state});

  final OrganizerState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrganizerCubit>();
    final organizer = state.organizer!;
    Widget card(EventCardItem item) => EventCard(
      item: item,
      rsvpBlock: state.rsvpBlockFor(item),
      onTap: () => EventDetailRoute(eventId: item.event.id).push<void>(context),
      onToggleSaved: () => cubit.toggleSaved(item),
      onRsvp: () => RsvpRoute(eventId: item.event.id).push<void>(context),
    );
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      children: [
        _Header(
          organizer: organizer,
          isFollowing: state.isFollowing,
          onToggleFollowing: cubit.toggleFollowing,
        ),
        const SectionHeader('Coming up'),
        if (state.upcoming.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Text('Nothing planned right now.'),
          ),
        for (final item in state.upcoming) card(item),
        if (state.past.isNotEmpty) ...[
          const SectionHeader('Past'),
          for (final item in state.past) card(item),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.organizer,
    required this.isFollowing,
    required this.onToggleFollowing,
  });

  final Organizer organizer;
  final bool isFollowing;
  final VoidCallback onToggleFollowing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = organizer.eventsCount;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InitialsAvatar(name: organizer.name, radius: 36),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      container: true,
                      header: true,
                      child: Text(
                        organizer.name,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      '${EventFormats.followers(organizer.followers)} · '
                      '$events ${events == 1 ? 'event' : 'events'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          // Following reads as a state (outlined, with a check); Follow as
          // the action. The words carry it, not the style alone.
          if (isFollowing)
            OutlinedButton.icon(
              onPressed: onToggleFollowing,
              icon: const Icon(Icons.check),
              label: const Text('Following'),
            )
          else
            FilledButton.icon(
              onPressed: onToggleFollowing,
              icon: const Icon(Icons.add),
              label: const Text('Follow'),
            ),
          const SizedBox(height: AppSpacing.small),
          Text(organizer.bio, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
