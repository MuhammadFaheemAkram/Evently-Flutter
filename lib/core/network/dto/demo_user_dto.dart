import 'package:evently/domain/model/event_enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'demo_user_dto.g.dart';

// The demo user's own data, as the API sends it: a profile, and what they
// saved, booked, bookmarked and follow. Ids point at the catalog.

@JsonSerializable(createToJson: false, checked: true)
class DemoUserDto {
  const DemoUserDto({
    this.profile,
    this.saved = const [],
    this.tickets = const [],
    this.bookmarks = const [],
    this.follows = const [],
  });

  factory DemoUserDto.fromJson(Map<String, dynamic> json) =>
      _$DemoUserDtoFromJson(json);

  final ProfileDto? profile;
  final List<SavedEventDto> saved;
  final List<TicketDto> tickets;
  final List<BookmarkDto> bookmarks;
  final List<FollowDto> follows;
}

@JsonSerializable(createToJson: false, checked: true)
class ProfileDto {
  const ProfileDto({required this.name, required this.email, this.avatarUrl});

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  final String name;
  final String email;
  final String? avatarUrl;
}

@JsonSerializable(createToJson: false, checked: true)
class SavedEventDto {
  const SavedEventDto({required this.eventId, required this.savedAt});

  factory SavedEventDto.fromJson(Map<String, dynamic> json) =>
      _$SavedEventDtoFromJson(json);

  final String eventId;
  final DateTime savedAt;
}

@JsonSerializable(createToJson: false, checked: true)
class TicketDto {
  const TicketDto({
    required this.id,
    required this.eventId,
    required this.code,
    required this.type,
    required this.bookedAt,
    this.note = '',
  });

  factory TicketDto.fromJson(Map<String, dynamic> json) =>
      _$TicketDtoFromJson(json);

  final String id;
  final String eventId;
  final String code;
  final TicketType type;
  final String note;
  final DateTime bookedAt;
}

@JsonSerializable(createToJson: false, checked: true)
class BookmarkDto {
  const BookmarkDto({required this.sessionId, required this.createdAt});

  factory BookmarkDto.fromJson(Map<String, dynamic> json) =>
      _$BookmarkDtoFromJson(json);

  final String sessionId;
  final DateTime createdAt;
}

@JsonSerializable(createToJson: false, checked: true)
class FollowDto {
  const FollowDto({required this.organizerId, required this.followedAt});

  factory FollowDto.fromJson(Map<String, dynamic> json) =>
      _$FollowDtoFromJson(json);

  final String organizerId;
  final DateTime followedAt;
}
