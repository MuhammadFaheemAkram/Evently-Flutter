import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:evently/features/discover/cubit/discover_state.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DiscoverCubit>()..load(),
      child: const DiscoverView(),
    );
  }
}

/// Discover (the first tab): featured events, events in your city, and
/// what's coming up by day, filtered by category. Pull to refresh.
class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: const Text('Discover'),
      ),
      body: BlocConsumer<DiscoverCubit, DiscoverState>(
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
          final cubit = context.read<DiscoverCubit>();
          return switch (state.status) {
            DiscoverStatus.loading => const LoadingView(
              message: 'Loading events',
            ),
            DiscoverStatus.failed => ErrorView(
              message: state.errorMessage ?? "Couldn't load the events.",
              onRetry: cubit.tryAgain,
            ),
            DiscoverStatus.empty => EmptyStateView(
              icon: Icons.event_busy_outlined,
              title: 'No events yet',
              message: 'Nothing is planned right now. Check back soon.',
              action: FilledButton.tonal(
                onPressed: cubit.refresh,
                child: const Text('Refresh'),
              ),
            ),
            DiscoverStatus.ready => RefreshIndicator.adaptive(
              onRefresh: cubit.refresh,
              child: _DiscoverLists(state: state),
            ),
          };
        },
      ),
    );
  }
}

class _DiscoverLists extends StatelessWidget {
  const _DiscoverLists({required this.state});

  final DiscoverState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DiscoverCubit>();
    void open(EventCardItem item) =>
        EventDetailRoute(eventId: item.event.id).push<void>(context);
    final city = state.city;
    final today = state.today;
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (state.featured.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SectionHeader('Featured')),
          SliverToBoxAdapter(
            child: _FeaturedPager(
              items: state.featured,
              onOpen: open,
              onToggleSaved: cubit.toggleSaved,
            ),
          ),
        ],
        if (city != null) ...[
          SliverToBoxAdapter(child: SectionHeader('In $city')),
          SliverToBoxAdapter(
            child: state.inYourCity.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                    ),
                    child: Text('Nothing coming up in $city yet.'),
                  )
                : _CityRow(
                    items: state.inYourCity,
                    onOpen: open,
                    onToggleSaved: cubit.toggleSaved,
                  ),
          ),
        ],
        const SliverToBoxAdapter(child: SectionHeader('Coming up')),
        SliverToBoxAdapter(
          child: _CategoryChips(
            selected: state.category,
            onSelected: cubit.selectCategory,
          ),
        ),
        if (state.upcoming.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                children: [
                  Text(
                    state.category == null
                        ? 'Nothing coming up.'
                        : 'No ${state.category!.label.toLowerCase()} events '
                              'coming up.',
                    textAlign: TextAlign.center,
                  ),
                  if (state.category != null)
                    TextButton(
                      onPressed: () => cubit.selectCategory(null),
                      child: const Text('Show all'),
                    ),
                ],
              ),
            ),
          ),
        for (final group in state.upcoming) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              today == null
                  ? group.day.toString()
                  : EventFormats.day(group.day, today: today),
            ),
          ),
          SliverList.builder(
            itemCount: group.items.length,
            itemBuilder: (context, index) {
              final item = group.items[index];
              return EventCard(
                item: item,
                rsvpBlock: state.rsvpBlockFor(item),
                onTap: () => open(item),
                onToggleSaved: () => cubit.toggleSaved(item),
                onRsvp: () =>
                    RsvpRoute(eventId: item.event.id).push<void>(context),
              );
            },
          ),
        ],
        const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.large)),
      ],
    );
  }
}

/// Featured events, one page each, with a page indicator.
class _FeaturedPager extends StatefulWidget {
  const _FeaturedPager({
    required this.items,
    required this.onOpen,
    required this.onToggleSaved,
  });

  final List<EventCardItem> items;
  final ValueChanged<EventCardItem> onOpen;
  final ValueChanged<EventCardItem> onToggleSaved;

  @override
  State<_FeaturedPager> createState() => _FeaturedPagerState();
}

class _FeaturedPagerState extends State<_FeaturedPager> {
  final _controller = PageController(viewportFraction: 0.88);
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    // A pager needs a fixed height: room for the card's text at the user's
    // text size (title and start on up to two lines each, place, "Going"),
    // and the banner takes the rest.
    final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final height = 140 + 132 * scale;
    final page = _page.clamp(0, items.length - 1);
    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) {
              final item = items[index];
              return FeaturedEventCard(
                item: item,
                onTap: () => widget.onOpen(item),
                onToggleSaved: () => widget.onToggleSaved(item),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xSmall),
        Semantics(
          label: 'Featured event ${page + 1} of ${items.length}',
          child: ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < items.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == page ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == page
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Upcoming in-person events in your city, side by side. The row sizes
/// itself to its tallest card, so it fits any text size.
class _CityRow extends StatelessWidget {
  const _CityRow({
    required this.items,
    required this.onOpen,
    required this.onToggleSaved,
  });

  final List<EventCardItem> items;
  final ValueChanged<EventCardItem> onOpen;
  final ValueChanged<EventCardItem> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.7;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xSmall),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: FeaturedEventCard(
                  item: item,
                  fillHeight: false,
                  onTap: () => onOpen(item),
                  onToggleSaved: () => onToggleSaved(item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// "All" and the eight categories, scrolling sideways.
class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onSelected});

  final EventCategory? selected;
  final ValueChanged<EventCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Row(
        children: [
          for (final category in <EventCategory?>[
            null,
            ...EventCategory.values,
          ])
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xSmall),
              child: CategoryChip(
                category: category,
                selected: selected == category,
                onSelected: () => onSelected(category),
              ),
            ),
        ],
      ),
    );
  }
}
