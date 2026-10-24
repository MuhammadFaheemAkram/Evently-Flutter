// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'catalog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogDto _$CatalogDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CatalogDto', json, ($checkedConvert) {
      final val = CatalogDto(
        organizers: $checkedConvert(
          'organizers',
          (v) => (v as List<dynamic>)
              .map((e) => OrganizerDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        events: $checkedConvert(
          'events',
          (v) => (v as List<dynamic>)
              .map((e) => EventDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

OrganizerDto _$OrganizerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OrganizerDto', json, ($checkedConvert) {
      final val = OrganizerDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        bio: $checkedConvert('bio', (v) => v as String),
        followers: $checkedConvert('followers', (v) => (v as num).toInt()),
        eventsCount: $checkedConvert('eventsCount', (v) => (v as num).toInt()),
      );
      return val;
    });

EventDto _$EventDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EventDto', json, ($checkedConvert) {
  final val = EventDto(
    id: $checkedConvert('id', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String),
    category: $checkedConvert(
      'category',
      (v) => $enumDecode(_$EventCategoryEnumMap, v),
    ),
    organizerId: $checkedConvert('organizerId', (v) => v as String),
    startsAt: $checkedConvert('startsAt', (v) => DateTime.parse(v as String)),
    endsAt: $checkedConvert('endsAt', (v) => DateTime.parse(v as String)),
    timeZone: $checkedConvert('timeZone', (v) => v as String),
    attendeeCount: $checkedConvert('attendeeCount', (v) => (v as num).toInt()),
    capacity: $checkedConvert('capacity', (v) => (v as num).toInt()),
    offers: $checkedConvert(
      'offers',
      (v) => (v as List<dynamic>)
          .map((e) => OfferDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    venue: $checkedConvert(
      'venue',
      (v) => v == null ? null : VenueDto.fromJson(v as Map<String, dynamic>),
    ),
    joinUrl: $checkedConvert('joinUrl', (v) => v as String?),
    featured: $checkedConvert('featured', (v) => v as bool? ?? false),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$EventStatusEnumMap, v) ?? EventStatus.scheduled,
    ),
    previousStartsAt: $checkedConvert(
      'previousStartsAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    sessions: $checkedConvert(
      'sessions',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => SessionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    ),
  );
  return val;
});

const _$EventCategoryEnumMap = {
  EventCategory.technology: 'technology',
  EventCategory.business: 'business',
  EventCategory.design: 'design',
  EventCategory.sports: 'sports',
  EventCategory.education: 'education',
  EventCategory.music: 'music',
  EventCategory.community: 'community',
  EventCategory.health: 'health',
};

const _$EventStatusEnumMap = {
  EventStatus.scheduled: 'scheduled',
  EventStatus.moved: 'moved',
  EventStatus.cancelled: 'cancelled',
};

VenueDto _$VenueDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VenueDto', json, ($checkedConvert) {
      final val = VenueDto(
        name: $checkedConvert('name', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String),
      );
      return val;
    });

OfferDto _$OfferDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'OfferDto',
  json,
  ($checkedConvert) {
    final val = OfferDto(
      type: $checkedConvert('type', (v) => $enumDecode(_$TicketTypeEnumMap, v)),
      priceMinor: $checkedConvert('priceMinor', (v) => (v as num).toInt()),
      currency: $checkedConvert('currency', (v) => v as String),
      capacity: $checkedConvert('capacity', (v) => (v as num).toInt()),
      remaining: $checkedConvert('remaining', (v) => (v as num).toInt()),
    );
    return val;
  },
);

const _$TicketTypeEnumMap = {
  TicketType.free: 'free',
  TicketType.standard: 'standard',
  TicketType.vip: 'vip',
  TicketType.workshop: 'workshop',
};

SessionDto _$SessionDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'SessionDto',
  json,
  ($checkedConvert) {
    final val = SessionDto(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      speaker: $checkedConvert('speaker', (v) => v as String),
      room: $checkedConvert('room', (v) => v as String),
      startsAt: $checkedConvert('startsAt', (v) => DateTime.parse(v as String)),
      endsAt: $checkedConvert('endsAt', (v) => DateTime.parse(v as String)),
    );
    return val;
  },
);
