import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:evently/domain/model/schedule_session.dart';

// Small catalogs built in code, for the tests that need a particular shape
// (the bundled one is tested on its own).

/// Saturday 24 October 2026, 18:30–21:00 in London (17:30–20:00 UTC).
final saturdayEvening = EventTime(
  start: DateTime.utc(2026, 10, 24, 17, 30),
  end: DateTime.utc(2026, 10, 24, 20),
  zone: 'Europe/London',
);

const londonHall = EventLocation.venue(
  name: 'Hall',
  address: '1 Example Road',
  city: 'London',
);

EventLocation venueIn(String city) =>
    EventLocation.venue(name: 'Hall', address: '1 Example Road', city: city);

EventLocation onlineAt(String url) =>
    EventLocation.online(joinUrl: Uri.parse(url));

Organizer organizer([String id = 'org_1']) => Organizer(
  id: id,
  name: 'Organizer $id',
  bio: 'They organize things.',
  followers: 10,
  eventsCount: 1,
);

const freeOffer = TicketOffer(
  type: TicketType.free,
  priceMinor: 0,
  currency: 'GBP',
  capacity: 100,
  remaining: 90,
);

Event event({
  String id = 'ev_1',
  String title = 'An event',
  String organizerId = 'org_1',
  EventCategory category = EventCategory.technology,
  EventTime? time,
  EventLocation location = londonHall,
  bool featured = false,
  EventStatus status = EventStatus.scheduled,
  DateTime? previousStart,
  List<TicketOffer> offers = const [freeOffer],
}) => Event(
  id: id,
  title: title,
  description: 'What happens.',
  category: category,
  organizerId: organizerId,
  time: time ?? saturdayEvening,
  location: location,
  featured: featured,
  attendeeCount: 10,
  capacity: 100,
  status: status,
  previousStart: previousStart,
  offers: offers,
);

ScheduleSession session({
  String id = 'ses_1',
  String eventId = 'ev_1',
  String title = 'A talk',
}) => ScheduleSession(
  id: id,
  eventId: eventId,
  title: title,
  speaker: 'Someone',
  room: 'Main',
  start: saturdayEvening.start,
  end: saturdayEvening.start.add(const Duration(minutes: 45)),
);

/// [events] by organizer `org_1` (and any other organizer they name).
Catalog catalogOf(
  List<Event> events, {
  List<ScheduleSession> sessions = const [],
}) => Catalog(
  organizers: [
    for (final id in {'org_1', ...events.map((e) => e.organizerId)})
      organizer(id),
  ],
  events: events,
  sessions: sessions,
);

// ---------------------------------------------------------------------------
// JSON, as the API sends it, for the DTO and mapper tests.

Map<String, dynamic> organizerJson([String id = 'org_1']) => {
  'id': id,
  'name': 'Organizer $id',
  'bio': 'They organize things.',
  'followers': 10,
  'eventsCount': 1,
};

Map<String, dynamic> offerJson({
  String type = 'free',
  int priceMinor = 0,
  String currency = 'GBP',
  int capacity = 100,
  int remaining = 90,
}) => {
  'type': type,
  'priceMinor': priceMinor,
  'currency': currency,
  'capacity': capacity,
  'remaining': remaining,
};

Map<String, dynamic> sessionJson({
  String id = 'ses_1',
  String startsAt = '2026-10-24T18:30:00.000+0100',
  String endsAt = '2026-10-24T19:15:00.000+0100',
}) => {
  'id': id,
  'title': 'A talk',
  'speaker': 'Someone',
  'room': 'Main',
  'startsAt': startsAt,
  'endsAt': endsAt,
};

/// An in-person event in London, Saturday 24 October 18:30–21:00 (BST).
Map<String, dynamic> eventJson({String id = 'ev_1'}) => {
  'id': id,
  'title': 'An event',
  'description': 'What happens.',
  'category': 'technology',
  'organizerId': 'org_1',
  'startsAt': '2026-10-24T18:30:00.000+0100',
  'endsAt': '2026-10-24T21:00:00.000+0100',
  'timeZone': 'Europe/London',
  'venue': {'name': 'Hall', 'address': '1 Example Road', 'city': 'London'},
  'attendeeCount': 10,
  'capacity': 100,
  'offers': [offerJson()],
};

Map<String, dynamic> catalogJson({
  List<Map<String, dynamic>>? organizers,
  List<Map<String, dynamic>>? events,
}) => {
  'organizers': organizers ?? [organizerJson()],
  'events': events ?? [eventJson()],
};
