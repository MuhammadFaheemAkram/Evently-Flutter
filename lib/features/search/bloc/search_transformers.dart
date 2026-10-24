import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:evently/features/search/bloc/search_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

/// Debounce + restartable: the reason Search is a Bloc rather than a Cubit.
///
/// - **Filters, blank text and immediate queries pass straight through.**
///   Applying filters searches at once, clearing the field goes idle at
///   once, a tapped recent search runs at once, and `switchMap` drops any
///   query still waiting out its delay.
/// - **Typed text is debounced.** Each keystroke replaces the pending
///   delayed event (`switchMap` to a delayed value *is* a debounce), so only
///   the last text typed within [duration] runs.
/// - **Restartable.** A newer input cancels the running handler and its
///   live results (`emit.forEach`), which would otherwise keep overwriting
///   the screen with an older search's matches.
EventTransformer<SearchInputChanged> debounceRestartable(Duration duration) {
  return (events, mapper) => restartable<SearchInputChanged>()(
    events.switchMap(
      (event) =>
          event.immediate ||
              (event is SearchQueryChanged && event.query.trim().isEmpty)
          ? Stream.value(event)
          : Stream.fromFuture(
              Future<SearchInputChanged>.delayed(duration, () => event),
            ),
    ),
    mapper,
  );
}
