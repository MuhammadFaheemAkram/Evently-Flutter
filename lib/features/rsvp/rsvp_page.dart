import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/calculation/rsvp_validation.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/rsvp/cubit/rsvp_cubit.dart';
import 'package:evently/features/rsvp/cubit/rsvp_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class RsvpPage extends StatelessWidget {
  const RsvpPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RsvpCubit>()..load(eventId),
      child: RsvpView(eventId: eventId),
    );
  }
}

/// Booking a place at [eventId], as a full-screen dialog: choose a ticket
/// type, add a note, Confirm. Nothing is booked until the server says so;
/// then the new ticket opens *in place of* this form, so Back returns to
/// the event, not to a finished form.
///
/// Its Close button is always there (an app bar adds one only when it can
/// pop), and for a deep link with nothing underneath it goes to the event
/// instead of popping the router's last page (conventions §11.47).
class RsvpView extends StatelessWidget {
  const RsvpView({super.key, required this.eventId});

  final String eventId;

  void _close(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      EventDetailRoute(eventId: eventId).go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RsvpCubit, RsvpState>(
      listenWhen: (previous, current) =>
          previous.ticketId == null && current.ticketId != null,
      listener: (context, state) =>
          TicketDetailRoute(ticketId: state.ticketId!).pushReplacement(context),
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(onPressed: () => _close(context)),
          title: const Text('RSVP'),
        ),
        body: BlocBuilder<RsvpCubit, RsvpState>(
          builder: (context, state) {
            final event = state.event;
            final block = state.block;
            return switch (state.status) {
              RsvpStatus.loading => const LoadingView(),
              RsvpStatus.notFound => const EmptyStateView(
                icon: Icons.event_busy_outlined,
                title: "This event isn't available",
              ),
              RsvpStatus.booked => const LoadingView(
                message: 'Opening your ticket',
              ),
              _ when block != null => EmptyStateView(
                icon: Icons.info_outline,
                title: EventFormats.rsvpBlock(block),
                message: "This event can't be booked now.",
                action: FilledButton.tonal(
                  onPressed: () => _close(context),
                  child: const Text('Back to the event'),
                ),
              ),
              _ => _RsvpForm(state: state, event: event!),
            };
          },
        ),
      ),
    );
  }
}

class _RsvpForm extends StatefulWidget {
  const _RsvpForm({required this.state, required this.event});

  final RsvpState state;
  final EventCardItem event;

  @override
  State<_RsvpForm> createState() => _RsvpFormState();
}

class _RsvpFormState extends State<_RsvpForm> {
  late final _note = TextEditingController(text: widget.state.note);

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RsvpCubit>();
    final state = widget.state;
    final event = widget.event.event;
    final theme = Theme.of(context);
    final problem = state.showErrors ? state.problem : null;
    final typeError = switch (problem) {
      RsvpNoType() => 'Choose a ticket type.',
      RsvpTypeNotOffered() => "This event doesn't sell that ticket.",
      RsvpTypeSoldOut(:final type) => 'No ${type.label} places left.',
      _ => null,
    };
    final noteTooLong = problem is RsvpNoteTooLong;
    final busy = state.status == RsvpStatus.submitting;
    final chosen = event.offers.where((o) => o.type == state.type).firstOrNull;
    final confirmLabel = state.status == RsvpStatus.failed
        ? 'Try again'
        : chosen == null
        ? 'Confirm'
        : 'Confirm · ${EventFormats.price(chosen.priceMinor, chosen.currency)}';
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xLarge),
      children: [
        _EventSummary(event: event),
        const SectionHeader('Ticket type'),
        RadioGroup<TicketType>(
          groupValue: state.type,
          onChanged: (type) {
            if (type != null) cubit.selectType(type);
          },
          child: Column(
            children: [
              for (final offer in event.offers)
                RadioListTile<TicketType>(
                  value: offer.type,
                  enabled: !offer.isSoldOut && !busy,
                  title: Text(offer.type.label),
                  subtitle: Text(
                    offer.isSoldOut
                        ? 'Sold out'
                        : '${EventFormats.price(offer.priceMinor, offer.currency)}'
                              ' · ${EventFormats.placesLeft(offer.remaining)}',
                  ),
                ),
            ],
          ),
        ),
        if (typeError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Text(
              typeError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const SectionHeader('Note'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: TextField(
            controller: _note,
            enabled: !busy,
            onChanged: cubit.changeNote,
            minLines: 2,
            maxLines: 4,
            maxLength: RsvpRules.maxNoteLength,
            // Over the limit shows as an error, rather than silently
            // cutting what was typed.
            maxLengthEnforcement: MaxLengthEnforcement.none,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Note for the organizer (optional)',
              hintText: 'Dietary needs, access, a question…',
              errorText: noteTooLong
                  ? 'Keep it to ${RsvpRules.maxNoteLength} characters.'
                  : null,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        if (state.status == RsvpStatus.failed && state.error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.medium,
              AppSpacing.medium,
              AppSpacing.medium,
              0,
            ),
            child: _ErrorCard(message: state.error!),
          ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: FilledButton(
            onPressed: busy ? null : cubit.confirm,
            child: busy
                ? Semantics(
                    label: 'Booking',
                    child: const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                  )
                : Text(confirmLabel, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

/// Which event this is for: banner, title, when and where.
class _EventSummary extends StatelessWidget {
  const _EventSummary({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    return Card(
      margin: const EdgeInsets.all(AppSpacing.medium),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: 56,
              child: EventBanner(category: event.category, iconSize: 24),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: theme.textTheme.titleMedium),
                  Text(
                    EventFormats.start(
                      event.time,
                      use24HourFormat: use24,
                      zone: EventFormats.zoneFor(
                        event,
                        UserTimeZone.of(context),
                      ),
                    ),
                  ),
                  Text(EventFormats.place(event.location)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Why the booking failed. A live region, so a screen reader announces it.
class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.errorContainer,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: scheme.onErrorContainer),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(
                  'Not booked. $message',
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
