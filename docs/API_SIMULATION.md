# API Simulation

Evently has **no backend, no account and no API key**. The "server" is `FakeEventlyApi`, a class inside the app that plays one, behind the same interface a real client would use:

```dart
abstract interface class EventlyApi {
  Future<CatalogDto> fetchCatalog();                     // every organizer, event, offer and session
  Future<DemoUserDto> fetchDemoUser();                   // "Explore with demo data"
  Future<BookingDto> rsvp(RsvpRequestDto request);       // a ticket + the event's new counts
  Future<EventDto> cancelRsvp(CancelRequestDto request); // the event's new counts
}
```

Everything goes through a `NetworkSimulator` first: a **700 ms** delay, and a `NetworkException` when Settings → Developer → **Simulate network failure** is on. The app makes no real network request; directions and join links open in other apps.

## The seed (incoming)

Three JSON files ship with the app (`assets/json/`):

| File | What |
|---|---|
| `catalog_seed.json` | 6 organizers and 25 events (8 in London, 7 in Berlin, 6 in New York, 4 in Lahore; 21 at a venue, 4 online), each with ticket offers and, for some, an agenda (21 sessions) |
| `demo_user.json` | Sara Ahmed's profile, 4 saved events, 4 tickets (with their codes), 3 bookmarked sessions, 2 follows |
| `catalog_update.json` | what "Publish a catalog update" changes (below) |

### Events written the way people plan them

The seed doesn't hold instants. It says "in 3 days at 18:30, in London":

```json
"timeZone": "Europe/London",
"starts": { "inDays": 0, "at": "18:30" },
"ends":   { "inDays": 0, "at": "21:00" }
```

`SeedRenderer` turns that into what a real API would send: ISO-8601 instants with the venue's offset (`…T18:30:00.000+0000`), counting days from the **venue's** today (at 01:00 in London it's already tomorrow in Lahore). A fresh demo therefore always has events today, this weekend and next month, plus a few past ones. The renderer also computes what a server would: attendee counts from the offers, each organizer's events count, the demo's booking dates (`bookedDaysAgo`).

### A calendar that stays put (`DemoCalendar`)

Rendered from *today*, every event would move a day each day, and change detection would rightly report every ticket's event as moved (found on the simulator in Phase 7, conventions §11.83). So the server renders from a fixed **anchor**:

- the moment of its **first fetch**, stored in the device's preferences (`server.demoAnchor`), so the background isolate's server counts from the same day;
- read once per isolate and then kept in memory (a preferences reload empties the cache for a moment);
- **restarted by Reset demo data**, which brings the demo back to "today".

So the demo ages like real data: events pass, and after a few weeks Discover is mostly past events, until Reset demo data.

### Checked before anything is written

The DTOs are `json_serializable` with `checked: true`, so a wrong type names its field. Then the mappers check every rule before a refresh writes anything: no duplicate ids; a known category and IANA zone; a start before its end; a venue (name, address, city) or a join link; offers sold once each, with prices ≥ 0 and places between 0 and the capacity; sessions inside their event. Damaged data becomes a `DataFormatException`, and the cache stays as it was. A test renders the bundled seed as of six instants (both clock changes included) and checks it passes.

## The server's state (in memory)

The fake keeps what a server would, for as long as the app runs:

- **places taken** per event and ticket type, applied to every catalog it serves (places left, attendee counts);
- **the tickets it issued** (and the demo's, once fetched), one active per event;
- **whether an update was published.**

A restart forgets it: the local tickets stay, and the next refresh shows the seed's counts. The background isolate's server is likewise a fresh one (see [BACKGROUND_WORK.md](BACKGROUND_WORK.md)).

## Booking (outgoing)

`rsvp(RsvpRequestDto(eventId, type, note))` checks again, whatever the app already checked:

| Refused when | Answer |
|---|---|
| the event doesn't exist or is cancelled | `BookingClosedException` ("This event was cancelled.") |
| it has started | `BookingClosedException` ("Bookings closed when it started.") |
| you already hold an active ticket for it | `AlreadyBookedException` |
| the type isn't sold, or has no place left | `SoldOutException` |

Otherwise it takes a place and answers with the ticket (an id, a **code** like `EVT-7KQ2-M9XH` with a Luhn mod N check character, the type, the note, the booking time) and the event as it now stands. The app writes both in one transaction, and only if the answer is for the event it asked about.

`cancelRsvp(CancelRequestDto(ticketId, eventId, type))` refuses once the event has started, and gives the place back. It carries the type, so even a restarted server (which never issued that ticket) can give back the right place.

## The catalog update (the developer's switch)

Settings → Developer → **Publish a catalog update** makes every later catalog include `catalog_update.json`:

- **Form & Function: Berlin Design Conference moves a day later** (status `moved`, with where it was: `previousStartsAt`; its sessions move too);
- **Dart 3 Patterns Live Coding is cancelled;**
- **AI in Production Summit's description is edited;**
- **two events appear:** Flutter Hack Night (London) and Design Sprint for Founders (Lahore).

The demo user holds tickets for the first two, so the next refresh records a move and a cancellation, the tickets say "Moved" and "Cancelled by the organizer", the cards say so too, and (with notifications on) two alerts are shown. A cancelled event can't be booked. In memory, like the rest: a restart takes it back.

## Errors

| Exception | Shown as |
|---|---|
| `NetworkException` | "Couldn't reach the server. Check your connection and try again." |
| `DataFormatException` | the server sent something the app can't use; nothing written |
| `NotFoundException` | the event or ticket no longer exists |
| `SoldOutException`, `AlreadyBookedException`, `BookingClosedException` | the booking form says why |
| `UnknownException` | something went wrong (a database error, logged) |

Repositories turn every failure into one of these (`guardApiCall`), inside a `Result`; nothing throws into a Cubit.

## Other outside effects

- **Links:** directions open Apple Maps (iOS) or Google Maps, and join links the browser or a meeting app, through `url_launcher`, `https` only (`UnsafeLinkException` otherwise).
- **Notifications** are local, scheduled on the device; their payloads hold only an event or ticket id and a time.
- **Background work** runs on the device only and touches only the app's own database and preferences.

## Testing

- **The fake server:** the seed as of six instants; relative times with the venue's offset; latency and failures; places taken and given back; one booking each; closed and cancelled events; the update (nothing before; moved by a day with its sessions and previous start, cancelled, edited, new; still valid).
- **The calendar:** anchored at the first read and kept; shared with another isolate; restarted by Reset demo data; a refresh the next day moves nothing.
- **`ScriptedEventlyApi`** scripts any answer (a DTO or an exception) for repository and flow tests: offline, damaged data, refused bookings, an answer for another event.
