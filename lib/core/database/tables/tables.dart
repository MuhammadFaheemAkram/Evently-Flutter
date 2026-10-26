// drift reads a column getter's *definition* at build time and never calls
// it. A getter naming itself inside `check(...)` is drift's documented way to
// write a CHECK constraint on that column, not a recursion (conventions
// §11.41).
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:evently/core/database/converters.dart';
import 'package:evently/domain/model/event_enums.dart';

// Two kinds of table, kept strictly apart:
//
// - **The catalog** (organizers, events, ticket offers, sessions): what the
//   server serves, cached. Only a sync writes it (and a booking the server
//   confirmed updates its event's counts). Never deleted by a sync: an event
//   gone from the server is marked cancelled instead.
// - **The user's** (saved events, tickets, bookmarks, follows, reminders,
//   recent searches, the profile, change alerts): what *you* did. Only your
//   actions write it.
//
// User rows point at catalog rows **without** `CASCADE`: a foreign key's
// default (`NO ACTION`) refuses to delete an event someone saved or holds a
// ticket for, so nothing the user owns can disappear with the cache (Clear
// cache deletes only what nothing points at).
//
// Instants are UTC ISO-8601 text (conventions §11.14): every `*_at` column
// must end in `Z` (a `NULL` passes), so the text sorts and compares in time
// order, and the `ends_at > starts_at` checks compare like times. A local
// `DateTime` would be written with its offset, and refused.

/// `CHECK (<column> GLOB '*Z')`: a UTC instant.
String _utc(String column) => "CHECK ($column GLOB '*Z')";

@DataClassName('OrganizerRow')
class Organizers extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get bio => text()();

  IntColumn get followers =>
      integer().check(followers.isBiggerOrEqualValue(0))();

  IntColumn get eventsCount =>
      integer().check(eventsCount.isBiggerOrEqualValue(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EventRow')
@TableIndex(name: 'events_by_start', columns: {#startsAt})
@TableIndex(name: 'events_by_category', columns: {#category})
@TableIndex(name: 'events_by_city', columns: {#city})
class Events extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get category => textEnum<EventCategory>()();

  TextColumn get organizerId => text().references(Organizers, #id)();

  DateTimeColumn get startsAt => dateTime()();

  DateTimeColumn get endsAt => dateTime()();

  /// The venue's IANA zone ("Europe/London").
  TextColumn get timeZone => text()();

  // A venue (name, address, city) or an online join link, never both.
  TextColumn get venueName => text().nullable()();

  TextColumn get venueAddress => text().nullable()();

  TextColumn get city => text().nullable()();

  TextColumn get joinUrl => text().nullable().map(const UriConverter())();

  BoolColumn get featured => boolean().withDefault(const Constant(false))();

  IntColumn get attendeeCount =>
      integer().check(attendeeCount.isBiggerOrEqualValue(0))();

  IntColumn get capacity => integer().check(capacity.isBiggerThanValue(0))();

  TextColumn get status => textEnum<EventStatus>()();

  DateTimeColumn get previousStartsAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    _utc('starts_at'),
    _utc('ends_at'),
    _utc('previous_starts_at'),
    'CHECK (ends_at > starts_at)',
    'CHECK (attendee_count <= capacity)',
    // In person: a venue and a city, no link. Online: a link, no venue.
    'CHECK ((venue_name IS NOT NULL AND venue_address IS NOT NULL '
        'AND city IS NOT NULL AND join_url IS NULL) '
        'OR (venue_name IS NULL AND venue_address IS NULL '
        'AND city IS NULL AND join_url IS NOT NULL))',
  ];
}

/// One kind of ticket an event sells. Part of the event: deleted with it.
@DataClassName('TicketOfferRow')
class TicketOffers extends Table {
  TextColumn get eventId =>
      text().references(Events, #id, onDelete: KeyAction.cascade)();

  TextColumn get type => textEnum<TicketType>()();

  /// Minor units (pence, cents): money is never a floating-point number.
  IntColumn get priceMinor =>
      integer().check(priceMinor.isBiggerOrEqualValue(0))();

  TextColumn get currency => text().check(currency.length.equals(3))();

  IntColumn get capacity => integer().check(capacity.isBiggerThanValue(0))();

  IntColumn get remaining => integer()();

  /// The server's order of the ticket types.
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {eventId, type};

  @override
  List<String> get customConstraints => [
    'CHECK (remaining BETWEEN 0 AND capacity)',
  ];
}

@DataClassName('SessionRow')
@TableIndex(name: 'sessions_by_event', columns: {#eventId, #startsAt})
class Sessions extends Table {
  TextColumn get id => text()();

  TextColumn get eventId =>
      text().references(Events, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text()();

  TextColumn get speaker => text()();

  TextColumn get room => text()();

  DateTimeColumn get startsAt => dateTime()();

  DateTimeColumn get endsAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    _utc('starts_at'),
    _utc('ends_at'),
    'CHECK (ends_at > starts_at)',
  ];
}

// ---------------------------------------------------------------------------
// The user's tables.

@DataClassName('SavedEventRow')
class SavedEvents extends Table {
  TextColumn get eventId => text().references(Events, #id)();

  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {eventId};

  @override
  List<String> get customConstraints => [_utc('saved_at')];
}

/// Your tickets. A ticket *is* the RSVP; cancelled ones stay, with the time
/// you cancelled, so Past still shows them.
@DataClassName('TicketRow')
@TableIndex.sql(
  // At most one *active* ticket per event: a partial unique index ignores
  // cancelled ones, so you can book again after cancelling.
  'CREATE UNIQUE INDEX tickets_one_active_per_event '
  'ON tickets (event_id) WHERE cancelled_at IS NULL',
)
class Tickets extends Table {
  TextColumn get id => text()();

  TextColumn get eventId => text().references(Events, #id)();

  TextColumn get code => text().unique()();

  TextColumn get type => textEnum<TicketType>()();

  TextColumn get note => text().withDefault(const Constant(''))();

  DateTimeColumn get bookedAt => dateTime()();

  DateTimeColumn get cancelledAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    _utc('booked_at'),
    _utc('cancelled_at'),
  ];
}

/// A session you bookmarked. A bookmark is about one session, so it goes
/// with it.
@DataClassName('SessionBookmarkRow')
class SessionBookmarks extends Table {
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {sessionId};

  @override
  List<String> get customConstraints => [_utc('created_at')];
}

@DataClassName('FollowRow')
class FollowedOrganizers extends Table {
  TextColumn get organizerId => text().references(Organizers, #id)();

  DateTimeColumn get followedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {organizerId};

  @override
  List<String> get customConstraints => [_utc('followed_at')];
}

/// The reminder toggle on an event's page: the user's choice, either way
/// (no row: the default, on when going).
@DataClassName('EventReminderRow')
class EventReminders extends Table {
  TextColumn get eventId => text().references(Events, #id)();

  BoolColumn get enabled => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {eventId};
}

/// A change a sync noticed on an event you hold a ticket for, recorded once
/// and alerted once (`seen`: claimed for its alert).
@DataClassName('EventChangeRow')
class EventChanges extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get eventId => text().references(Events, #id)();

  TextColumn get kind => textEnum<EventChangeKind>()();

  DateTimeColumn get detectedAt => dateTime()();

  BoolColumn get seen => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [_utc('detected_at')];
}

@DataClassName('RecentSearchRow')
class RecentSearches extends Table {
  TextColumn get query => text()();

  DateTimeColumn get searchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {query};

  @override
  List<String> get customConstraints => [_utc('searched_at')];
}

/// Your profile: one row at most (`id` is always 1).
@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().check(id.equals(1))();

  TextColumn get name => text()();

  TextColumn get email => text()();

  TextColumn get avatarUrl => text().nullable().map(const UriConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
