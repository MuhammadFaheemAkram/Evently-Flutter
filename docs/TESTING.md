# Testing

```bash
fvm flutter analyze
fvm dart format --output=none --set-exit-if-changed .
fvm flutter test
```

**900 tests**, all on the host: no device, no network, no real clock. CI runs the same three commands on every push and pull request, after checking that the committed generated code is current.

## What is covered

| Area | Tests | What it pins |
|---|---:|---|
| Screens: Cubits, the Bloc and views | 231 | Each Cubit on the real data stack; each view in every state with a mocked Cubit; `SearchBloc`'s timing in fake time |
| Mappers and repositories | 117 | Every catalog and demo rule; success, offline, damaged data, a database failure, each leaving the cache as it was; bookings and their transactions; change detection; settings and the reload race |
| Domain rules and the planner | 103 | Upcoming and past, why an event can't be booked, the RSVP form, ticket codes, cancelling, agenda days and clashes, Discover's sections, date presets, maps links, profile rules, `diffCatalog`, `planNotifications` |
| The design system | 91 | Both themes and the category palette (WCAG contrast of every color that carries meaning), formatting in four zones, the event widgets, filter labels, the large-text rule |
| The database | 78 | Every `CHECK`, foreign keys, cascades and `NO ACTION`, one active ticket per event, the catalog upsert, the search query for every filter, Clear cache, the demo's replace, recent searches |
| The accessibility tour | 71 | Every screen and state, light and dark, text at 200 % |
| The fake server and the seed | 51 | The seed as of six instants, relative times, latency and failures, places and bookings, the catalog update, the calendar anchor |
| Domain models | 41 | `EventTime` in four zones and across clock changes, `CalendarDate`, `TimeOfDayValue`, `Event` |
| App-level flows | 36 | On the real DI graph: first launch, Discover, saving and refreshing offline, booking (a linked event keeps Close after Back), cancelling, the agenda, settings, notifications and taps |
| Use cases | 34 | RSVP checked again before the server; plan → diff → apply; the switch; alerts; the RSVP confirmation; the background sync |
| Navigation | 34 | Typed routes, the first-launch gate, tabs and the drawer, deep links with Close (kept by a screen rebuilt while covered) |
| Common, DI, background | 13 | `EventClock`, `settled`, the composition root resolving, the background dispatch |

## How the tests are built

- **The data stack** (`test/helpers/data_stack.dart`): the real repositories and use cases on an **in-memory drift database**, with the **real fake server** (zero latency, a seeded `Random` for ticket codes), a clock stopped at Wednesday 21 October 2026, 14:00 UTC (set `stack.now` to move it), London as the device's zone, a `FakeSettingsRepository`, a `FakeNotificationScheduler` and a `RecordingLinkOpener`. Cubit, repository and use-case tests run on it instead of mocks.
- **`ScriptedEventlyApi`** wraps the real server and scripts any answer: a DTO, or an exception to throw (offline, damaged data, a refused or misdirected booking).
- **Fixtures:** `event()`, `organizer()`, `session()`, `catalogOf()`, `card()`, `ticket()`, `ticketItem()`, `userData()` build small, readable cases.
- **Views** use `MockCubit` / `MockBloc` (`bloc_test`) and `mocktail`, pumped with `pumpThemed` (the app's theme, `UserTimeZone` in London). One state per test: a `MockCubit` pumped again keeps showing its first state (conventions §11.73).
- **App-level flows** use `pumpEvently` on the real DI graph (`configureTestDependencies`: an in-memory database, zero latency, a fixed clock, in-memory preferences, a fake notification device, no background work, mocked time-zone and dynamic-color channels). `tearDown(getIt.reset)`.
- **Real and fake time:** widget tests run in fake time; database work runs on the real event loop (`runAsync`, `settleRealAsync`, `pumpUntilFound`, conventions §11.44, §11.54). Debounces are tested in fake time; stream switching in real time.
- **The accessibility tour** (`test/app/accessibility_tour_test.dart`) opens every screen and state in light and dark at 200 % text, on a tall phone surface, and checks no overflow, tap targets ≥ 48 × 48, a label on everything tappable, and WCAG AA text contrast.

## Proving the tests can fail

A test that can't fail proves nothing. In every phase, rules were **broken on purpose** (a mutation: a condition removed, a transaction dropped, a sort reversed), one at a time, and the suite run: each must make some test fail. **175 mutations, each caught:**

| Phase | Mutations | Examples |
|---|---:|---|
| 2: data | 25 | the upsert writing a row object instead of a full companion, no transaction, the partial index made total, foreign keys off, `hasEnded` end-inclusive |
| 3: Discover and Event detail | 21 | "upcoming" ending at the start, grouping by UTC's day, online events on the organizer's clock, the join link for someone not going |
| 4: Search and Saved | 21 | `LIKE` unescaped, the window not by overlap, "free" as "has a free offer", concurrent instead of restartable, Saved without Undo |
| 5: RSVP, tickets, agenda | 24 | Luhn without doubling, cancelling after the start, clashes end-inclusive, the booking outside a transaction |
| 6: organizers, profile, settings | 26 | Clear cache dropping owned events, the seed while dynamic color is off, no discard guard, a cancelled event as "next" |
| 7: notifications and background | 37 | cancelled events reminded, the horizon or cap ignored, a change recorded twice, a revoked permission kept on, the server counting from today |
| 8: the key behaviours, once more | 21 | below |

Phase 8 broke the correctness rules again against the **whole** suite, on the final code:

- **R2** the upsert as `INSERT OR REPLACE`; the sync without its transaction;
- **R3** a cancelled ticket counted as going;
- **R4** the booking without its transaction; an answer for another event accepted (missed at first; the test was added);
- **R5** the one-active-ticket index made non-unique;
- **R6** bookings after the start; a sold-out ticket type accepted;
- **R7** cancelling after the start;
- **R8** "upcoming" ending at the start; in-person events on the user's clock;
- **R12** Clear cache dropping ticketed events; **R13** the demo's replace without its transaction;
- foreign keys off; `LIKE` wildcards unescaped; the first-launch gate open; every settings key written; the wallpaper's color while dynamic color is off;
- the settings reload not waiting for its own writes, or overriding a newer change; the calendar anchor read again (the fixes of this phase).

## Checked on devices

Every phase was checked on an **iPhone 17 Pro simulator** (light, dark, large text) and, for dynamic color, notifications, the background worker and a release build, on an **Android 16 emulator** (Pixel 10 Pro). Two bugs only a device could show were found there and pinned with tests: the fake server's calendar moving with today (Phase 7), and a reload overtaking the notification switch's write on Android (Phase 8). A third, a release build shrinking away the notification icon, has no unit test: a release build is launched instead.

## Gotchas worth knowing

From the conventions' traps, the ones this suite runs into:

- **§11.44:** an unanswered platform call before the first pump waits on fake time forever; mock the channel (time zone, dynamic color) or answer at once.
- **§11.63:** `stream_transform`'s `debounce` keeps its timer after a cancel, and a widget test fails on it; use `settled`.
- **§11.71:** a `Stream.multi` watcher sees a change one microtask late; `waitFor` or `pumpEventQueue`.
- **§11.73:** a `MockCubit` pumped again keeps its first state; one state per test.
- **§11.74, §11.78:** `scrollUntilVisible` with a `.first` finder throws, and it doesn't scroll to a widget already built below the screen; follow it with `ensureVisible`.
- **§11.77:** under a full-screen dialog, `find.text` also matches the page beneath; target the dialog's widget type.
- **§11.79:** `AppLifecycleListener` wants every lifecycle step, in order.
- **§11.84:** the in-memory preferences store is more orderly than Android's; test reload races with a store whose writes or reads answer late.
