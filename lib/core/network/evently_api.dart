import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';

/// The app's "remote" API.
///
/// Evently is offline-first: every screen reads the drift cache, and the
/// API only fills it. It still looks like a real API (async, typed DTOs,
/// throwing `AppException`s), so a real implementation could replace the
/// fake without changing any caller. Phase 5 adds booking (`rsvp`,
/// `cancelRsvp`).
abstract interface class EventlyApi {
  /// The whole catalog: organizers, and events with their ticket offers
  /// and sessions.
  ///
  /// Throws a `NetworkException` when the request fails, and a
  /// `FormatException` (or `CheckedFromJsonException`) for malformed data.
  Future<CatalogDto> fetchCatalog();

  /// The demo user: a profile, saved events, tickets, bookmarks, follows.
  Future<DemoUserDto> fetchDemoUser();
}
