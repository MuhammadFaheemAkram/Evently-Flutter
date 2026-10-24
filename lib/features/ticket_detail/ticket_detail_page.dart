import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/core/navigation/fallback_close_button.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/calculation/ticket_rules.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_cubit.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TicketDetailCubit>()..load(ticketId),
      child: const TicketDetailView(),
    );
  }
}

/// One ticket: its QR code and code, the event, the type and note, and
/// Cancel RSVP while the event is still to come. Opened by a link it offers
/// Close, to Tickets.
class TicketDetailView extends StatelessWidget {
  const TicketDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketDetailCubit, TicketDetailState>(
      listenWhen: (previous, current) =>
          previous.messageSerial != current.messageSerial,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message ?? ''))),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: fallbackCloseButton(
            context,
            () => const TicketsRoute().go(context),
          ),
          title: const Text('Ticket'),
        ),
        body: switch (state.status) {
          TicketDetailStatus.loading => const LoadingView(),
          TicketDetailStatus.notFound => EmptyStateView(
            icon: Icons.confirmation_number_outlined,
            title: "This ticket isn't here",
            action: FilledButton.tonal(
              onPressed: () => const TicketsRoute().go(context),
              child: const Text('Go to Tickets'),
            ),
          ),
          TicketDetailStatus.ready => _TicketBody(
            item: state.item!,
            state: state,
          ),
        },
      ),
    );
  }
}

class _TicketBody extends StatelessWidget {
  const _TicketBody({required this.item, required this.state});

  final TicketItem item;
  final TicketDetailState state;

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<TicketDetailCubit>();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cancel your RSVP?',
      message:
          'Your ${item.ticket.type.label} place at ${item.event.title} goes '
          'back, and this ticket stops working.',
      confirmLabel: 'Cancel RSVP',
      cancelLabel: 'Keep it',
      destructive: true,
    );
    if (confirmed) await cubit.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ticket = item.ticket;
    final event = item.event;
    final active =
        item.status != TicketStatus.cancelledByYou &&
        item.status != TicketStatus.cancelledByOrganizer;
    final block = state.cancelBlock;
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(event.title, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.xxSmall),
        TicketStatusLabel(status: item.status),
        const SizedBox(height: AppSpacing.medium),
        Center(
          child: active
              ? TicketQr(code: ticket.code)
              : Padding(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: Text(
                    'This ticket no longer works at the door.',
                    style: secondary,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.small),
        // One line at any text size: a code is read as a unit, so it
        // shrinks to fit rather than wrap. Plain text, not selectable: a
        // selectable one is a tap target, and shrunk it would be too small.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            ticket.code,
            maxLines: 1,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        ZonedTimeText(time: event.time, online: event.isOnline),
        Text(EventFormats.place(event.location), style: secondary),
        const SizedBox(height: AppSpacing.small),
        _Fact(label: 'Ticket', value: ticket.type.label),
        if (ticket.note.isNotEmpty) _Fact(label: 'Note', value: ticket.note),
        _Fact(
          label: 'Booked',
          value: DateFormat('EEE d MMM y').format(ticket.bookedAt.toLocal()),
        ),
        const SizedBox(height: AppSpacing.medium),
        OutlinedButton.icon(
          onPressed: () =>
              EventDetailRoute(eventId: event.id).push<void>(context),
          icon: const Icon(Icons.event_outlined),
          label: const Text('Open the event'),
        ),
        if (block == null) ...[
          const SizedBox(height: AppSpacing.xSmall),
          TextButton.icon(
            onPressed: state.cancelling ? null : () => _confirmCancel(context),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            icon: const Icon(Icons.cancel_outlined),
            label: Text(state.cancelling ? 'Cancelling…' : 'Cancel RSVP'),
          ),
        ] else if (block == CancelBlock.started)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xSmall),
            child: Text(
              'The event has started: the RSVP can no longer be cancelled.',
              style: secondary,
            ),
          ),
      ],
    );
  }
}

/// A label and its value, one under the other.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xSmall),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelMedium),
            Text(value, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
