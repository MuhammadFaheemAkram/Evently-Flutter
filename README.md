# 🎟️ Evently (Flutter)

[![Flutter CI](https://github.com/MuhammadFaheemAkram/Evently-Flutter/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/MuhammadFaheemAkram/Evently-Flutter/actions/workflows/flutter-ci.yml)
![Flutter 3.47.6](https://img.shields.io/badge/Flutter-3.47.6-02569B?logo=flutter)
![Dart 3.13](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

A learning-focused, production-inspired **Flutter** event app:
- **discover** events: featured, in your city, coming up, by category;
- **search** them, with filters (category, dates, free or paid, online or in person);
- **save** favourites, **RSVP** with a ticket type, and keep your **tickets** with a QR code;
- follow an event's **agenda** and bookmark sessions;
- follow **organizers**, manage your **profile** and **settings**;
- get **reminders** before the events you're going to.

It is built with **Flutter 3.47**, **Dart 3.13** and a clean, layered architecture, and runs on **Android and iOS**.

Evently is **offline-first**: an in-memory fake API serves the events, the app caches them in a database on the device, and every screen reads that cache. There is **no API key and no server**.

> **Why this repo exists**
>
> It is the Flutter edition of an app that also exists natively for [Android](https://github.com/MuhammadFaheemAkram/Evently) and [iOS](https://github.com/MuhammadFaheemAkram/iEvently). This edition follows the **Android** one closely (its Jetpack Compose UI is already Material 3) and adapts to iOS where the platform has its own conventions. It focuses on:
> - **offline-first over server data:** the event catalog is fetched, cached in drift and refreshed; Discover, Saved, Tickets and an event's page work with no network;
> - **the server's data and the user's, kept apart:** "saved" and "going" are joins, never flags on an event, so a sync can't lose them;
> - **writes the server must confirm:** no ticket exists until the (fake) server books it; a failure writes nothing;
> - **time done properly:** events are instants with their own time zone, shown in the venue's local time;
> - **search with a typed filter**, debounced, over the cache;
> - **notifications planned from your tickets**, and a background sync that notices when an event you're going to moves or is cancelled;
> - typed `go_router` navigation with a tab bar *and* a navigation drawer, code-generated DI, and a test suite that includes an accessibility tour.
>
> Each phase ships with a beginner-to-intermediate friendly write-up in [`docs/`](docs/) that also shows how the Android and iOS editions approached the same feature.

---

## 📋 Project Status

Evently is built in **strict, reviewable phases**. Each phase ends with:
- a building app (Android + iOS);
- a clean analyzer and passing tests;
- a summary doc;
- exactly one commit.

| Phase | Scope | Status |
|------:|-------|:------:|
| 1 | Foundation: FVM project, design system base with the category palette, typed routes with a first-launch gate, 5-tab shell with a navigation drawer, CI | ✅ Done |
| 2 | Data models with time zones, the drift cache (catalog and user tables), the fake API, Welcome | ⏳ Next |
| 3 | Discover and Event detail | |
| 4 | Search and Saved | |
| 5 | RSVP, tickets and the agenda | |
| 6 | Organizers, profile and settings | |
| 7 | Notifications and background sync | |
| 8 | Open-source polish and final docs | |

---

## ✨ Features (the plan)

- 🚀 **First launch:** pick your city, then explore with demo data or start fresh
- 🧭 **Discover:** featured events, events in your city, what's coming up by day, categories, pull to refresh, save and RSVP from a card
- 🔎 **Search:** title, organizer, venue or city; filters for category, dates, price, format and RSVP status; recent searches
- 📅 **Event detail:** the venue's local time, location with directions or the join link, places left, ticket prices, the agenda and the organizer, a reminder toggle
- 🎫 **RSVP and tickets:** choose a ticket type, confirmed by the server; tickets with a QR code, upcoming and past, cancel before the start
- 🗓️ **Agenda:** sessions by day, bookmarks, and clashes between them
- 🔖 **Saved:** your saved events, offline
- 👥 **Organizers:** profiles, their events, follow
- 👤 **Profile and settings:** edit your profile; appearance, dynamic color (Android 12+), notifications, your city, clear cache, reset demo data, developer tools
- 🔔 **Reminders:** before events you're going to, a confirmation when you book, a daily summary, and an alert when an event moves or is cancelled
- ♿ **Accessible:** dark mode and large text on every screen, labelled controls, never color alone, checked by a test tour that grows with the app

---

## 🧰 Tech Stack

Packages arrive in the phase that first needs them.

| Area | Choice | Since |
|------|--------|:-----:|
| Toolchain | Flutter 3.47.6 · Dart 3.13, pinned per project with [FVM](https://fvm.app) (`.fvmrc`) | 1 |
| Platforms | Android · iOS 15+ | 1 |
| UI | [`material_ui`](https://pub.dev/packages/material_ui): Material 3 as a standalone package; adaptive widgets on iOS where it matters | 1 |
| Navigation | `go_router` + `go_router_builder` (typed routes, `StatefulShellRoute`, a first-launch `redirect`) | 1 |
| Dependency injection | `get_it` + `injectable` (a code-generated composition root) | 1 |
| Lints / CI | `flutter_lints` + strict analyzer modes; GitHub Actions | 1 |
| Testing | `flutter_test` | 1 |

Planned: `flutter_bloc`, `freezed`, `json_serializable`, `drift`, `shared_preferences`, `clock`, `intl`, `timezone` (Phase 2); `url_launcher` (Phase 3); `bloc_concurrency`, `stream_transform` (Phase 4); `qr_flutter` (Phase 5); `dynamic_color`, `package_info_plus` (Phase 6); `flutter_local_notifications`, `workmanager` (Phase 7).

---

## 🏛️ Architecture

A clean, layered architecture with a one-directional data flow:

```
lib/
├── app/        → root widget (MaterialApp.router, themes)
├── core/       → design system, navigation, (later) the database, the fake API, notifications, background work
├── data/       → repository implementations + mappers               (Phase 2)
├── domain/     → models, pure calculations, contracts, use cases     (Phase 2)
├── features/   → one folder per screen (Page + View + Cubit/Bloc)
└── di/         → composition root (get_it + injectable)
```

**Navigation:**

```
GoRouter ── redirect: firstLaunchRedirect(onboarded, location)   ◀── refreshListenable
  │
  ├─ /welcome          (until the user has started)
  │
  ├─ tab shell         StatefulShellRoute ── MainShell (NavigationBar + navigation drawer)
  │                      /discover · /search · /saved · /tickets · /profile
  │
  └─ root-level        /events/:eventId (+ /rsvp, /agenda), /tickets/:ticketId, /organizers/:organizerId,
     screens           /following, /profile/edit, /settings, /about
                       → pushed above the tab bar; RSVP and Edit profile open as full-screen dialogs
```

Key rules:
- **The router owns the gate.** No screen navigates after Welcome's choice: it records the choice, and `refreshListenable` re-runs the pure `firstLaunchRedirect`.
- **Typed routes only:** no string paths in widgets.
- **Tabs and a drawer, as in the Android edition.** The five tabs are a `NavigationBar`; Following, Settings and About live in a drawer that slides over the whole screen. Every tab's app bar opens it, and Profile also opens Settings.
- **Screens above the tabs** are pushed on the root navigator, so Back, and the iOS edge swipe, return to the tab with its state intact. Links work: `/events/e1/rsvp` opens the booking dialog over its event, and a link opened cold gets a Close button.
- **Widgets render state; logic lives elsewhere.** Each screen is a Page plus a View.
- **Layer boundaries:** `domain/` is pure Dart, Views never import `data/`, and only `data/` touches the database and the API.

---

## 🗂️ Folder Structure

```
Evently/
├── .fvmrc                          # pinned Flutter version (3.47.6)
├── .github/workflows/flutter-ci.yml
├── analysis_options.yaml           # lints + strict analyzer modes
├── build.yaml                      # lint-free generated files
├── lib/
│   ├── main.dart                   # binding → configureDependencies() → runApp
│   ├── app/                        # EventlyApp: themes and the router
│   ├── core/
│   │   ├── design_system/          # theme/ (AppTheme, AppColors, CategoryPalette, tokens), widgets/ (state views, SectionHeader), large_text
│   │   └── navigation/             # app_routes (+ .g.dart), app_router, first_launch_redirect, fallback Close button
│   ├── features/                   # welcome, shell (tabs + drawer), discover, search, saved, tickets, profile,
│   │                               # event_detail, rsvp, agenda, ticket_detail, organizer, following, profile_edit, settings, about
│   └── di/                         # injection.dart (+ .config.dart)
└── test/                           # mirrors lib/, plus app/ (the accessibility tour) and helpers/
```

---

## ▶️ How to Run

Prerequisites:
- [FVM](https://fvm.app);
- Xcode, for iOS;
- the Android SDK, with Java 17+ (Android Studio's bundled JDK works).

```bash
fvm install            # installs the version pinned in .fvmrc (3.47.6)
fvm flutter pub get
fvm flutter run        # pick an Android emulator or an iOS simulator
```

Generated code (`*.g.dart`, `*.config.dart`) is committed, so the app runs straight after cloning. After changing annotated code, regenerate it:

```bash
fvm dart run build_runner build
```

---

## ✅ Testing

```bash
fvm flutter analyze
fvm dart format --output=none --set-exit-if-changed .
fvm flutter test
```

**122 tests** after Phase 1:
- **Navigation:** every rule of the first-launch gate; typed locations, ids encoded; the app on its real DI graph (first launch and both choices, each tab, the drawer over every tab, Following, Settings and About above the tabs with Back, Edit profile as a full-screen dialog, Settings from Profile, the RSVP dialog and the agenda over their event, deep links with a Close button, an unknown location).
- **Design system:** the themes, WCAG AA contrast of every state color (going, sold out, moved, cancelled) on the page, cards and filled fields, and of all eight category colors with their text, in both themes; each category's own icon.
- **The drawer:** its order, the selected tab, where each item leads, and its width at large text.
- **The accessibility tour:** Welcome, the drawer and every screen, in light and dark at 200 % text: no overflow, tap targets ≥ 48 × 48, labels, contrast. The tab labels keep their size at 300 % (a long press shows them).

CI (`.github/workflows/flutter-ci.yml`) runs on every push to `main` and every pull request. It installs the FVM-pinned Flutter, checks that the committed generated code is up to date and complete, then runs format, analyze and test.

---

## 📱 Same App on Other Platforms

| Edition | Stack | Repo |
|---------|-------|------|
| Android | Kotlin · Jetpack Compose · Hilt · Room · DataStore · WorkManager | [MuhammadFaheemAkram/Evently](https://github.com/MuhammadFaheemAkram/Evently) |
| iOS | Swift 6 · SwiftUI · SwiftData · UserNotifications · BGTaskScheduler | [MuhammadFaheemAkram/iEvently](https://github.com/MuhammadFaheemAkram/iEvently) |
| **Flutter** | Dart · Flutter · Bloc · drift · workmanager | this repo |

| Concept | Android | iOS | Flutter |
|---|---|---|---|
| UI | Jetpack Compose | SwiftUI | widgets + `material_ui` (adaptive where it matters) |
| Navigation | bottom bar + drawer | `TabView` | `StatefulShellRoute` + `NavigationBar` + a `Drawer` |
| Screen state | ViewModel + StateFlow | `@Observable` | Cubit / Bloc |
| Cache | Room + DataStore | SwiftData + `@AppStorage` | drift + `SharedPreferencesWithCache` |
| Fake API | Retrofit-style services | protocols + fakes | `EventlyApi`, in memory, seeded from JSON |
| DI | Hilt | `AppEnvironment` | `get_it` + `injectable` |

---

## 📚 Documentation

- [Phase 1 — Foundation](docs/PHASE_1_SUMMARY.md)

---

## 🗺️ Roadmap

The phases above. Ideas after them are collected in `docs/ROADMAP.md` in Phase 8.

---

## 📄 License

[MIT](LICENSE) © 2026 BitFuse
