// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'demo_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemoUserDto _$DemoUserDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'DemoUserDto',
  json,
  ($checkedConvert) {
    final val = DemoUserDto(
      profile: $checkedConvert(
        'profile',
        (v) =>
            v == null ? null : ProfileDto.fromJson(v as Map<String, dynamic>),
      ),
      saved: $checkedConvert(
        'saved',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => SavedEventDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      tickets: $checkedConvert(
        'tickets',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => TicketDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      bookmarks: $checkedConvert(
        'bookmarks',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => BookmarkDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
      follows: $checkedConvert(
        'follows',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => FollowDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
    );
    return val;
  },
);

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProfileDto', json, ($checkedConvert) {
      final val = ProfileDto(
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
      );
      return val;
    });

SavedEventDto _$SavedEventDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SavedEventDto', json, ($checkedConvert) {
      final val = SavedEventDto(
        eventId: $checkedConvert('eventId', (v) => v as String),
        savedAt: $checkedConvert('savedAt', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

TicketDto _$TicketDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TicketDto',
  json,
  ($checkedConvert) {
    final val = TicketDto(
      id: $checkedConvert('id', (v) => v as String),
      eventId: $checkedConvert('eventId', (v) => v as String),
      code: $checkedConvert('code', (v) => v as String),
      type: $checkedConvert('type', (v) => $enumDecode(_$TicketTypeEnumMap, v)),
      bookedAt: $checkedConvert('bookedAt', (v) => DateTime.parse(v as String)),
      note: $checkedConvert('note', (v) => v as String? ?? ''),
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

BookmarkDto _$BookmarkDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookmarkDto', json, ($checkedConvert) {
      final val = BookmarkDto(
        sessionId: $checkedConvert('sessionId', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

FollowDto _$FollowDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FollowDto', json, ($checkedConvert) {
      final val = FollowDto(
        organizerId: $checkedConvert('organizerId', (v) => v as String),
        followedAt: $checkedConvert(
          'followedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });
