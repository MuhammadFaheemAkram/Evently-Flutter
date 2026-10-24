import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/features/agenda/cubit/agenda_cubit.dart';
import 'package:evently/features/agenda/cubit/agenda_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AgendaCubit>()..load(eventId),
      child: AgendaView(eventId: eventId),
    );
  }
}

/// An event's sessions, day by day on the venue's calendar: bookmark the
/// ones you'll attend; two that overlap say so. "My sessions" shows only
/// yours. Opened by a link it offers Close, to the event.
class AgendaView extends StatelessWidget {
  const AgendaView({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgendaCubit, AgendaState>(
      listenWhen: (previous, current) =>
          previous.messageSerial != current.messageSerial,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message ?? ''))),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: fallbackCloseButton(
            context,
            () => EventDetailRoute(eventId: eventId).go(context),
          ),
          title: const Text('Agenda'),
        ),
        body: switch (state.status) {
          AgendaStatus.loading => const LoadingView(),
          AgendaStatus.notFound => const EmptyStateView(
            icon: Icons.event_busy_outlined,
            title: "This event isn't available",
          ),
          AgendaStatus.ready when state.days.isEmpty => EmptyStateView(
            icon: Icons.view_agenda_outlined,
            title: 'No agenda',
            message: '${state.agenda!.eventTitle} has no sessions to show.',
          ),
          AgendaStatus.ready => _AgendaBody(state: state),
        },
      ),
    );
  }
}

class _AgendaBody extends StatelessWidget {
  const _AgendaBody({required this.state});

  final AgendaState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AgendaCubit>();
    final theme = Theme.of(context);
    final agenda = state.agenda!;
    final current = state.currentDay!;
    final sessions = state.visibleSessions;
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.small,
            AppSpacing.medium,
            0,
          ),
          child: Text(agenda.eventTitle, style: theme.textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Wrap(
            spacing: AppSpacing.xSmall,
            runSpacing: AppSpacing.xSmall,
            children: [
              if (state.days.length > 1)
                for (final day in state.days)
                  ChoiceChip(
                    label: Text(
                      DateFormat('EEE d MMM').format(day.day.toDateTime()),
                    ),
                    selected: day.day == current.day,
                    onSelected: (_) => cubit.selectDay(day.day),
                  ),
              FilterChip(
                label: const Text('My sessions'),
                selected: state.myOnly,
                onSelected: (_) => cubit.toggleMyOnly(),
              ),
            ],
          ),
        ),
        if (sessions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Text(
              'No bookmarked sessions on this day. Tap the star on a '
              'session to add it.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        for (final item in sessions)
          ScheduleSessionCard(
            item: item,
            zone: agenda.zone,
            onToggleBookmark: () => cubit.toggleBookmark(item),
          ),
      ],
    );
  }
}
