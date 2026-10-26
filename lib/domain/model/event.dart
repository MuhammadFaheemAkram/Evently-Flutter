import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

/// Where an event happens: a place, or online. A sealed union, so a screen
/// can't show a venue's address for an online event, or forget one case
/// (the database's `CHECK`s say the same about the columns).
@freezed
sealed class EventLocation with _$EventLocation {
  const factory EventLocation.venue({
    required String name,
    required String address,
    required String city,
  }) = Venue;

  /// [joinUrl] is shown only to people going.
  const factory EventLocation.online({required Uri joinUrl}) = Online;
}

/// One kind of ticket an event sells: its price and its places.
@freezed
abstract class TicketOffer with _$TicketOffer {
  const factory TicketOffer({
    required TicketType type,

    /// In the currency's minor unit (pence, cents, paisa): money is never a
    /// `double`.
    required int priceMinor,

    /// ISO 4217 ("GBP").
    required String currency,
    required int capacity,

    /// Places left, as the server last said.
    required int remaining,
  }) = _TicketOffer;

  const TicketOffer._();

  bool get isFree => priceMinor == 0;

  bool get isSoldOut => remaining == 0;
}

/// An event, as the (fake) API serves it and the cache keeps it.
///
/// Nothing about *you* is here: whether you saved it, hold a ticket for it
/// or set a reminder lives in the user's own tables, joined when a screen
/// reads them (`EventCardItem`). A sync can rewrite every field
/// here without losing any of that.
@freezed
abstract class Event with _$Event {
  const factory Event({
    required String id,
    required String title,
    required String description,
    required EventCategory category,
    required String organizerId,
    required EventTime time,
    required EventLocation location,
    @Default(false) bool featured,

    /// People going, and the places in all, as the server counts them.
    required int attendeeCount,
    required int capacity,
    @Default(EventStatus.scheduled) EventStatus status,

    /// When a moved event used to start (UTC).
    DateTime? previousStart,

    /// Its ticket types, in the order the server lists them.
    required List<TicketOffer> offers,
  }) = _Event;

  const Event._();

  /// Places left across every ticket type.
  int get placesLeft => offers.fold(0, (left, offer) => left + offer.remaining);

  bool get isSoldOut => placesLeft == 0;

  /// Free when every ticket type is.
  bool get isFree => offers.every((offer) => offer.isFree);

  bool get isOnline => location is Online;
}
