import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:material_ui/material_ui.dart';

/// Opens the filter sheet on [current], and returns the filters the user
/// applied (`null` if they closed it). [today] is the user's day: custom
/// dates start there, since Search finds only what's still to come.
Future<EventFilter?> showFilterSheet(
  BuildContext context, {
  required EventFilter current,
  required CalendarDate today,
}) {
  return showModalBottomSheet<EventFilter>(
    context: context,
    // Above the tab bar, like every modal: shown from the tab's own
    // navigator, the sheet would stop at the bar and hide its buttons
    // (conventions §11.46).
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => FilterSheet(initial: current, today: today),
  );
}

/// Categories, dates, price, format and your RSVP, edited as a draft:
/// nothing changes until Apply. Chips wrap onto new rows, so large text
/// never squeezes them.
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.initial, required this.today});

  final EventFilter initial;
  final CalendarDate today;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late EventFilter _draft = widget.initial;

  void _update(EventFilter filter) => setState(() => _draft = filter);

  Future<void> _pickDates() async {
    final from = _draft.from;
    final to = _draft.to;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: widget.today.toDateTime(),
      lastDate: widget.today.addDays(365).toDateTime(),
      initialDateRange: from != null && to != null
          ? DateTimeRange(start: from.toDateTime(), end: to.toDateTime())
          : null,
    );
    if (picked == null) return;
    _update(
      _draft.copyWith(
        dates: DatePreset.custom,
        from: CalendarDate.fromDateTime(picked.start),
        to: CalendarDate.fromDateTime(picked.end),
      ),
    );
  }

  Widget _choices<T>({
    required List<T> values,
    required T selected,
    required String Function(T value) label,
    required ValueChanged<T> onSelected,
  }) => Wrap(
    spacing: AppSpacing.xSmall,
    runSpacing: AppSpacing.xSmall,
    children: [
      for (final value in values)
        ChoiceChip(
          label: Text(label(value)),
          selected: selected == value,
          onSelected: (_) => onSelected(value),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final from = _draft.from;
    final to = _draft.to;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        0,
        AppSpacing.medium,
        AppSpacing.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text('Filters', style: theme.textTheme.titleLarge),
          ),
          _Section(
            title: 'Categories',
            child: Wrap(
              spacing: AppSpacing.xSmall,
              runSpacing: AppSpacing.xSmall,
              children: [
                for (final category in EventCategory.values)
                  FilterChip(
                    label: Text(category.label),
                    selected: _draft.categories.contains(category),
                    onSelected: (selected) => _update(
                      _draft.copyWith(
                        categories: selected
                            ? {..._draft.categories, category}
                            : ({..._draft.categories}..remove(category)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _Section(
            title: 'Dates',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.xSmall,
                  runSpacing: AppSpacing.xSmall,
                  children: [
                    for (final preset in DatePreset.values)
                      ChoiceChip(
                        label: Text(FilterLabels.dates(preset)),
                        selected: _draft.dates == preset,
                        onSelected: (_) => preset == DatePreset.custom
                            ? _pickDates()
                            : _update(
                                _draft.copyWith(
                                  dates: preset,
                                  from: null,
                                  to: null,
                                ),
                              ),
                      ),
                  ],
                ),
                if (_draft.dates == DatePreset.custom &&
                    from != null &&
                    to != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xSmall),
                    child: OutlinedButton.icon(
                      onPressed: _pickDates,
                      icon: const Icon(Icons.date_range),
                      label: Text(FilterLabels.range(from, to)),
                    ),
                  ),
              ],
            ),
          ),
          _Section(
            title: 'Price',
            child: _choices(
              values: PriceFilter.values,
              selected: _draft.price,
              label: FilterLabels.price,
              onSelected: (price) => _update(_draft.copyWith(price: price)),
            ),
          ),
          _Section(
            title: 'Format',
            child: _choices(
              values: FormatFilter.values,
              selected: _draft.format,
              label: FilterLabels.format,
              onSelected: (format) => _update(_draft.copyWith(format: format)),
            ),
          ),
          _Section(
            title: 'Your RSVP',
            child: _choices(
              values: RsvpFilter.values,
              selected: _draft.rsvp,
              label: FilterLabels.rsvp,
              onSelected: (rsvp) => _update(_draft.copyWith(rsvp: rsvp)),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              TextButton(
                onPressed: () => _update(_draft.withoutFilters),
                child: const Text('Reset'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_draft),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: AppSpacing.xSmall),
          child,
        ],
      ),
    );
  }
}
