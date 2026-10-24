import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/features/saved/cubit/saved_cubit.dart';
import 'package:evently/features/saved/cubit/saved_state.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SavedCubit>()..load(),
      child: const SavedView(),
    );
  }
}

/// Saved (a tab): your saved events, offline. Swipe one away, or tap its
/// bookmark, to remove it; the SnackBar offers Undo.
class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SavedCubit>();
    final state = context.watch<SavedCubit>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<SavedCubit, SavedState>(
          listenWhen: (previous, current) =>
              previous.removedSerial != current.removedSerial,
          listener: (context, state) {
            final removed = state.removed;
            if (removed == null) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Removed “${removed.event.title}”'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => cubit.undo(removed),
                  ),
                ),
              );
          },
        ),
        BlocListener<SavedCubit, SavedState>(
          listenWhen: (previous, current) =>
              previous.messageSerial != current.messageSerial,
          listener: (context, state) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message ?? ''))),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const DrawerMenuButton(),
          title: const Text('Saved'),
        ),
        body: switch (state.status) {
          SavedStatus.loading => const LoadingView(),
          SavedStatus.ready when state.isEmpty => EmptyStateView(
            icon: Icons.bookmark_border,
            title: 'Nothing saved yet',
            message:
                'Tap the bookmark on any event to keep it here. Saved events '
                'work offline.',
            action: FilledButton.tonal(
              onPressed: () => const DiscoverRoute().go(context),
              child: const Text('Discover events'),
            ),
          ),
          SavedStatus.ready => ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.large),
            children: [
              if (state.upcoming.isNotEmpty) ...[
                const SectionHeader('Coming up'),
                for (final item in state.upcoming) _SavedRow(item: item),
              ],
              if (state.past.isNotEmpty) ...[
                const SectionHeader('Past'),
                for (final item in state.past) _SavedRow(item: item),
              ],
            ],
          ),
        },
      ),
    );
  }
}

/// A saved event: swipe it away to remove it.
class _SavedRow extends StatelessWidget {
  const _SavedRow({required this.item});

  final EventCardItem item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SavedCubit>();
    final state = context.read<SavedCubit>().state;
    return Dismissible(
      key: ValueKey(item.event.id),
      direction: DismissDirection.endToStart,
      background: const _RemoveBackground(),
      onDismissed: (_) => cubit.remove(item),
      child: EventCard(
        item: item,
        rsvpBlock: state.rsvpBlockFor(item),
        onTap: () =>
            EventDetailRoute(eventId: item.event.id).push<void>(context),
        onToggleSaved: () => cubit.remove(item),
        onRsvp: () => RsvpRoute(eventId: item.event.id).push<void>(context),
      ),
    );
  }
}

/// Behind a row being swiped away: what the swipe does.
class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.errorContainer,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bookmark_remove_outlined,
                color: scheme.onErrorContainer,
              ),
              const SizedBox(width: AppSpacing.xSmall),
              Text('Remove', style: TextStyle(color: scheme.onErrorContainer)),
            ],
          ),
        ),
      ),
    );
  }
}
