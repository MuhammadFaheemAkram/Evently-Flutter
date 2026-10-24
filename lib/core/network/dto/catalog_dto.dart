import 'package:evently/domain/model/event_enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'catalog_dto.g.dart';

// The catalog as the API sends it: what a real server's JSON would look
// like. Instants are ISO-8601 with an offset ("2026-10-24T18:30:00+0100"),
// and every event names its IANA time zone.
//
// `checked: true` turns a missing or mistyped field into a
// `CheckedFromJsonException`, which the repository reports as damaged data.
// The rules a type can't express (an event that ends before it starts, a
// session outside its event) are checked by the mapper.

@JsonSerializable(createToJson: false, checked: true)
class CatalogDto {
  const CatalogDto({required this.organizers, required this.events});

  factory CatalogDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogDtoFromJson(json);

  final List<OrganizerDto> organizers;
  final List<EventDto> events;
}

@JsonSerializable(createToJson: false, checked: true)
class OrganizerDto {
  const OrganizerDto({
    required this.id,
    required this.name,
    required this.bio,
    required this.followers,
    required this.eventsCount,
  });

  factory OrganizerDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerDtoFromJson(json);

  final String id;
  final String name;
  final String bio;
  final int followers;
  final int eventsCount;
}

@JsonSerializable(createToJson: false, checked: true)
class EventDto {
  const EventDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.organizerId,
    required this.startsAt,
    required this.endsAt,
    required this.timeZone,
    required this.attendeeCount,
    required this.capacity,
    required this.offers,
    this.venue,
    this.joinUrl,
    this.featured = false,
    this.status = EventStatus.scheduled,
    this.previousStartsAt,
    this.sessions = const [],
  });

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final String organizerId;
  final DateTime startsAt;
  final DateTime endsAt;

  /// IANA ("Europe/London").
  final String timeZone;

  /// An in-person event's place; `null` online.
  final VenueDto? venue;

  /// An online event's link; `null` in person.
  final String? joinUrl;
  final bool featured;
  final int attendeeCount;
  final int capacity;
  final EventStatus status;
  final DateTime? previousStartsAt;
  final List<OfferDto> offers;
  final List<SessionDto> sessions;
}

@JsonSerializable(createToJson: false, checked: true)
class VenueDto {
  const VenueDto({
    required this.name,
    required this.address,
    required this.city,
  });

  factory VenueDto.fromJson(Map<String, dynamic> json) =>
      _$VenueDtoFromJson(json);

  final String name;
  final String address;
  final String city;
}

@JsonSerializable(createToJson: false, checked: true)
class OfferDto {
  const OfferDto({
    required this.type,
    required this.priceMinor,
    required this.currency,
    required this.capacity,
    required this.remaining,
  });

  factory OfferDto.fromJson(Map<String, dynamic> json) =>
      _$OfferDtoFromJson(json);

  final TicketType type;
  final int priceMinor;
  final String currency;
  final int capacity;
  final int remaining;
}

@JsonSerializable(createToJson: false, checked: true)
class SessionDto {
  const SessionDto({
    required this.id,
    required this.title,
    required this.speaker,
    required this.room,
    required this.startsAt,
    required this.endsAt,
  });

  factory SessionDto.fromJson(Map<String, dynamic> json) =>
      _$SessionDtoFromJson(json);

  final String id;
  final String title;
  final String speaker;
  final String room;
  final DateTime startsAt;
  final DateTime endsAt;
}
