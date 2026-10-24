import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/user_data.dart';
import 'package:evently/domain/model/user_profile.dart';

// The user's data: the demo DTO → domain (checked), domain ⇄ rows.

extension DemoUserDtoToDomain on DemoUserDto {
  /// The demo user, after checking what a type can't express. Throws a
  /// [FormatException] naming the first rule broken; nothing is written.
  ///
  /// - each event saved once, each session bookmarked once, each organizer
  ///   followed once; ticket ids and codes unique, one ticket per event;
  /// - a profile with a name and an email; an avatar only over https.
  ///
  /// Whether the events, sessions and organizers exist is the database's
  /// to say: its foreign keys refuse the whole write otherwise.
  UserData toUserData() {
    void check(bool condition, String problem) {
      if (!condition) throw FormatException('Demo user: $problem');
    }

    bool unique(Iterable<String> values) =>
        values.toSet().length == values.length;

    check(unique(saved.map((s) => s.eventId)), 'an event saved twice');
    check(
      unique(bookmarks.map((b) => b.sessionId)),
      'a session bookmarked twice',
    );
    check(
      unique(follows.map((f) => f.organizerId)),
      'an organizer followed twice',
    );
    check(unique(tickets.map((t) => t.id)), 'a ticket id twice');
    check(unique(tickets.map((t) => t.code)), 'a ticket code twice');
    check(unique(tickets.map((t) => t.eventId)), 'two tickets for one event');

    final profile = this.profile;
    UserProfile? domainProfile;
    if (profile != null) {
      check(profile.name.trim().isNotEmpty, 'a profile with no name');
      check(profile.email.contains('@'), 'a profile with no email');
      final avatar = profile.avatarUrl == null
          ? null
          : Uri.tryParse(profile.avatarUrl!);
      check(
        profile.avatarUrl == null || (avatar?.isScheme('https') ?? false),
        "an avatar that isn't https",
      );
      domainProfile = UserProfile(
        name: profile.name,
        email: profile.email,
        avatarUrl: avatar,
      );
    }

    return UserData(
      profile: domainProfile,
      saved: [
        for (final s in saved)
          SavedEvent(eventId: s.eventId, savedAt: s.savedAt.toUtc()),
      ],
      tickets: [
        for (final t in tickets)
          Ticket(
            id: t.id,
            eventId: t.eventId,
            code: t.code,
            type: t.type,
            note: t.note,
            bookedAt: t.bookedAt.toUtc(),
          ),
      ],
      bookmarks: [
        for (final b in bookmarks)
          SessionBookmark(
            sessionId: b.sessionId,
            createdAt: b.createdAt.toUtc(),
          ),
      ],
      follows: [
        for (final f in follows)
          Follow(organizerId: f.organizerId, followedAt: f.followedAt.toUtc()),
      ],
    );
  }
}

extension UserDataToRows on UserData {
  UserRows toRows() {
    final profile = this.profile;
    return UserRows(
      profile: profile == null
          ? null
          : ProfileRow(
              id: 1,
              name: profile.name,
              email: profile.email,
              avatarUrl: profile.avatarUrl,
            ),
      saved: [
        for (final s in saved)
          SavedEventRow(eventId: s.eventId, savedAt: s.savedAt),
      ],
      tickets: [for (final t in tickets) t.toRow()],
      bookmarks: [
        for (final b in bookmarks)
          SessionBookmarkRow(sessionId: b.sessionId, createdAt: b.createdAt),
      ],
      follows: [
        for (final f in follows)
          FollowRow(organizerId: f.organizerId, followedAt: f.followedAt),
      ],
    );
  }
}

extension TicketToRow on Ticket {
  TicketRow toRow() => TicketRow(
    id: id,
    eventId: eventId,
    code: code,
    type: type,
    note: note,
    bookedAt: bookedAt,
    cancelledAt: cancelledAt,
  );
}

extension TicketRowToDomain on TicketRow {
  Ticket toDomain() => Ticket(
    id: id,
    eventId: eventId,
    code: code,
    type: type,
    note: note,
    bookedAt: bookedAt,
    cancelledAt: cancelledAt,
  );
}

extension UserRowsToDomain on UserRows {
  UserData toUserData() {
    final profile = this.profile;
    return UserData(
      profile: profile == null
          ? null
          : UserProfile(
              name: profile.name,
              email: profile.email,
              avatarUrl: profile.avatarUrl,
            ),
      saved: [
        for (final row in saved)
          SavedEvent(eventId: row.eventId, savedAt: row.savedAt),
      ],
      tickets: [for (final row in tickets) row.toDomain()],
      bookmarks: [
        for (final row in bookmarks)
          SessionBookmark(sessionId: row.sessionId, createdAt: row.createdAt),
      ],
      follows: [
        for (final row in follows)
          Follow(organizerId: row.organizerId, followedAt: row.followedAt),
      ],
    );
  }
}
