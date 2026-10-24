import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:evently/features/tickets/cubit/tickets_cubit.dart';
import 'package:evently/features/tickets/cubit/tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TicketsCubit>()..load(),
      child: const TicketsView(),
    );
  }
}

/// Tickets (a tab): Upcoming and Past, by each event's end, offline.
class TicketsView extends StatelessWidget {
  const TicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TicketsCubit>().state;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const DrawerMenuButton(),
          title: const Text('Tickets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: switch (state.status) {
          TicketsStatus.loading => const LoadingView(),
          TicketsStatus.ready => TabBarView(
            children: [
              _TicketList(
                tickets: state.upcoming,
                empty: EmptyStateView(
                  icon: Icons.confirmation_number_outlined,
                  title: 'No upcoming tickets',
                  message: 'RSVP to an event and your ticket appears here.',
                  action: FilledButton.tonal(
                    onPressed: () => const DiscoverRoute().go(context),
                    child: const Text('Discover events'),
                  ),
                ),
              ),
              _TicketList(
                tickets: state.past,
                empty: const EmptyStateView(
                  icon: Icons.history,
                  title: 'No past tickets',
                  message: 'Tickets for events that are over stay here.',
                ),
              ),
            ],
          ),
        },
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  const _TicketList({required this.tickets, required this.empty});

  final List<TicketItem> tickets;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) return empty;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final item = tickets[index];
        return TicketCard(
          item: item,
          onTap: () =>
              TicketDetailRoute(ticketId: item.ticket.id).push<void>(context),
        );
      },
    );
  }
}
