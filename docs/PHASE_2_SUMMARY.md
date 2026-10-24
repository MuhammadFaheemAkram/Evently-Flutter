# Phase 2 — Data Layer

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 2, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 2 gives Evently its data, and makes Welcome real:
- **models that tell time properly:** an event is two instants plus the venue's time zone, shown in the venue's local time;
- **a drift database in two halves:** the server's **catalog** (cached) and the **user's** own rows (saved events, tickets, bookmarks, follows), kept apart so a sync can never lose what the user did;
- **rules the database enforces:** `CHECK`s, foreign keys that protect the user's rows, one active ticket per event;
- **an in-memory fake API** that renders its seed ("in 3 days at 18:30, in London") into real instants as of today;
- **Welcome for real:** the catalog is fetched first, the user picks a city, then explores with demo data or starts fresh; the choice is saved, and the router follows it.

---

## 🧱 What Was Implemented

- **Value types:**
  - `CalendarDate` and `TimeOfDayValue` (from Momentum);
  - `EventTime(start, end, zone)`: UTC instants plus an IANA zone. `EventTime.local(...)` builds one from a poster's time ("Saturday 18:30 in London"). It gives the venue's local start and end, its days, the duration, and `hasStarted` / `hasEnded` / `isOngoing`, all compared as instants and end-exclusive.
- **Models (freezed):**
  - `EventCategory` (8), `TicketType` (free, standard, VIP, workshop pass), `EventStatus` (scheduled, moved, cancelled), `EventChangeKind`;
  - `EventLocation`, a sealed class: `Venue(name, address, city)` or `Online(joinUrl)`;
  - `TicketOffer` (price in minor units, currency, places, places left);
  - `Event` (with `placesLeft`, `isSoldOut`, `isFree`, `isOnline`);
  - `Organizer`, `ScheduleSession`, `Ticket` (`isActive`), `UserProfile`;
  - `Catalog`, `UserData`, `AppSettings` (onboarded, preferred city).
- **The drift database (v1, 12 tables, schema exported to `drift_schemas/`):**
  - **catalog:** organizers, events, ticket offers, sessions;
  - **user:** saved events, tickets, session bookmarks, followed organizers, event reminders, event changes, recent searches, the profile;
  - `CatalogDao.upsertCatalog`: one transaction, `ON CONFLICT DO UPDATE` with every column written (nulls too), offers rewritten, nothing deleted; also `cities()`;
  - `UserDataDao.replaceAll`: the user's tables replaced in one transaction.
- **The fake API:**
  - `EventlyApi` with `FakeEventlyApi`: 700 ms of simulated latency, and a switch that makes every request fail;
  - `SeedRenderer`: turns the seed's relative times into ISO instants with the venue's offset, and computes attendee counts, capacities and each organizer's number of events;
  - checked DTOs (`checked: true`), then mappers that check every rule a type can't express.
- **Seed data:**
  - `catalog_seed.json`: 6 organizers and 25 events in London, Berlin, New York, Lahore and online, with 21 sessions. It includes a sold-out workshop, three past events, an event from 23:30 to 03:00 in New York, and a two-day Berlin conference with clashing sessions;
  - `demo_user.json`: Sara's profile, 4 saved events, 4 tickets (one tonight, one past), 3 bookmarks (two of them clash) and 2 follows.
- **Repositories:**
  - `CatalogRepository`: `refresh()` returns a `Result` with the number of events; also `cities()`;
  - `DemoRepository`: `loadDemoUser()`;
  - `SettingsRepository`: in memory, published to watchers at once, and only the changed keys saved to `SharedPreferencesWithCache`;
  - `guardApiCall`: one place that turns failures into the app's `AppException`s.
- **Use cases:** `RefreshCatalogUseCase`, `ListCitiesUseCase`, `StartWithDemoUseCase(city)`, `StartFreshUseCase(city)`.
- **DI:** `AppModule` provides the asset bundle, clock, database, DAOs and the preferences (`@preResolve`). `configureDependencies()` is async, and `main` loads the time-zone database first.
- **The router** follows the saved flag: a `StreamListenable` over `SettingsRepository.watch()`. `PlaceholderOnboarding` is gone.
- **Welcome:**
  - on open, the catalog is fetched ("Loading events");
  - if that fails, an error card with Try again;
  - then city chips ("Anywhere" plus the catalog's cities), **Explore with demo data** and **Start fresh**;
  - while a start runs, its button shows a spinner and every control waits; a failed demo offers Try again and still allows Start fresh.
- **Tests:** 312 (190 new).

### Differences from the plan

- **No `format` column.** The location decides whether an event is online, and a `CHECK` enforces "a venue or a link". A stored format could disagree with it, so it isn't stored.
- **No `updated_at` on events, no `cancelled_by` on tickets.** Nothing reads them. The sync (Phase 7) compares an event's start and status, and an event the organizer cancels says so in its own status. Either column can arrive with a migration if a feature needs it.
- **Every `*_at` column is checked UTC,** not only the events' and sessions': a local `DateTime` would be written with its offset and refused.
- **`flutter_timezone` (the device's zone) moves to Phase 3,** where "your local time" is first shown. Nothing in Phase 2 needs it.
- **Welcome fetches the catalog as it opens,** not when a button is tapped: the city chips come from the catalog, and both starts need its events (the demo points at them).
- **A doc fix found by a probe:** the `EventTime.local` doc said a local time that happens twice (01:30 on the night the clocks go back) resolves to the first one. `timezone` actually picks the second, in standard time. The doc now says so, and a test pins both the skipped hour and the repeated one.
- **A large-text fix found on the simulator:** at AX3, "Explore with demo data" wraps inside its button and was left-aligned against the pill's rounded edge. Button labels are now centred.

---

## 💙 Flutter / Dart Concepts Demonstrated

- **Instants plus a zone (`timezone`):** a `DateTime` is either UTC or the *device's* zone, and an event in New York read on a phone in Lahore is neither. `TZDateTime` carries any IANA zone with its daylight-saving rules.
- **Sealed classes for "one or the other":** `EventLocation` is `Venue` or `Online`. A `switch` must handle both, and a venue's fields don't exist on an online event.
- **drift beyond the basics:**
  - `customConstraints` for table `CHECK`s;
  - `@TableIndex.sql` for a **partial unique index** (one active ticket per event);
  - foreign keys with and without `CASCADE`;
  - `PRAGMA foreign_keys = ON` in `beforeOpen`;
  - `ON CONFLICT DO UPDATE` with `toCompanion(false)` so nulls are written;
  - transactions that roll back;
  - `selectOnly(distinct: true)`;
  - `shareAcrossIsolates`;
  - `make-migrations` to export the schema.
- **`json_serializable(checked: true)`:** a missing or mistyped field becomes a `CheckedFromJsonException` naming it. The mapper then checks the rules a type can't express.
- **`Result<T>` and a sealed `AppException`:** repositories never throw. The UI shows a small, fixed set of messages.
- **`@preResolve`:** async setup (the preferences) finishes before `runApp`, so the router reads the saved flag synchronously on the first frame.
- **`Stream.multi`:** each watcher gets the current value when it starts listening, then every change, with no gap between the two.
- **Bridging a `Stream` to `GoRouter.refreshListenable`** (`StreamListenable`).
- **Testing time:** `Clock.fixed`, `fake_async` for latency, and a seed rendered "as of" six different instants, including both clock changes and New Year's Eve.
- **`flutter_test_config.dart`:** one-time setup (the time-zone database) for every test file.

---

## 🔁 Data Flow (this phase)

```
App start ─▶ initializeTimeZones() ─▶ configureDependencies() (preferences pre-resolved) ─▶ EventlyApp
  GoRouter.redirect: firstLaunchRedirect(onboarded: SettingsRepository.current.onboarded)
  refreshListenable: StreamListenable(SettingsRepository.watch())

Welcome opens ─▶ WelcomeCubit.loadCatalog()
  RefreshCatalogUseCase ─▶ CatalogRepository.refresh()
    FakeEventlyApi.fetchCatalog()  (700 ms; SeedRenderer renders the seed as of the clock)
      ─▶ CatalogDto (checked) ─▶ toCatalog() (rules) ─▶ toRows() ─▶ CatalogDao.upsertCatalog (one transaction)
    any failure ─▶ guardApiCall ─▶ Err(NetworkException / DataFormatException / UnknownException)
  ListCitiesUseCase ─▶ CatalogDao.cities() ─▶ the city chips

"Explore with demo data" ─▶ StartWithDemoUseCase(city)
  DemoRepository.loadDemoUser() ─▶ fetchDemoUser ─▶ toUserData() ─▶ UserDataDao.replaceAll (one transaction)
  only if Ok ─▶ SettingsRepository.update(onboarded: true, preferredCity: city)
    ─▶ watch() emits ─▶ refreshListenable ─▶ redirect ─▶ /discover
"Start fresh" ─▶ StartFreshUseCase(city) ─▶ the same settings update
```

---

## 🗄️ The Schema in One Picture

```
catalog (the server's, cached)              user (yours)
───────────────────────────────            ─────────────────────────────────────────────
organizers ◀─────────────────────────────── followed_organizers          (NO ACTION)
   ▲
events ◀─────────────────────────────────── saved_events, tickets, event_reminders,
   │  CHECK: UTC instants, ends > starts,    event_changes                (NO ACTION)
   │         attendees ≤ capacity,           tickets: code UNIQUE,
   │         a venue XOR a link              one active per event (partial unique index)
   ├─ ticket_offers   (CASCADE)
   └─ sessions        (CASCADE) ◀────────── session_bookmarks            (CASCADE)
                                            recent_searches, profiles (CHECK id = 1)
```

Deleting an event someone saved, holds a ticket for (even a cancelled one), wants a reminder for, or was alerted about is **refused**. Phase 6's Clear cache deletes only what nothing of the user's points at.

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `lib/domain/model/*` | `CalendarDate`, `TimeOfDayValue`, `EventTime`, the enums, `Event` with its location and offers, `Organizer`, `ScheduleSession`, `Ticket`, `UserProfile`, `Catalog`, `UserData`, `AppSettings`. |
| `lib/core/database/tables/tables.dart`, `app_database.dart`, `daos/*`, `converters.dart` | The schema, the database, its two DAOs. |
| `drift_schemas/app_database/drift_schema_v1.json` | The exported v1 schema, for future migration tests. |
| `lib/core/network/{evently_api,fake_evently_api,seed_renderer,network_simulator,asset_json_loader}.dart`, `dto/*` | The API contract, the fake server and its wire format. |
| `assets/json/catalog_seed.json`, `demo_user.json` | The seed. |
| `lib/data/mapper/*`, `lib/data/repository/*` | Checks and mapping; the repositories and `guardApiCall`. |
| `lib/domain/repository/*`, `lib/domain/usecase/*` | Contracts and use cases. |
| `lib/core/storage/settings_local_data_source.dart` | The preference keys. |
| `lib/core/navigation/stream_listenable.dart` | A `Stream` as a `Listenable`, for the router. |
| `lib/di/app_module.dart` | Third-party types for DI. |
| `lib/features/welcome/cubit/*` | Welcome's Cubit and state. |
| `test/helpers/{test_dependencies,data_stack,catalog_fixtures,user_data_fixtures,result_matchers}.dart`, `fakes/*` | The test stack. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `EventTime` | freezed value | Instants plus a zone; local times and days; started/ended | `domain/model`: pure Dart, used everywhere |
| `EventLocation` (`Venue`, `Online`) | sealed freezed | Where an event happens | `domain/model` |
| `Event`, `TicketOffer` | freezed | An event and what it sells | `domain/model` |
| `AppDatabase`, `CatalogDao`, `UserDataDao` | drift | The cache and the user's data | `core/database`: only `data/` touches them |
| `EventlyApi`, `FakeEventlyApi`, `SeedRenderer` | interface / impl / static | The server, played in memory | `core/network` |
| `CatalogRepository`, `DemoRepository`, `SettingsRepository` | interfaces (+ impls in `data/`) | What the app can ask of its data | contracts in `domain/`, implementations in `data/` |
| `guardApiCall` | function | Failures → `Result` with an `AppException` | `data/repository` |
| `StartWithDemoUseCase`, `StartFreshUseCase` | use cases | The two ways out of Welcome | `domain/usecase` |
| `WelcomeCubit`, `WelcomeState` | Cubit / freezed | Catalog status, cities, the chosen city, the start in progress, the error | `features/welcome/cubit` |
| `StreamListenable` | `ChangeNotifier` | Lets the router follow the settings | `core/navigation` |

---

## 🧪 Tests (312)

| Area | Tests | What they pin |
|------|------:|---------------|
| Domain models | 41 | `EventTime` in London, Berlin, New York and Lahore, both clock changes (a skipped and a repeated hour), a night across midnight, the venue's day vs UTC's, end-exclusive edges; `Event` places, sold out, free, online; `CalendarDate`, `TimeOfDayValue` |
| Database | 38 | Every `CHECK`, foreign keys on, cascades, the user's rows protecting their event (and the refusal changing nothing), one active ticket per event, unique codes, one profile; the upsert keeping user rows, writing nulls, never deleting, rewriting offers, rolling back; `cities()`; `replaceAll` |
| Fake API and seed | 30 | Relative times → instants with the venue's offset; "today" is the venue's today; server-computed counts; latency and failures; the bundled seed passing every check as of six instants, and the cases it is meant to show |
| Mappers | 40 | Every catalog and demo rule, one test each; offsets → UTC; the DTOs refusing missing and mistyped fields |
| Repositories | 17 | Refresh ok / offline / malformed / broken rule / database failure, the cache untouched on failure; the demo without a catalog writing nothing; settings: defaults, saved values, only the changed keys written (a stale copy can't undo another isolate's save), watch |
| Welcome | 18 | The Cubit (load, offline then Try again, demo with a city, failed demo then Try again, fresh in a city, nothing before the catalog, no double start); the view in each state, live-region error, the heading |
| First launch and navigation | 37 | First launch on the real graph (demo in a city, fresh, offline Welcome, failed demo, the app reopening on Discover); the Phase 1 navigation and gate tests, now on saved settings; the DI smoke test |
| Accessibility tour | 35 | Gains Welcome choosing a city and Welcome offline, in both themes at 200 % |
| Design system and drawer | 56 | From Phase 1, unchanged |

**Mutation checks:** 25 deliberate breaks, each caught by the tests that should catch it. Examples:
- the upsert writing a row object instead of a full companion;
- no transaction around the upsert or the demo write;
- the partial index made total;
- tickets cascading with their event;
- foreign keys off;
- "today" taken in UTC instead of the venue's zone;
- `http` links accepted;
- every settings key written;
- the demo onboarding the user before it was written;
- a second start allowed;
- `hasEnded` made end-inclusive;
- the error no longer announced;
- the router not following the settings.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Store | Room: Event, Organizer, Ticket, Rsvp, ScheduleSession, SavedEvent, RecentSearch, UserProfile entities | SwiftData `@Model`s, in-memory container in tests | drift: catalog and user tables apart, `CHECK`s, protecting foreign keys, a partial unique index, the schema exported |
| Settings | DataStore (first launch, a "demo data initialized" flag, city, …) | `@AppStorage` | `SharedPreferencesWithCache`, pre-resolved; only changed keys written |
| Times | `startTime: Long` | `startTime: Date` | `EventTime`: UTC instants plus the venue's IANA zone |
| Location | `EventLocation` (fields unspecified) | `isOnline`, `venue?`, `city?` | sealed `Venue` / `Online`, matched by a `CHECK` |
| Saved / going | `isSaved`, `isRsvped` on `Event` | the same, `var` on the struct | not on the event: joins over the user's tables (Phase 3), so a refresh can't reset them |
| Price | `PriceType` free / paid | the same | per-event `TicketOffer`s with price, currency and places; free and sold out derived |
| Ticket | `userName`, `qrCodeText` | the same | `code` (unique, with a check character), `note`, `cancelledAt`; at most one active per event |
| Fake API | Retrofit-style services: featured, upcoming, search, detail, RSVP, cancel | `EventService` etc., bundled JSON, `shouldThrowError` | one `EventlyApi` (the catalog, the demo user); a seed of relative times rendered as of the clock; checked DTOs; search and filters run on the cache (Phase 4) |
| Demo data | hardcoded | bundled JSON | bundled JSON, always "around now"; Welcome loads it only on request |
| Phase 2 tests | DAO tests | store tests | schema, DAOs, mappers, the seed at six instants, repositories, Welcome, and 25 mutation checks |

Both native specs put `isSaved` and `isRsvped` on the event itself. The Flutter edition keeps the server's data and the user's apart: a refresh rewrites the catalog, and saved and going are worked out from the user's own rows, so a sync can never undo them.

---

## 🎤 Interview Notes

**Q: Why store an event as two UTC instants *and* a zone?**
A: The instants answer "has it started?" for everyone, wherever their phone is. The zone answers "what does the poster say?": 18:30 in London is 18:30 in London, however you read it. A device-local `DateTime` gets both wrong when the user travels.

**Q: Why not `INSERT OR REPLACE` for the catalog?**
A: REPLACE deletes the old row first. That delete would either cascade into, or be refused because of, the user's rows that point at the event. `ON CONFLICT DO UPDATE` changes the row in place. It has to write every column, or an event that moved online would keep its venue, and the venue-or-link `CHECK` would refuse it.

**Q: How can a user never have two tickets for one event, yet book again after cancelling?**
A: With a *partial* unique index: unique `event_id` among tickets `WHERE cancelled_at IS NULL`. Cancelled tickets don't count.

**Q: What happens if the demo fails half-way?**
A: Nothing changes: the user's tables are replaced in one transaction, and the onboarded flag is saved only after the write succeeds. Welcome shows why and offers Try again.

**Q: Why write only the settings that changed?**
A: From Phase 7 a background isolate keeps its own copy of the settings. Writing every key from a stale copy would undo what the other isolate saved meanwhile (Momentum's lesson, and a test here).

---

## 📝 Learning Checklist

- ✅ Model time as instants plus a zone, and test it across clock changes
- ✅ Model "one or the other" with a sealed class, and enforce it in the database too
- ✅ Keep the server's data and the user's apart, with foreign keys that protect the user's
- ✅ Upsert without REPLACE, writing nulls, in one transaction
- ✅ Check DTOs and domain rules before anything is written
- ✅ Return `Result`s with a sealed exception type instead of throwing
- ✅ Resolve async dependencies before the first frame, and let the router follow a stream
- ✅ Prove the tests by breaking the code on purpose
- ⬜ Discover and Event detail over the cache (Phase 3)

---

## 🚀 Future Improvements

- **Phase 3:** Discover (featured, in your city, coming up by day, categories, pull to refresh) and Event detail (the venue's time and yours, location, places, offers, save, the RSVP entry), with `flutter_timezone` for the device's zone.
- **Later:** a migration test once there is a v2 schema; ETags or "changed since" for refreshes that send only what changed.
