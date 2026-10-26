# Architecture

Evently is a layered, offline-first app with a one-directional data flow. A (fake) server owns the event catalog; the app caches it in drift, and **every screen reads the cache, never the API**. What the user does (saves, tickets, bookmarks, follows, reminders, the profile) lives in tables of its own, joined to the catalog when a screen reads it.

```
lib/
├── main.dart     → binding → time zones → configureDependencies() (awaits @preResolve values)
│                   → background work registered → the launch notification's screen → runApp
├── app/          → EventlyApp: the app-wide SettingsCubit, themes, the router, UserTimeZone,
│                   and what runs while the app does (the notification sync, resume, taps)
├── background/   → the OS's entry point (workmanager) and its hand-built BackgroundGraph
├── core/
│   ├── common/        Result, AppException (sealed), guardWrite, EventClock + DeviceTimeZone, Stream.settled
│   ├── database/      AppDatabase (drift v1, shared across isolates), tables/, daos/, converters
│   ├── design_system/ theme/ (AppTheme, AppColors, CategoryPalette), formatting/ (EventFormats), widgets/,
│   │                  UserTimeZone, the large-text rule
│   ├── navigation/    typed routes, the router, firstLaunchRedirect, the Close fallback, StreamListenable
│   ├── network/       EventlyApi, FakeEventlyApi, SeedRenderer, DemoCalendar, NetworkSimulator,
│   │                  AssetJsonLoader, FakeDeveloperTools, dto/
│   ├── platform/      LocalNotifications, WorkmanagerBackgroundWork, UrlLauncherLinkOpener,
│   │                  MaterialYouColorSource, the device's time zone
│   └── storage/       SettingsLocalDataSource (SharedPreferencesWithCache)
├── data/         → repository implementations, mappers (DTO → model → rows → model), the API guard
├── domain/       → models, rules (calculation/), repository contracts, service interfaces, use cases: pure Dart
├── features/     → one folder per screen: Page + View (+ cubit/ or bloc/, widgets/)
└── di/           → injection.dart (+ .config.dart), app_module.dart
```

```
View ─intent─▶ Cubit/Bloc ─▶ UseCase ─▶ Repository ─▶ drift ◀── watch() streams ── Repository ─▶ Cubit ─▶ state ─▶ View
                                            │
                                            └─▶ EventlyApi (fake, in memory) ── only to refresh, book or cancel
                                   └─▶ Service (notifications, background work, links, wallpaper colors)

app-wide watcher:    remindable events / settings ──settled──▶ SyncNotifications ──▶ the device
on resume:           settings reloaded ──▶ SyncNotifications
background isolate:  workmanager ──▶ BackgroundGraph ──▶ RunBackgroundSync (refresh → alert → re-plan), same database
```

## Layers and their rules

Checked against the imports in the code:

| Layer | May import | Never imports |
|---|---|---|
| `domain/` | Dart, `freezed_annotation`, `injectable`, `timezone`, `intl`, `characters`, `stream_transform`, `core/common` | Flutter, drift, `data/`, other `core/` |
| `data/` | `domain/`, `core/database`, `core/network`, `core/storage`, `core/common` | `features/`, `material_ui` |
| `core/database/` | drift | `material_ui`, JSON packages (name clashes, conventions §11.1) |
| `core/platform/` | plugins, `domain/` | `features/`, `data/` |
| `features/` | `domain/`, `core/design_system`, `core/navigation`, `di/` (Pages only) | `data/`, drift |
| `background/` | everything it wires (a composition root, like `di/`) | `features/` |

- **Pages and Views:** a Page creates and provides its Cubit (`getIt<…>()`); a View renders state and forwards intents. View tests mock the Cubit; Cubit tests run on the real data stack.
- **One use case per user action:** `RefreshCatalog`, `SetEventSaved`, `SearchEvents`, `RsvpEvent`, `CancelRsvp`, `SetSessionBookmarked`, `SetFollowing`, `UpdateProfile`, `SetEventReminder`, `SetNotificationsEnabled`, `ClearCache`, `ResetDemoData`, `StartWithDemo`, `RunBackgroundSync`, one per setting… They hold the rules that aren't SQL: "the form is checked again against the latest event", "cancel only before the start", "denied permission keeps notifications off".
- **Pure rules** in `domain/calculation/`: upcoming and past (`event_timeline`), why an event can't be booked (`rsvp_rules`), the RSVP form (`rsvp_validation`), ticket codes, why a ticket can't be cancelled, agenda days and clashes, Discover's sections, date presets, maps links, profile validation, `diffCatalog`, and `planNotifications`. Tested without Flutter or a database.

## Who owns what

| Data | Owner | Written by |
|---|---|---|
| organizers, events, ticket offers, sessions (the catalog) | the server | a refresh (one transaction), and a booking or cancellation the server confirmed (its event's new counts) |
| saved events, session bookmarks, follows, reminder choices, recent searches, the profile | the user | their repositories, locally, offline |
| tickets | the user, issued by the server | `BookingRepository`, only from the server's answer |
| change records (`event_changes`) | the app, about the user's tickets | a refresh, in its transaction; marked alerted when claimed |
| settings | the device | `SettingsRepository` (only the keys that changed) |
| the notifications on the device | derived from all of the above | `SyncNotificationsUseCase` (planned), `ShowRsvpConfirmation` and `AlertCatalogChanges` (shown at once) |
| the server's state (places taken, issued tickets, a published update), its calendar anchor | the fake server | `FakeEventlyApi` (memory), `DemoCalendar` (preferences) |

See [OFFLINE_FIRST.md](OFFLINE_FIRST.md) and [DATA_MODEL.md](DATA_MODEL.md).

## State management

- **Cubits by default:** one per screen (`WelcomeCubit`, `DiscoverCubit`, `EventDetailCubit`, `SavedCubit`, `RsvpCubit`, `TicketsCubit`, `TicketDetailCubit`, `AgendaCubit`, `OrganizerCubit`, `FollowingCubit`, `ProfileCubit`, `ProfileEditCubit`, `SettingsToolsCubit`). Each subscribes in `load()`/`start()` and cancels in `close()`.
- **One Bloc:** `SearchBloc`. Text and filter changes are one sealed `SearchInputChanged` event under one transformer: a debounce for typing (filters apply at once), then `restartable`, which drops the previous query's live results.
- **One app-wide Cubit:** `SettingsCubit` above `MaterialApp.router` (theme mode, dynamic color, the notification preferences). Everything else belongs to its screen.
- **Immutable state:** freezed classes with a status enum, exhaustive `switch`es.
- **One-time effects** (SnackBars, the booked ticket replacing the RSVP form) are a value plus a serial number in the state, so the same message twice still shows twice; `BlocListener` with `listenWhen` on the serial.
- **App-wide work** lives in `EventlyApp`'s `State`: `KeepNotificationsInSync` (settled 300 ms, `asyncMap`), `AppLifecycleListener(onResume:)`, and the notification taps.

## Error handling

- **Every write returns a `Result`** (`Ok` / `Err`) and never throws. `guardWrite` (local writes) and `guardApiCall` (a request and its write) turn exceptions into an `AppException`.
- **`AppException` is sealed:** `NetworkException`, `DataFormatException`, `NotFoundException`, `InvalidInputException`, `SoldOutException`, `AlreadyBookedException`, `BookingClosedException`, `UnsafeLinkException`, `LinkOpenFailedException`, `UnknownException`, each with a message written for the user.
- **A failure writes nothing:** a refresh checks and maps the whole catalog before one transaction writes it; a booking writes only the server's answer. Offline, the screens keep the cache and say so.
- **Validation is pure** (`rsvp_validation`, `profile_validation`), shared by the forms (errors after the first Confirm or Save) and the use cases (which refuse what slips past). The database's `CHECK`s back it up.
- **Notifications and the background never fail the user's action:** a confirmation that can't be shown is logged; a background step that fails is reported and the next run tries again.

## Navigation

- **Typed `go_router` routes** (`go_router_builder`): a `StatefulShellRoute.indexedStack` with five tabs (Discover, Search, Saved, Tickets, Profile), and root-level routes above them: an event (with its RSVP and agenda as children), a ticket, an organizer, Following, Edit profile, Settings, About.
- **A tab bar and a drawer**, as in the Android edition: the drawer (the tabs, Following, Settings, About) belongs to the shell's outer `Scaffold`; `ShellDrawerScope` lets each tab's app bar open it.
- **A pure gate:** `firstLaunchRedirect(onboarded, location)`, re-run through a `refreshListenable` over the settings stream. No screen navigates after Welcome's choice.
- **Full-screen dialogs** for RSVP and Edit profile; **sheets** for filters, the iOS time wheel and the planned notifications (on the root navigator, above the tab bar).
- **Deep links** work everywhere, with a Close button when opened cold. A notification's tap uses the same routes: cold, it's the initial location; warm, the screen is pushed (the summary switches to Tickets).

## Dependency injection

- **`get_it` + `injectable`:** classes are annotated (`@injectable`, `@LazySingleton(as: …)`), and `build_runner` generates the composition root.
- **`AppModule`** provides third-party objects: the API (the fake, registered as itself so the developer tools reach the same instance), the asset bundle, the `Clock`, the database and its DAOs, `LocalNotifications` (under both its interfaces), and four `@preResolve` values awaited before `runApp`: `SharedPreferencesWithCache` (the router knows where to open), `DeviceTimeZone`, `AppInfo` and `DeviceColors`.
- **The background isolate** builds its own small graph by hand (`BackgroundGraph`), from the same classes: `getIt` is empty in a new isolate.
- **Tests swap a few registrations** (`configureTestDependencies`): an in-memory database, a zero-latency network, a fixed clock, in-memory preferences, London as the device's zone, a recording link opener, a fake notification scheduler, no background work.

## Platform services

All behind `domain/service` interfaces, implemented in `core/platform` (or `core/network` for the fake server's switches):

| Interface | Implementation | Platforms |
|---|---|---|
| `NotificationScheduler`, `NotificationInteractions` | `LocalNotifications`: `flutter_local_notifications` + `timezone` | both: three channels on Android |
| `BackgroundWork` | `WorkmanagerBackgroundWork`: `workmanager` | WorkManager (Android), BGTaskScheduler (iOS) |
| `LinkOpener` | `UrlLauncherLinkOpener`: `url_launcher`, `https` only | both: Apple Maps or Google Maps, the browser or a meeting app |
| `DynamicColorSource` | `MaterialYouColorSource`: `dynamic_color` (the palette only, §11.55) | Android 12+; `null` elsewhere |
| `DeveloperTools` | `FakeDeveloperTools`: the fake network and server | both |

The device's time zone (`flutter_timezone`) is read once, before the first frame, into `DeviceTimeZone`. See [TIME_ZONES.md](TIME_ZONES.md), [NOTIFICATIONS.md](NOTIFICATIONS.md) and [BACKGROUND_WORK.md](BACKGROUND_WORK.md).

## Accessibility

- **Every screen is in the accessibility tour** (light and dark, 200 % text): no overflow, tap targets ≥ 48 × 48, every tappable labelled, WCAG AA text contrast.
- **The large-text rule:** above 130 % (`context.prefersStackedLayout`), side-by-side layouts stack and segments become a radio list.
- **Never color alone:** Going, Moved, Cancelled, Sold out, clashes and ticket states each have an icon and a word; category colors come with an icon and a name.
- **Times are spoken whole:** a zoned time range has a spoken form ("Saturday 31 October, 8:00 PM to 11:30 PM, GMT").
- **Tab labels keep their size** (a long press shows them), as iOS tab bars do.

## Key decisions

| Decision | Why |
|---|---|
| The catalog and the user's data in separate tables; "saved" and "going" are joins | A sync can rewrite an event without losing anything the user did |
| User rows point at events without `CASCADE` (`NO ACTION`) | Nothing the user owns disappears with the cache; Clear cache deletes only what nothing points at |
| A sync never deletes, and upserts in one transaction (never `REPLACE`) | `REPLACE` deletes first, which would cascade into or be refused by the user's rows |
| Bookings wait for the server; saves don't | Only the server knows if a place is left; a save is the user's own note |
| Events are two UTC instants plus the venue's IANA zone | An event happens at one moment everywhere; the zone is how it's told |
| Change detection in the domain, inside the refresh's transaction | "Moved" is a rule of the app, tested with plain values; recorded once because the next refresh compares against a cache that has it |
| Notifications planned as data and diffed | Reminders follow the tickets, saves, toggles, the catalog and the settings without code at each of those places |
| A background isolate with its own graph, on a shared database | The same use cases run without the app; drift's server keeps the isolates' writes apart and their streams current |
| Settings written key by key, reloaded on resume after the app's own writes | Two isolates, two preference caches; and Android's store can let a read overtake a write made just before it (§11.84) |
| The fake server renders from a stored calendar anchor | Events don't move a day each day, so change detection reports only real changes |
| Android-first UI, adaptive on iOS | The Android edition is Material 3 already; iOS gets its alerts, switches and time wheel |
| `material_ui` instead of `flutter/material.dart` | Material as a versioned package |
