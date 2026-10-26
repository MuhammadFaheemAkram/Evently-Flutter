# Data Model

Evently keeps two kinds of data in one drift (SQLite) database, `evently.sqlite`:
- **the catalog:** what the server serves (organizers, events, ticket offers, sessions), cached;
- **the user's data:** what the user did (saves, tickets, bookmarks, follows, reminder choices, change records, recent searches, the profile).

They live in separate tables, and the screens join them when they read. Preferences (the settings) live in `SharedPreferencesWithCache`.

## Value types

| Type | What it is | Stored as |
|---|---|---|
| `EventTime` | two UTC instants (start, end) plus the venue's IANA zone | `starts_at`, `ends_at` (UTC ISO text) + `time_zone` |
| `EventLocation` | sealed: `Venue(name, address, city)` or `Online(joinUrl)` | four nullable columns, exactly one shape allowed by a `CHECK` |
| `TicketOffer` | a ticket type with its price in minor units (pence, cents), currency, capacity, places left | a row in `ticket_offers` |
| `CalendarDate` | a day with no time or zone (an extension type over `yyyymmdd`) | used in memory (agenda days, date filters), not stored |
| `TimeOfDayValue` | a time of day (minutes since midnight) | `HH:mm` text in preferences (the summary time) |
| Money | `int` minor units + ISO 4217 currency | never a `double` |

Every instant is stored as UTC ISO-8601 text, and a `CHECK (… GLOB '*Z')` refuses anything else (conventions §11.14). See [TIME_ZONES.md](TIME_ZONES.md).

## Tables (schema v1)

### The catalog: written only by a refresh, or a booking the server confirmed

| Table | Columns | Notes |
|---|---|---|
| `organizers` | id, name, bio, followers, events_count | followers is the server's count, not the user's follows |
| `events` | id, title, description, category, organizer_id → organizers, starts_at, ends_at, time_zone, venue_name?, venue_address?, city?, join_url?, featured, attendee_count, capacity, status (scheduled / moved / cancelled), previous_starts_at? | indexes on starts_at, category, city |
| `ticket_offers` | event_id → events **CASCADE**, type, price_minor, currency, capacity, remaining, sort_order | key (event_id, type); part of the event, rewritten with it |
| `sessions` | id, event_id → events **CASCADE**, title, speaker, room, starts_at, ends_at | index (event_id, starts_at) |

### The user's: written only by the user's actions

| Table | Columns | Notes |
|---|---|---|
| `saved_events` | event_id → events (key), saved_at | "saved" is a row here |
| `tickets` | id, event_id → events, code (unique), type, note, booked_at, cancelled_at? | a partial unique index: **one active ticket per event** |
| `session_bookmarks` | session_id → sessions **CASCADE** (key), created_at | a session is part of its event |
| `followed_organizers` | organizer_id → organizers (key), followed_at | |
| `event_reminders` | event_id → events (key), enabled | the reminder toggle, either way; no row means the default |
| `event_changes` | id (autoincrement), event_id → events, kind (moved / cancelled), detected_at, seen | recorded by a refresh; `seen` once claimed for its alert |
| `recent_searches` | query (key), searched_at | the newest 10 |
| `profiles` | id (`CHECK (id = 1)`), name, email, avatar_url? | a single row |

## Constraints: invalid rows can't exist

- **An event's place:** a `CHECK` allows exactly two shapes: a venue (name, address and city, no join URL) or online (a join URL, nothing else).
- **Time:** `ends_at > starts_at` for events and sessions; every instant ends in `Z`.
- **Counts:** `attendee_count ≤ capacity`; `capacity > 0`; `0 ≤ remaining ≤ capacity`; `price_minor ≥ 0`; a three-letter currency.
- **One active ticket per event:** `CREATE UNIQUE INDEX tickets_one_active_per_event ON tickets (event_id) WHERE cancelled_at IS NULL`. A cancelled ticket stays as history, and a new booking is allowed beside it.
- **Ticket codes are unique**, and carry a check character (Luhn mod N over `23456789ABCDEFGHJKLMNPQRSTUVWXYZ`), so a typo is caught.
- **One profile:** `CHECK (id = 1)`.
- **Foreign keys are on:** SQLite ships with them off, per connection; `PRAGMA foreign_keys = ON` runs before every open.

## Who points at whom, and why there's no cascade from the user's rows

```
organizers ◀── events ◀── ticket_offers (CASCADE)
                  ▲   ◀── sessions (CASCADE) ◀── session_bookmarks (CASCADE)
                  │
   saved_events, tickets, event_reminders, event_changes   (NO ACTION)
organizers ◀── followed_organizers                          (NO ACTION)
```

- **Offers, sessions and a session's bookmark** are part of their event: they go with it.
- **The user's rows don't cascade.** A foreign key's default (`NO ACTION`) refuses to delete an event someone saved, booked, set a reminder on or was alerted about. Nothing the user owns can disappear with the cache, and a bug that tried would fail loudly.
- **Clear cache** asks the database what the user owns (a `UNION` over saved events, tickets, reminders, change records and bookmarked sessions' events), deletes the rest, then the organizers left with no event and no follower. The foreign keys stay the safety net.

## Joins, not flags

An event row says nothing about the user. `EventsDao` reads events with LEFT JOINs:

```
events ⨝ organizers
       ⟕ saved_events                         → isSaved
       ⟕ tickets (cancelled_at IS NULL)       → isGoing, the active ticket's id
       ⟕ event_reminders                      → the reminder choice
```

Each join matches at most one row (the saved and reminder tables' keys, the one-active-ticket index), so an event is never listed twice. Because the joined tables are part of the query, drift re-runs it when the user saves, books or sets a reminder, not only on a refresh. Following and the profile's counts are joins and sub-queries too.

## Writes that touch several rows

All in one transaction, so they land completely or not at all:

| Write | What it does |
|---|---|
| **A refresh** (`CatalogRepositoryImpl.refresh`) | reads every event's start and status; upserts organizers, events (`ON CONFLICT DO UPDATE` with every column, nulls too), the events' offers (deleted and re-inserted) and sessions; marks events missing from the catalog **cancelled**; compares before and after (`diffCatalog`); records the moves and cancellations of events with an active ticket in `event_changes` |
| **A booking** (`TicketsDao.book`) | inserts the server's ticket and writes the event as the server now has it (one place fewer) |
| **A cancellation** (`TicketsDao.cancel`) | marks the ticket cancelled and writes the event's new counts |
| **Claiming alerts** (`RemindersDao.claimUnalerted`) | selects the changes not yet `seen` and marks them, so each is alerted once, by one isolate |
| **The demo** (`UserDataDao.replaceAll`) | deletes every user table's rows and writes the demo's profile, saves, tickets, bookmarks and follows |
| **Clear cache** (`CatalogDao.clearUnowned`) | deletes unowned events and orphaned organizers |
| **A recent search** | puts the query first and drops the oldest beyond 10 |

**Never `INSERT OR REPLACE`** on a row others point at: SQLite implements it as a delete then an insert, and the delete would cascade into offers and sessions, or be refused because of the user's rows (conventions §11.53). Rows written with every column use a companion built with `nullToAbsent: false`, so a cleared value becomes `NULL` (§11.57).

## Reads

- **Every screen watches a query** (`watch()`), so a refresh, a save or a booking shows up everywhere at once.
- **Search** is one query built from the text and the `EventFilter`: `LIKE` over title, organizer, venue and city with `%`, `_` and `\` escaped; categories; an overlap with the date window; free (no paid offer) or paid; online or in person; going or not. Only upcoming events.
- **The agenda** reads an event's sessions with the user's bookmarks; days and clashes are worked out in the domain.

## Across isolates

The database opens with `shareAcrossIsolates: true`. The app and the background sync (a `workmanager` isolate) talk to **one drift server isolate** that owns the only connection, so writes never collide, a claim is atomic across both, and the app's streams see the background's changes at once. See [BACKGROUND_WORK.md](BACKGROUND_WORK.md).

## Preferences

`SharedPreferencesWithCache`, created once before `runApp` (`@preResolve`), so reads are synchronous from the first frame:

| Key | Value | Default |
|---|---|---|
| `settings.onboarded` | bool | false |
| `settings.preferredCity` | string, or absent for "Anywhere" | absent |
| `settings.themeMode` | `system` / `light` / `dark` | `system` |
| `settings.dynamicColor` | bool | true |
| `settings.notificationsEnabled` | bool | false |
| `settings.reminderLead` | `fifteenMinutes` / `oneHour` / `threeHours` / `oneDay` | `oneHour` |
| `settings.summaryEnabled` | bool | true |
| `settings.summaryTime` | `HH:mm` | `08:00` |
| `server.demoAnchor` | ISO instant: the fake server's calendar (not a setting) | set at the first fetch |

- **Only the keys that changed are written:** the background isolate has its own cache, and writing every key from a stale copy would undo what it saved (§11.64).
- **A value this version can't read falls back to the default** instead of failing.
- **Reload on resume, after this isolate's own writes:** on Android, a read can overtake a write made just before it, and a change made while a reload reads is kept over what the reload read (§11.84).

## Migrations

`schemaVersion` is 1, exported to `drift_schemas/app_database/drift_schema_v1.json`. A schema change bumps the version, runs `drift_dev make-migrations` (which exports the new version and generates step-by-step migration tests), writes the step, and adds a data test (conventions §11.43). No phase after the first changed the schema: the reminder and change tables were planned in from the start.
