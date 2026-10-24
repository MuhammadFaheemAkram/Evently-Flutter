import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/features/search/bloc/search_bloc.dart';
import 'package:evently/features/search/bloc/search_event.dart';
import 'package:evently/features/search/bloc/search_state.dart';
import 'package:evently/features/search/widgets/filter_sheet.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SearchBloc>()..add(const SearchSubscriptionRequested()),
      child: SearchView(today: getIt<EventClock>().today),
    );
  }
}

/// Search (a tab): text and filters over the cached events, offline.
///
/// Fewer than two characters and no filter shows the recent searches;
/// filters alone search too.
class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.today});

  /// The user's day, when the filter sheet opens.
  final CalendarDate Function() today;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _field = TextEditingController();

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final bloc = context.read<SearchBloc>();
    final applied = await showFilterSheet(
      context,
      current: bloc.state.filter,
      today: widget.today(),
    );
    if (applied != null) bloc.add(SearchFiltersChanged(applied));
  }

  void _reuse(String query) {
    _field.text = query;
    context.read<SearchBloc>().add(SearchQueryChanged(query, immediate: true));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();
    final state = context.watch<SearchBloc>().state;
    final active = FilterLabels.active(state.filter);
    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (previous, current) =>
          previous.messageSerial != current.messageSerial,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message ?? ''))),
      child: Scaffold(
        appBar: AppBar(
          leading: const DrawerMenuButton(),
          title: const Text('Search'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.medium,
                AppSpacing.xSmall,
                AppSpacing.xSmall,
                AppSpacing.xSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      controller: _field,
                      hintText: 'Events, organizers, places',
                      onChanged: (text) => bloc.add(SearchQueryChanged(text)),
                      onSubmitted: (text) {
                        bloc
                          ..add(SearchQueryChanged(text, immediate: true))
                          ..add(const SearchResultOpened());
                      },
                      onCleared: () => bloc.add(const SearchQueryChanged('')),
                    ),
                  ),
                  _FilterButton(
                    count: state.filter.activeCount,
                    onPressed: _openFilters,
                  ),
                ],
              ),
            ),
            if (active.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.medium,
                  0,
                  AppSpacing.medium,
                  AppSpacing.xSmall,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: AppSpacing.xSmall,
                    runSpacing: AppSpacing.xSmall,
                    children: [
                      for (final (label, without) in active)
                        InputChip(
                          label: Text(label),
                          onDeleted: () =>
                              bloc.add(SearchFiltersChanged(without)),
                          deleteButtonTooltipMessage: 'Remove $label',
                        ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: _Body(state: state, onReuse: _reuse),
            ),
          ],
        ),
      ),
    );
  }
}

/// The filter sheet's button, with a badge counting the filters that are
/// on (and saying so to a screen reader).
class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: count == 0 ? 'Filters' : 'Filters, $count on',
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.tune),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.onReuse});

  final SearchState state;
  final ValueChanged<String> onReuse;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();
    switch (state.status) {
      case SearchStatus.idle:
        return _RecentSearches(
          searches: state.recentSearches,
          onReuse: onReuse,
          onClear: () => bloc.add(const SearchRecentSearchesCleared()),
        );
      case SearchStatus.failure:
        return const ErrorView(message: "Couldn't search the events.");
      case SearchStatus.searching when state.results.isEmpty:
        return const LoadingView(message: 'Searching');
      case SearchStatus.searching || SearchStatus.results:
        if (state.results.isEmpty) {
          final filtered = state.filter.hasFilters;
          return EmptyStateView(
            icon: Icons.search_off,
            title: 'No events match',
            message: filtered
                ? 'Try fewer filters, or other words.'
                : 'Try other words, or the filters.',
            action: filtered
                ? TextButton(
                    onPressed: () => bloc.add(
                      SearchFiltersChanged(state.filter.withoutFilters),
                    ),
                    child: const Text('Clear filters'),
                  )
                : null,
          );
        }
        return _Results(state: state);
    }
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.searches,
    required this.onReuse,
    required this.onClear,
  });

  final List<String> searches;
  final ValueChanged<String> onReuse;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const EmptyStateView(
        icon: Icons.search,
        title: 'Find an event',
        message:
            'Search by title, organizer, venue or city, or narrow down '
            'with the filters. Works offline.',
      );
    }
    return ListView(
      children: [
        SectionHeader(
          'Recent searches',
          action: TextButton(
            onPressed: onClear,
            child: const Text('Clear all'),
          ),
        ),
        for (final search in searches)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(search),
            onTap: () => onReuse(search),
          ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();
    final results = state.results;
    void open(EventCardItem item) {
      bloc.add(const SearchResultOpened());
      EventDetailRoute(eventId: item.event.id).push<void>(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      itemCount: results.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Semantics(
            liveRegion: true,
            child: SectionHeader(
              '${results.length} ${results.length == 1 ? 'event' : 'events'}',
            ),
          );
        }
        final item = results[index - 1];
        return EventCard(
          item: item,
          rsvpBlock: state.rsvpBlockFor(item),
          onTap: () => open(item),
          onToggleSaved: () => bloc.add(SearchSaveToggled(item)),
          onRsvp: () => RsvpRoute(eventId: item.event.id).push<void>(context),
        );
      },
    );
  }
}
