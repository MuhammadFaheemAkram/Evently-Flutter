# Contributing to Evently (Flutter)

Thanks for your interest! Evently is a learning-focused reference project, so contributions that improve clarity, correctness or teaching value are especially welcome.

## Ground Rules

- Be respectful. See the [Code of Conduct](CODE_OF_CONDUCT.md).
- **Keep the architecture intact:**
  - Respect the layer boundaries: View → Cubit/Bloc → UseCase → Repository → drift / the API.
  - `domain/` stays pure Dart, Views never import `data/`, and drift files never import `material_ui`.
  - **Screens read the cache, never the API.** Only a refresh, a booking and a cancellation talk to the server.
  - **The catalog and the user's data stay apart:** a sync writes only catalog tables (and never deletes an event); "saved", "going", "bookmarked" and "following" are joins over the user's own tables, never flags on an event.
  - **No ticket without the server:** a booking or cancellation writes only the server's answer, with the event's counts, in one transaction. A failure writes nothing.
  - **Times are UTC instants plus an IANA zone** (`EventTime`); "now" comes from the injected `Clock` (`EventClock`), never `DateTime.now()`. An in-person event is told on its venue's clock, an online one on the user's (see [TIME_ZONES.md](docs/TIME_ZONES.md)).
  - **Platform services stay behind `domain/service` interfaces** (`NotificationScheduler`, `NotificationInteractions`, `BackgroundWork`, `LinkOpener`, `DynamicColorSource`), so no plugin is reachable from a Cubit or use case test.
  - **Notifications change only through the plan:** edit `planNotifications` and let `SyncNotificationsUseCase` apply the difference; never schedule from a screen.
  - **Background code runs the same use cases** through `BackgroundGraph`; anything new it needs is added there by hand (`getIt` is empty in that isolate).
  - **The router owns navigation decisions.** Screens use typed routes only.
- **UI:** import `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- **Writes:** upsert with `ON CONFLICT DO UPDATE` and a full companion, never `INSERT OR REPLACE` (it deletes and cascades); rows that belong together go in one transaction.
- **Settings:** write only the keys that changed, and reload only after this isolate's own writes (the background isolate has its own cache).
- **Dependencies:** keep them few and mainstream, and explain each new one in the README's tech stack.

## Development Setup

- Install [FVM](https://fvm.app), then run `fvm install`. It reads `.fvmrc`, which pins Flutter 3.47.6.
- iOS needs Xcode. Android needs the Android SDK and Java 17+ (Android Studio's bundled JDK works).
- Get the packages with `fvm flutter pub get`, then start the app with `fvm flutter run`, choose a city and **Explore with demo data**.
- After changing annotated code (freezed, json_serializable, injectable, drift, typed routes), regenerate it:

  ```bash
  fvm dart run build_runner build
  ```

  Generated files are committed, and CI fails if they are stale or missing.
- **Changing the database schema:**
  1. Bump `schemaVersion` in `app_database.dart`.
  2. Run `fvm dart run drift_dev make-migrations`. It exports the new version to `drift_schemas/` and generates the steps and the migration tests.
  3. Write the new step in the migration strategy.
  4. Add a data test for the migration.
- **Changing the seed** (`assets/json/`): write times as `inDays` and `at` in the venue's zone, keep ids stable, and run `test/core/network/bundled_seed_test.dart`, which renders the seed as of six instants and checks every rule.
- **Trying notifications and background work** on a device: Settings → Developer (Publish a catalog update, Run background sync now, Show planned notifications), and [BACKGROUND_WORK.md](docs/BACKGROUND_WORK.md).
- **Before a release:** launch a **release** build once. Resource shrinking and tree shaking only happen there (conventions §11.85).

## Coding Conventions

- **Lints:** `fvm flutter analyze` must report **no issues**. The rules are `flutter_lints` plus strict casts, inference and raw types.
- **Formatting:** `fvm dart format .` (the tall style).
- **Pages and Views:** Pages create and provide a Cubit/Bloc. Views render state and forward intents.
- **Cubit or Bloc:** use a Cubit by default. Use a Bloc only when event transformers (debounce, `restartable`) earn their place, as in `SearchBloc`.
- **Writes return a `Result`** and never throw (`guardWrite`, `guardApiCall`); validation rules are pure functions shared by forms and use cases.
- **Immutable state:** freezed classes and sealed unions, rendered with an exhaustive `switch`.
- **Accessibility:** every tappable is at least 48 × 48 and has a label, text contrast meets WCAG AA in both themes, and color is never the only signal. Above 130 % text (`context.prefersStackedLayout`), side-by-side controls stack. The accessibility tour (`test/app/accessibility_tour_test.dart`) checks this, so add new screens and states to it.
- **Comments** explain *decisions*, not obvious code.

## Commits

This project uses **[Conventional Commits](https://www.conventionalcommits.org/)**:

```
<type>(<scope>): <message>
```

Examples: `feat(tickets): add a ticket to the calendar`, `fix(reminders): keep a moved event's reminder`, `test(search): cover a range across a clock change`, `docs(project): update the data model`.

## Pull Requests

1. Fork the repository and create a topic branch.
2. Make sure `fvm flutter analyze`, `fvm dart format --output=none --set-exit-if-changed .` and `fvm flutter test` all pass.
3. Update or add documentation where relevant.
4. Open a PR with a clear description of the change and its motivation.

## Tests

- **Rules:** pure unit tests with the fixtures in `test/helpers/` (`event()`, `organizer()`, `session()`, `card()`, `ticket()`); test each rule at its edge (an event ending now, a session touching another, a day across a clock change).
- **Cubits/Blocs, use cases and repositories:** on the real data stack (`DataStack`: real repositories, an in-memory database, the real fake server, a clock you can move, a `FakeNotificationScheduler`), with `waitFor` for bounded waits. `ScriptedEventlyApi` scripts the server's answers.
- **Views:** widget tests with `MockCubit` / `MockBloc` from `bloc_test`, and `mocktail`; one state per test (conventions §11.73).
- **drift:** an in-memory database; insert broken rows to prove a constraint.
- **Timing:** debounce timing in fake time (`fake_async`); anything that switches streams in real time with a short delay.
- **App-level flows:** `pumpEvently` (with `preferences:` and `notifications:`), and `tearDown(getIt.reset)`. A plugin touched while the graph is built needs its channel mocked in `configureTestDependencies`.
- **Background entry points:** pass a graph built from fakes to `dispatchBackgroundTask`.
- **Prove a new test can fail:** break the rule it guards and run it.

See [docs/TESTING.md](docs/TESTING.md).
