import 'package:evently/core/common/result.dart';

/// The last searches the user acted on.
abstract interface class RecentSearchesRepository {
  /// Newest first, at most ten, kept current.
  Stream<List<String>> watch();

  /// Puts [query] first (once: case doesn't make a new entry).
  Future<Result<void>> save(String query);

  Future<Result<void>> clear();
}
