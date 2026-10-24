import 'package:evently/core/common/result.dart';

/// The events you saved. Local only, so saving works offline.
abstract interface class SavedEventRepository {
  Future<Result<void>> save(String eventId);

  Future<Result<void>> unsave(String eventId);
}
