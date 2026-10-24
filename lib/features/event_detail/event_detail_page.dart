import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_details.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:evently/features/event_detail/cubit/event_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventDetailCubit>()..load(eventId),
      child: const EventDetailView(),
    );
  }
}

/// One event: when (on the venue's clock, and yours when it differs),
/// where, how full, its tickets, the RSVP entry (or why it's closed), the
/// start of its agenda and its organizer.
///
/// Opened by a link (or, later, a notification) it has nothing to go back
/// to, so it offers Close.
class EventDetailView extends StatelessWidget {
  const EventDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      listenWhen: (previous, current) =>
          previous.messageSerial != current.messageSerial,
      listener: (context, state) {
        final message = state.message;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final details = state.details;
        return Scaffold(
          appBar: AppBar(
            leading: fallbackCloseButton(
              context,
              () => const DiscoverRoute().go(context),
            ),
            title: const Text('Event'),
            actions: [
              if (details != null)
                SaveButton(
                  isSaved: details.item.isSaved,
                  onPressed: context.read<EventDetailCubit>().toggleSaved,
                ),
            ],
          ),
          body: switch (state.status) {
            EventDetailStatus.loading => const LoadingView(),
            EventDetailStatus.notFound => EmptyStateView(
              icon: Icons.event_busy_outlined,
              title: "This event isn't available",
              message:
                  'It may have been removed. Discover has the latest '
                  'events.',
              action: FilledButton.tonal(
                onPressed: () => const DiscoverRoute().go(context),
                child: const Text('Go to Discover'),
              ),
            ),
            EventDetailStatus.ready => _EventBody(
              details: details!,
              state: state,
            ),
          },
        );
      },
    );
  }
}

class _EventBody extends StatelessWidget {
  const _EventBody({required this.details, required this.state});

  final EventDetails details;
  final EventDetailState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = details.item.event;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xLarge),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: SizedBox(
            height: 140,
            child: EventBanner(
              category: event.category,
              iconSize: AppIconSize.large,
              showLabel: true,
            ),
          ),
        ),
        if (_StatusBanner.shows(event)) _StatusBanner(event: event),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Semantics(
            container: true,
            header: true,
            child: Text(event.title, style: theme.textTheme.headlineSmall),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.xxSmall,
            AppSpacing.medium,
            0,
          ),
          child: Text(
            '${event.category.label} · by ${details.item.organizerName}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        _InfoRow(
          icon: Icons.schedule,
          child: ZonedTimeText(time: event.time, online: event.isOnline),
        ),
        _InfoRow(
          icon: event.isOnline ? Icons.videocam_outlined : Icons.place_outlined,
          child: _Location(details: details),
        ),
        _InfoRow(
          icon: Icons.groups_outlined,
          child: AttendanceLabel(
            event: event,
            ended: state.hasEnded,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: _RsvpEntry(details: details, block: state.rsvpBlock),
        ),
        const SectionHeader('Tickets'),
        _Offers(event: event),
        const SectionHeader('About'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Text(event.description, style: theme.textTheme.bodyLarge),
        ),
        if (details.sessionCount > 0) _AgendaPreview(details: details),
        const SectionHeader('Organizer'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: OrganizerCard(
            organizer: details.organizer,
            onTap: () =>
                OrganizerRoute(organizerId: details.organizer.id)
                    .push<void>(context),
          ),
        ),
      ],
    );
  }
}

/// "Moved to …" or "Cancelled by the organizer", with an icon and the
/// words: never the color alone.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.event});

  final Event event;

  static bool shows(Event event) => event.status != EventStatus.scheduled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final previous = event.previousStart;
    final (icon, color, title, detail) = switch (event.status) {
      EventStatus.moved => (
        Icons.update,
        colors.moved,
        'Moved to ${EventFormats.start(event.time, use24HourFormat: use24)}',
        previous == null
            ? null
            : 'It was '
                  '${EventFormats.instant(previous, event.time.location, use24HourFormat: use24)}.',
      ),
      EventStatus.cancelled => (
        Icons.event_busy,
        colors.cancelled,
        'Cancelled by the organizer',
        null,
      ),
      EventStatus.scheduled => (Icons.event, colors.going, '', null),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        0,
        AppSpacing.medium,
        AppSpacing.small,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(color: color),
                    ),
                    if (detail != null)
                      Text(detail, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An icon beside what it introduces (the time, the place, attendance).
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.xSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.small),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// The venue with Directions, or "Online" with the join link once you're
/// going.
class _Location extends StatelessWidget {
  const _Location({required this.details});

  final EventDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<EventDetailCubit>();
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return switch (details.item.event.location) {
      Venue(:final name, :final address, :final city) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: theme.textTheme.bodyLarge),
          Text('$address, $city', style: secondary),
          TextButton.icon(
            onPressed: () => cubit.openDirections(
              appleMaps: theme.platform == TargetPlatform.iOS,
            ),
            icon: const Icon(Icons.directions),
            label: const Text('Directions'),
          ),
        ],
      ),
      Online() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Online', style: theme.textTheme.bodyLarge),
          if (details.item.isGoing)
            TextButton.icon(
              onPressed: cubit.openJoinLink,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Join online'),
            )
          else
            Text("The join link appears once you're going.", style: secondary),
        ],
      ),
    };
  }
}

/// RSVP, or "You're going" with the ticket, or why it's closed.
class _RsvpEntry extends StatelessWidget {
  const _RsvpEntry({required this.details, required this.block});

  final EventDetails details;
  final RsvpBlock? block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ticketId = details.ticketId;
    if (details.item.isGoing && ticketId != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GoingBadge(text: "You're going"),
          const SizedBox(height: AppSpacing.xSmall),
          OutlinedButton.icon(
            onPressed: () =>
                TicketDetailRoute(ticketId: ticketId).push<void>(context),
            icon: const Icon(Icons.confirmation_number_outlined),
            label: const Text('View ticket'),
          ),
        ],
      );
    }
    final block = this.block;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: block == null
              ? () =>
                    RsvpRoute(eventId: details.item.event.id)
                        .push<void>(context)
              : null,
          child: const Text('RSVP'),
        ),
        if (block != null) ...[
          const SizedBox(height: AppSpacing.xSmall),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: MediaQuery.textScalerOf(context).scale(18),
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xSmall),
              Expanded(
                child: Text(
                  EventFormats.rsvpBlock(block),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// What the event sells: each ticket type with its price and places.
class _Offers extends StatelessWidget {
  const _Offers({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final soldOut = context.appColors.soldOut;
    return Column(
      children: [
        for (final offer in event.offers)
          ListTile(
            title: Text(offer.type.label),
            subtitle: offer.isSoldOut
                ? Text('Sold out', style: TextStyle(color: soldOut))
                : Text(EventFormats.placesLeft(offer.remaining)),
            trailing: Text(
              EventFormats.price(offer.priceMinor, offer.currency),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }
}

/// The first sessions, and the way to the full agenda.
class _AgendaPreview extends StatelessWidget {
  const _AgendaPreview({required this.details});

  final EventDetails details;

  @override
  Widget build(BuildContext context) {
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final zone = details.item.event.time.zone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Agenda'),
        for (final session in details.agendaPreview)
          ListTile(
            title: Text(session.title),
            subtitle: Text(
              '${EventFormats.range(
                EventTime(start: session.start, end: session.end, zone: zone),
                use24HourFormat: use24,
              )}\n'
              '${session.speaker} · ${session.room}',
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xSmall),
            child: TextButton(
              onPressed: () =>
                  AgendaRoute(eventId: details.item.event.id)
                      .push<void>(context),
              child: Text('See full agenda (${details.sessionCount} sessions)'),
            ),
          ),
        ),
      ],
    );
  }
}
