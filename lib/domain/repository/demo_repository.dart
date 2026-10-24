import 'package:evently/core/common/result.dart';

/// The demo user, from the API into the user's tables.
abstract interface class DemoRepository {
  /// Fetches the demo user and replaces the user's data with it, in one
  /// transaction: on any failure, nothing has changed. The catalog must be
  /// cached first: the demo points at its events.
  Future<Result<void>> loadDemoUser();
}
