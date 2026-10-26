# Offline-First

Evently is the first app in this series where **the server owns data the user changes**: a place at an event exists only once the server grants it. The app still works without a network, because every screen reads a local cache, and only three things ever talk to the server: a refresh, a booking and a cancellation.

```
                 ┌───────────── refresh (Welcome, pull to refresh, the background sync) ─────────────┐
                 │                                                                                    ▼
FakeEventlyApi ──┤                                                                         drift: the catalog
 (in memory,     │                                                                         (organizers, events,
  700 ms)        └── RSVP / cancel ── the server's answer ── ticket + the event's counts ──▶  offers, sessions)
                                                         (one transaction)                       │
                                                                                                 ▼
        saves, bookmarks, follows, reminders, recent searches, the profile ──▶ drift: the user's tables
                                                                                                 │
                                       every screen ◀── watch() over joins of both ◀─────────────┘
```

## The cache

- **Every screen reads drift, never the API** (correctness rule 1). Discover, Search, Saved, Tickets, an event's page, the agenda, an organizer, Following and the profile all come from `watch()` queries.
- **A refresh writes the cache;** the screens follow by themselves, because they are watching the tables it writes.
- **A failed refresh keeps the cache and says so:** a SnackBar ("Couldn't reach the server…") over the events that were already there. Welcome, the only screen with nothing cached yet, shows the error with Try again.
- **The first fetch is Welcome's:** nothing else happens until the catalog is cached. Discover fetches only if its cache is empty (after Clear cache, say).

## The server's data and the user's, kept apart

| | The catalog | The user's data |
|---|---|---|
| Tables | organizers, events, ticket_offers, sessions | saved_events, tickets, session_bookmarks, followed_organizers, event_reminders, event_changes, recent_searches, profiles |
| Written by | a refresh; a booking or cancellation the server confirmed (its event's counts) | the user's actions (and a booking's ticket, from the server's answer) |
| A sync | upserts it, never deletes; an event gone from the server is marked cancelled | never touches it (except recording a change to a ticketed event) |

- **"Saved", "going", "bookmarked" and "following" are joins** (rule 3): a saved event is a row in `saved_events`, never a flag on the event. A refresh can rewrite every column of an event without losing any of that.
- **The user's rows keep their events:** they point at events without `CASCADE`, so the database refuses to delete an event someone saved or booked. See [DATA_MODEL.md](DATA_MODEL.md).

## Refresh and sync

`CatalogRepositoryImpl.refresh` is the one path from the server to the cache:

1. **Fetch** the catalog (`EventlyApi.fetchCatalog`).
2. **Check and map** it, all of it, before anything is written: every event has an organizer, a known category and zone, a start before its end, a venue or a join link, offers with sane prices and places, sessions inside their event. Damaged data never reaches the cache (`DataFormatException`).
3. **Write it in one transaction** (rule 2):
   - read each cached event's start and status;
   - upsert organizers, events (every column, nulls too, `ON CONFLICT DO UPDATE`, never `REPLACE`), the events' offers and sessions;
   - mark cached events the server no longer lists **cancelled** (never deleted);
   - compare before and after (`diffCatalog`) and record the moves and cancellations of events the user holds a ticket for (`event_changes`), once.
4. **Alert** what it recorded (when notifications are on), and the notification plan follows.

Who refreshes:
- **Welcome**, before the first start;
- **Discover**, on pull to refresh (and when its cache is empty);
- **Reset demo data**, before writing the demo;
- **the background sync** (`RunBackgroundSync`, every few hours, and Settings → Developer → Run background sync now). See [BACKGROUND_WORK.md](BACKGROUND_WORK.md).

## Server-confirmed writes

**No ticket without the server** (rule 4):

```
RSVP form ─▶ RsvpEventUseCase
               ├─ the form checked again against the latest cached event (validateRsvp)
               └─▶ BookingRepository.rsvp ─▶ EventlyApi.rsvp ─▶ the server checks again:
                                                               the event exists, isn't cancelled or started,
                                                               the type is sold, a place is left,
                                                               you don't hold an active ticket
                       answer (the ticket + the event's new counts)
                         └─▶ TicketsDao.book: the ticket and the event, in one transaction
                       failure (offline, sold out, closed, already booked)
                         └─▶ nothing written; the form says why
```

- **One transaction for the ticket and the counts:** the app never shows a ticket beside a place count that doesn't include it, or the reverse. A test makes the event's write fail and checks the ticket goes too.
- **Only the server's answer is written,** and only if it's for the event that was asked about.
- **Cancel works the same way,** and only before the event starts (rule 7). The place goes back on the server; the ticket stays, marked cancelled, as history.
- **One active ticket per event** (rule 5): a partial unique index locally, and the server refuses a second booking too.

**Saves, bookmarks, follows and reminder choices are local:** they are the user's own notes, need no server, and work offline.

## What works offline

| Works offline | Needs the (fake) network |
|---|---|
| Discover, an event's page, the agenda, an organizer, Following, Profile (all from the cache) | Welcome's first fetch |
| Search with every filter (one query over the cache), recent searches | Pull to refresh (offline: the cache stays, a SnackBar says why) |
| Save and unsave, bookmark sessions, follow, set a reminder, edit the profile | RSVP and cancel (offline: nothing written, the form says why, Try again) |
| Tickets and their QR codes | Reset demo data (offline: nothing changes) |
| Notifications already scheduled, and the plan (re-planned from the cache) | The background sync's refresh (the rest of the sync still runs) |
| Settings, Clear cache | |

Try it with Settings → Developer → **Simulate network failure**: every request fails as if offline.

## Testing

- **The data stack** (`DataStack`) runs the real repositories on an in-memory database with the real fake server (zero latency, a fixed clock). `ScriptedEventlyApi` scripts the server's answers: offline, damaged data, refused bookings, answers for the wrong event.
- **Pinned:** a refresh keeps saves, tickets and bookmarks; never deletes; writes nulls; rolls back as a whole; damaged or offline answers leave the cache as it was; a booking and its counts land together or not at all; a sold-out, closed or offline booking writes nothing; Clear cache keeps every kind of owned event.
- **Flows on the real DI graph:** saving offline, refreshing offline, booking offline then Try again.
