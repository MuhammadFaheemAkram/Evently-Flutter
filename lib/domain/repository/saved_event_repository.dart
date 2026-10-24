import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/event_card_item.dart';

/// The events you saved. Local only, so saving works offline.
abstract interface class SavedEventRepository {
  /// The events you saved, soonest first, kept current.
  Stream<List<EventCardItem>> watch();

  Future<Result<void>> save(String eventId);

  Future<Result<void>> unsave(String eventId);
}
