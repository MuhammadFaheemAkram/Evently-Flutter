import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';

/// The server, as the app sees it. Every call can fail with a
/// `NetworkException`; a booking can also be refused
/// (`SoldOutException`, `AlreadyBookedException`,
/// `BookingClosedException`).
abstract interface class EventlyApi {
  /// The whole catalog: organizers, and events with their offers and
  /// sessions.
  Future<CatalogDto> fetchCatalog();

  /// The demo user's data: a profile, saved events, tickets, bookmarks and
  /// follows.
  Future<DemoUserDto> fetchDemoUser();

  /// Books a place: the new ticket, and the event as it now stands.
  Future<BookingDto> rsvp(RsvpRequestDto request);

  /// Cancels a booking, giving its place back: the event as it now stands.
  Future<EventDto> cancelRsvp(CancelRequestDto request);
}
