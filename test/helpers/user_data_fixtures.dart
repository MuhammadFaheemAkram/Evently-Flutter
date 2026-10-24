import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/user_data.dart';
import 'package:evently/domain/model/user_profile.dart';

// The user's data built in code, pointing at `catalog_fixtures`' ids
// (`ev_1`, `ses_1`, `org_1`).

final _at = DateTime.utc(2026, 10, 20, 9);

Ticket ticket({
  String id = 't1',
  String eventId = 'ev_1',
  String code = 'EVT-7KQ2-M9XX',
  DateTime? cancelledAt,
}) => Ticket(
  id: id,
  eventId: eventId,
  code: code,
  type: TicketType.free,
  note: 'Aisle seat',
  bookedAt: _at,
  cancelledAt: cancelledAt,
);

/// A profile, one of each kind of row, all on `ev_1`.
UserData userData({String eventId = 'ev_1'}) => UserData(
  profile: UserProfile(
    name: 'Sara Ahmed',
    email: 'sara@example.com',
    avatarUrl: Uri.parse('https://example.com/sara.png'),
  ),
  saved: [SavedEvent(eventId: eventId, savedAt: _at)],
  tickets: [ticket(eventId: eventId)],
  bookmarks: [SessionBookmark(sessionId: 'ses_1', createdAt: _at)],
  follows: [Follow(organizerId: 'org_1', followedAt: _at)],
);
