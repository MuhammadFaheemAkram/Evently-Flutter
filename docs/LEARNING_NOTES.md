# Learning Notes

Every Flutter / Dart concept Evently uses, grouped by topic, each pointing to where it lives in the code. The phase write-ups ([1](PHASE_1_SUMMARY.md) · [2](PHASE_2_SUMMARY.md) · [3](PHASE_3_SUMMARY.md) · [4](PHASE_4_SUMMARY.md) · [5](PHASE_5_SUMMARY.md) · [6](PHASE_6_SUMMARY.md) · [7](PHASE_7_SUMMARY.md) · [8](PHASE_8_SUMMARY.md)) explain the *why* in more depth.

---

## 1. Toolchain and project setup

| Concept | Where | Notes |
|---|---|---|
| FVM per-project pinning | `.fvmrc` | The Flutter version (3.47.6) is part of the repo. Run everything as `fvm flutter …`. |
| `material_ui` package | every UI file | Material as a standalone package: `package:material_ui/material_ui.dart`; `cupertino_ui` for the iOS time wheel and adaptive dialogs. |
| Strict analysis | `analysis_options.yaml` | `strict-casts`, `strict-inference`, `strict-raw-types`; generated files stay in scope, with lint headers from `build.yaml`. |
| Code generation | `build.yaml`, `*.g.dart`, `*.freezed.dart`, `*.config.dart`, `app_routes.g.dart` | `build_runner` output is committed; CI fails if it is stale or missing. |
| drift options | `build.yaml` | ISO-8601 text dates, and the `make-migrations` folders. |
| Schema exports | `drift_schemas/` | `drift_dev make-migrations` exports every version for migration tests. |
| Assets | `assets/json/` | The fake server's seed, the demo user and the catalog update, read through the injected `AssetBundle`. |
| Native setup | `android/app/build.gradle.kts`, `AndroidManifest.xml`, `res/drawable/ic_notification.xml`, `res/raw/keep.xml`, `ios/Runner/AppDelegate.swift`, `Info.plist` | Desugaring; notification permissions and the plugin's receivers; a white notification icon kept from resource shrinking; package visibility for `https` links; the iOS notification delegate, background registrant callbacks and the BGTask handler; `BGTaskSchedulerPermittedIdentifiers` and the `fetch` mode. |

## 2. Dart language

- **Extension types:** `CalendarDate` (a `yyyymmdd` `int`) and `TimeOfDayValue` (minutes since midnight), each with a private representation constructor, so every value goes through a validating factory. No runtime cost, real compile-time types. `TimeOfDayValue.eightAm` is a constant, so `AppSettings` can use it as a `@Default`.
- **Sealed classes + exhaustive `switch`:** `EventLocation` (`Venue` / `Online`), `NotificationTarget` (event / ticket / Tickets), `Result`, `AppException`, `RsvpProblem`, `SearchEvent` (with a sealed `SearchInputChanged` inside). A new case is a compile error everywhere one is handled.
- **Primary constructors (Dart 3.13):** `final class const Ok<T>(final T value) extends Result<T>;` (`core/common/result.dart`).
- **Private named parameters (Dart 3.13):** `BackgroundGraph({required this.runSync, required this._close})`, passed as `close:`.
- **Patterns:** `if (result case Ok(value: final ticket))`, `case OpenEvent(:final eventId)`, `if (change.ticketId case final ticketId?)`, `when` guards in `cancelBlock`, record destructuring of combined streams.
- **Records:** `EventVersion = ({String id, DateTime start, EventStatus status})` for change detection; `({String eventId, EventChangeKind kind})` for the changes to record; `(sessions, count)` from the agenda preview; `await (a, b).wait` in tests.
- **Class modifiers:** `final class`, `abstract final class` (namespaces such as `AppTheme`, `EventFormats`), `abstract interface class` (every repository and service contract), `base class` (a test store extending the in-memory preferences).
- **Enhanced enums** carry their words and values: `EventCategory('Technology')`, `TicketType('Workshop pass')`, `ReminderLead(Duration(hours: 1), '1 hour')`, `NotificationKind('Change alert')`.
- **`characters`:** the profile's name limit counts grapheme clusters, so "👩‍💻" is one character (`profile_validation.dart`).
- **Integer arithmetic:** a 32-bit FNV-1a hash for stable notification ids; Luhn mod N for ticket codes (a check character that catches every single substitution).

## 3. Architecture

- **Layers:** View → Cubit/Bloc → UseCase → Repository → drift, with `domain/` pure Dart. See [ARCHITECTURE.md](ARCHITECTURE.md).
- **Offline-first over server data:** every screen reads the cache; only a refresh, a booking and a cancellation talk to the server. See [OFFLINE_FIRST.md](OFFLINE_FIRST.md).
- **The server's data and the user's, apart:** "saved", "going", "bookmarked" and "following" are joins, so a sync can't lose them.
- **Server-confirmed writes:** the ticket and the event's counts in one transaction, only from the server's answer.
- **Change detection in the domain:** `diffCatalog` is a pure function the repository calls inside its write's transaction.
- **Services as interfaces:** `NotificationScheduler`, `NotificationInteractions`, `BackgroundWork`, `LinkOpener`, `DynamicColorSource`, `DeveloperTools` in `domain/service/`.
- **Two entry points, one rule set:** the background isolate runs the same use cases through a hand-built graph.

## 4. State management (flutter_bloc)

| Concept | Where |
|---|---|
| A Cubit per screen, subscribing in `load()` and cancelling in `close()` | `features/*/cubit/` |
| A Bloc with an event transformer: one debounce + `restartable` for typing, filters at once | `SearchBloc`, `bloc_concurrency` + `stream_transform` |
| An app-wide Cubit above the router | `SettingsCubit` in `EventlyApp` |
| freezed state with a status enum, rendered by an exhaustive `switch` | every `*_state.dart` |
| One-time effects as a value + a serial number, with `BlocListener(listenWhen:)` | SnackBars, the booked ticket replacing the RSVP form |
| `buildWhen` to rebuild the app only for the theme | `EventlyApp` |
| `bloc_test` for Cubits and the Bloc, `MockCubit` for views | `test/features/` |

## 5. Dependency injection (get_it + injectable)

- **Annotations:** `@injectable` (a new instance each time), `@lazySingleton`, `@LazySingleton(as: Interface)`.
- **`@module`** for third-party types (`AppModule`): the database and its DAOs, the clock, the asset bundle, the plugin wrapper under two interfaces, the fake API exposed as `EventlyApi`.
- **`@preResolve`** awaits values before `runApp`: preferences, the device's zone, the app's version, the wallpaper's colors.
- **`@ignoreParam`** for a parameter the graph shouldn't fill (`settle`, a test's `Random`).
- **A hand-built graph** where `getIt` doesn't exist: the background isolate (`BackgroundGraph`).
- **Tests swap registrations** after `configureDependencies()` (`unregister` / `registerSingleton`).

## 6. Navigation (go_router + go_router_builder)

- **Typed routes** (`@TypedGoRoute`, `.go(context)`, `.push(context)`, `.location`), never string paths in widgets.
- **`StatefulShellRoute.indexedStack`** for five tabs that keep their state, with a `NavigationBar` and a navigation drawer.
- **Root-level routes** pushed above the tab bar (an event with its RSVP and agenda as children, a ticket, an organizer, Settings, …).
- **A pure redirect** for the first launch, re-run through `refreshListenable` (a `StreamListenable` over the settings).
- **Full-screen dialogs** (`fullscreenDialog`), **sheets on the root navigator** (above the tab bar, §11.46).
- **Deep links and notification taps** use the same routes: an initial location on a cold start (with a Close fallback), a push on a warm one.

## 7. UI, Material 3 and accessibility

- **`ColorScheme.fromSeed`** themes, light and dark; **dynamic color** from the wallpaper on Android 12+ (`dynamic_color`'s palette as the seed).
- **A `ThemeExtension`** (`AppColors`) for colors that carry meaning (going, moved, cancelled, sold out), contrast-tested in both themes; a category palette with icons.
- **Adaptive widgets:** `SwitchListTile.adaptive`, adaptive confirm dialogs, `CircularProgressIndicator.adaptive`, `RefreshIndicator.adaptive`, Material's time picker or a Cupertino wheel.
- **Large text:** `context.prefersStackedLayout` (above 130 %) stacks layouts and turns segments into radios; carousels allow two lines for times.
- **Semantics:** headers, labels on icon buttons, spoken time ranges, status as an icon and a word, never color alone.
- **`qr_flutter`:** black on white in both themes, so scanners read it.
- **The accessibility tour:** `meetsGuideline(androidTapTargetGuideline)`, `labeledTapTargetGuideline`, `textContrastGuideline` on every screen.

## 8. Data and persistence

| Concept | Where |
|---|---|
| drift tables, `CHECK`s, a partial unique index (`@TableIndex.sql`), `textEnum`, type converters | `core/database/tables/` |
| `PRAGMA foreign_keys = ON` in `beforeOpen`; `KeyAction.cascade` only where a row is part of another | `app_database.dart` |
| DAOs, `watch()` streams, LEFT JOINs (`leftOuterJoin`), `customSelect` with `readsFrom`, `existsQuery` | `core/database/daos/` |
| Transactions across DAOs (nested calls join the outer one) | `CatalogRepositoryImpl.refresh`, `TicketsDao.book` |
| Upserts with `DoUpdate(toCompanion(false))`, never `REPLACE` (§11.53, §11.57) | `CatalogDao.upsertCatalog` |
| An escaped `LIKE` (`escapeChar`) | `EventsDao.escapeLike` |
| `shareAcrossIsolates` | `AppDatabase` |
| `SharedPreferencesWithCache`, writing only the keys that changed, reloading after its own writes | `SettingsRepositoryImpl` |
| `json_serializable` with `checked: true`, then mapping rules before any write | `core/network/dto/`, `data/mapper/` |

## 9. Time, notifications and background work

- **`timezone`:** `TZDateTime`, `getLocation`, the zone database loaded in `main`; instants plus an IANA zone (`EventTime`). See [TIME_ZONES.md](TIME_ZONES.md).
- **`flutter_timezone`:** the device's zone, read once before the first frame.
- **`clock`:** an injectable `Clock`, fixed in tests; `EventClock` for the user's now and today.
- **`intl`:** `DateFormat` patterns; 12- or 24-hour from `MediaQuery.alwaysUse24HourFormat`.
- **`flutter_local_notifications`:** channels, `zonedSchedule` at UTC instants, `show`, `pendingNotificationRequests`, permission on Android 13+ and iOS, `getNotificationAppLaunchDetails`. See [NOTIFICATIONS.md](NOTIFICATIONS.md).
- **Planning as data:** a pure planner, then a diff against what's pending.
- **`workmanager`:** a periodic task with constraints, `@pragma('vm:entry-point')`, a background isolate with its own graph. See [BACKGROUND_WORK.md](BACKGROUND_WORK.md).
- **`AppLifecycleListener`:** `onResume` to reload settings and re-plan.
- **`url_launcher`:** `https` links to maps and meeting apps; Android package visibility (`<queries>`).

## 10. Testing

- **The real stack, faked at the edges:** an in-memory database, the real fake server, a fixed clock, fake devices.
- **`bloc_test`, `mocktail`, `fake_async`** (debounces), real async for database work (`runAsync`).
- **Widget tests on the real DI graph** for flows; an accessibility tour with Flutter's guidelines.
- **Mutation checks:** rules broken on purpose to prove the tests catch them. See [TESTING.md](TESTING.md).
- **Platform fakes:** `FakeNotificationScheduler`, `RecordingLinkOpener`, mocked method channels, `InMemorySharedPreferencesAsync` (and slower subclasses to test races).

## 11. Tooling and repo hygiene

- **Conventional Commits,** one per phase, with a bulleted body.
- **CI** (`.github/workflows/flutter-ci.yml`): the FVM-pinned Flutter, generated code checked current, format, analyze, test.
- **Phase write-ups** with an Android / iOS comparison, and the open-source file set (CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, CHANGELOG, issue and PR templates).
- **Checked on devices,** debug and release: some bugs (a release build shrinking the notification icon, a preferences race on Android) only show there.
