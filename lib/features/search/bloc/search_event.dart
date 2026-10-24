import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_filter.dart';

sealed class SearchEvent {
  const SearchEvent();
}

/// The screen opened: follow the recent searches while it lives.
final class SearchSubscriptionRequested extends SearchEvent {
  const SearchSubscriptionRequested();
}

/// What to search for changed: the text or the filters. One kind of event,
/// so one transformer orders them, and a newer one always wins.
sealed class SearchInputChanged extends SearchEvent {
  const SearchInputChanged();

  /// Runs at once instead of after the debounce.
  bool get immediate;
}

/// The field changed. Debounced, unless [immediate] (a recent search tapped,
/// the keyboard's Search key) or blank.
final class SearchQueryChanged extends SearchInputChanged {
  const SearchQueryChanged(this.query, {this.immediate = false});

  final String query;

  @override
  final bool immediate;
}

/// The filters were applied or a filter chip removed: at once. The text
/// stays as it is.
final class SearchFiltersChanged extends SearchInputChanged {
  const SearchFiltersChanged(this.filter);

  final EventFilter filter;

  @override
  bool get immediate => true;
}

/// A result was opened: remember the text (the view navigates).
final class SearchResultOpened extends SearchEvent {
  const SearchResultOpened();
}

final class SearchRecentSearchesCleared extends SearchEvent {
  const SearchRecentSearchesCleared();
}

/// Save or unsave a result.
final class SearchSaveToggled extends SearchEvent {
  const SearchSaveToggled(this.item);

  final EventCardItem item;
}
