import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer.freezed.dart';

/// Who runs events. Whether *you* follow them is the user's own data
/// (Phase 6), joined in.
@freezed
abstract class Organizer with _$Organizer {
  const factory Organizer({
    required String id,
    required String name,
    required String bio,
    required int followers,

    /// Their events in the catalog, as the server counts them.
    required int eventsCount,
  }) = _Organizer;
}
