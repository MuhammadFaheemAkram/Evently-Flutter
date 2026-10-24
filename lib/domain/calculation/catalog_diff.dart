import 'package:evently/domain/model/event_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_diff.freezed.dart';

/// An event as change detection compares it: when it starts, and the
/// organizer's word on it.
typedef EventVersion = ({String id, DateTime start, EventStatus status});

/// What changed between two catalogs, by event id.
@freezed
abstract class CatalogDiff with _$CatalogDiff {
  const factory CatalogDiff({
    /// Its start changed, and it's still on.
    @Default(<String>[]) List<String> moved,

    /// It was on, and now it's off.
    @Default(<String>[]) List<String> cancelled,

    /// It wasn't there before.
    @Default(<String>[]) List<String> added,
  }) = _CatalogDiff;

  const CatalogDiff._();

  bool get isEmpty => moved.isEmpty && cancelled.isEmpty && added.isEmpty;
}

/// The changes from [before] to [after] (the cache before and after a
/// sync), each list in [after]'s order.
///
/// **In the domain, not the database:** what counts as "moved" is a rule
/// of the app, not of SQL, and here it's tested with plain values. The
/// sync calls it inside the transaction that writes the new catalog, so
/// the comparison and the write see the same rows.
///
/// - **Moved:** the start instant changed (an event told in another zone,
///   or edited without moving, hasn't moved). A cancelled event isn't
///   "moved" too: cancelled wins.
/// - **Cancelled:** off now, on before. The sync marks an event gone from
///   the server cancelled before this runs, so a vanished event counts.
/// - **Added:** not in [before].
/// - Back on after a cancellation is no change to alert about: the event
///   simply reads "on" again.
CatalogDiff diffCatalog(
  Iterable<EventVersion> before,
  Iterable<EventVersion> after,
) {
  final previous = {for (final version in before) version.id: version};
  final moved = <String>[];
  final cancelled = <String>[];
  final added = <String>[];
  for (final now in after) {
    final then = previous[now.id];
    if (then == null) {
      added.add(now.id);
    } else if (now.status == EventStatus.cancelled) {
      if (then.status != EventStatus.cancelled) cancelled.add(now.id);
    } else if (!now.start.isAtSameMomentAs(then.start)) {
      moved.add(now.id);
    }
  }
  return CatalogDiff(moved: moved, cancelled: cancelled, added: added);
}

/// The changes worth recording: the moved and cancelled events among
/// [ticketed] (those you hold an active ticket for). A change to an event
/// you only saved shows on its card, with no alert.
List<({String eventId, EventChangeKind kind})> changesToRecord(
  CatalogDiff diff,
  Set<String> ticketed,
) => [
  for (final id in diff.moved)
    if (ticketed.contains(id)) (eventId: id, kind: EventChangeKind.moved),
  for (final id in diff.cancelled)
    if (ticketed.contains(id)) (eventId: id, kind: EventChangeKind.cancelled),
];
