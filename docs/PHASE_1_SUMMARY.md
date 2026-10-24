# Phase 1 — Foundation

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 1, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 1 builds the frame every later phase hangs on:
- a **pinned toolchain** and strict analysis, with CI from the first commit;
- a **design system base:** themes, the state colors (going, sold out, moved, cancelled), the eight category styles, tokens and the shared state views;
- **navigation:** a first-launch gate, five tabs, a navigation drawer for the screens that don't fit in a tab bar, and every screen above the tabs reachable by a typed route and by a link;
- **placeholder screens** with their final app bars, so the shape of the app is visible and testable now;
- an **accessibility tour** that checks every screen from day one.

---

## 🧱 What Was Implemented

- **Project:** `evently` (org `co.bitfuse.flutter`, display name "Evently"), Flutter 3.47.6 pinned by FVM, Android and iOS, `material_ui`.
- **Quality gates:**
  - `analysis_options.yaml`: flutter_lints plus strict casts, inference and raw types;
  - `build.yaml`: lint-free generated parts;
  - GitHub Actions CI: generated code up to date with nothing left untracked, then format, analyze and test;
  - the MIT license.
- **Design system:**
  - `AppTheme`: Material 3 light and dark themes from an indigo-violet seed (`#5B4FE9`), built through `AppTheme.fromScheme(ColorScheme)`, so Android's dynamic color can replace the scheme in Phase 6.
  - `AppColors` (a `ThemeExtension`): `going`, `soldOut`, `moved` and `cancelled`. Each is a text color that reaches WCAG AA on the page, cards and filled fields in both themes (tested).
  - `CategoryPalette`: the eight event categories (technology, business, design, sports, education, music, community, health). Each gives a container and an on-container color for the current brightness, derived from the category's color as a seed and cached, plus its own icon. Evently shows **no network images**: an event's banner will be its category's color and icon. Every pair reaches AA in both themes (tested).
  - The rest: spacing, radius and icon-size tokens; `LoadingView`, `ErrorView`, `EmptyStateView`, `SectionHeader`; and the large-text rule (`prefersStackedLayout`).
- **Navigation (typed `go_router` routes):**
  - `/welcome`, gated by the pure `firstLaunchRedirect(onboarded, location)` and a `refreshListenable`;
  - a `StatefulShellRoute` with five tabs: Discover, Search, Saved, Tickets, Profile;
  - above the tabs: Event detail at `/events/:eventId`, with RSVP (`/rsvp`, a full-screen dialog) and the agenda (`/agenda`) as children; a ticket at `/tickets/:ticketId`; an organizer at `/organizers/:organizerId`; `/following`; Edit profile at `/profile/edit` (a full-screen dialog); `/settings`; `/about`;
  - "Page not found" for an unknown location, with a way back.
- **The shell:**
  - a `NavigationBar` whose labels keep their size at any text setting;
  - the **navigation drawer** (the five tabs, then Following and Settings, then About) on the shell's outer `Scaffold`, so it covers the tab bar. Every tab's menu button opens it through a small `ShellDrawerScope`;
  - Profile also opens Settings (an app-bar button and a row) and Edit profile.
- **Screens:**
  - Welcome: "Explore with demo data" and "Start fresh";
  - the five tabs and every screen above them, each with its final app bar;
  - screens opened by a link get a Close button to a sensible home (conventions §11.47): an event → Discover, a ticket → Tickets, Settings → Profile; the RSVP dialog and the agenda go back to their event;
  - About opens the open-source licenses.
- **DI:** the `get_it` + `injectable` composition root, with a temporary in-memory `PlaceholderOnboarding` until the saved setting arrives in Phase 2.
- **Tests:** 122.

### Differences from the plan

- **Momentum's later fixes, from the start.** The drawer widens to 90 % of the screen at large text (a long label broke mid-word at AX3 in Momentum), and headings are their own semantics node (`container: true`). Both were Momentum lessons from Phases 3–4; here they're in from Phase 1.
- **No shortened tab labels.** Momentum's bar needed "Badges" for "Achievements". Evently's five labels are one short word each, so `AppTab` has only `label`, and a test pins the five.
- **No FABs yet**, so no hero-tag question (Momentum's trap §11.59): Evently's actions live in its cards and screens.
- **The Android build file's template TODOs** became notes now, rather than in the last phase as in Momentum.
- **The agenda's folder is `agenda/`**, not `schedule/`, matching the screen's name (the spec's folder list is updated).

---

## 💙 Flutter / Dart Concepts Demonstrated

- **FVM pinning:** `.fvmrc` makes the Flutter version part of the repository; the machine's global version stays untouched.
- **Typed routes:** `@TypedGoRoute` classes generate `location`, `go` and `push`; a route with a parameter can't be built without it, and ids are encoded into the path (`a b/c` → `a%20b%2Fc`, tested).
- **Child routes for "over its parent":** RSVP and the agenda are children of `/events/:eventId`, so a link to either opens with the event underneath, and Close or Back returns to it.
- **A tab path and a root-level path side by side:** `/tickets` is a tab, `/tickets/:ticketId` a screen above the shell; `/profile` a tab, `/profile/edit` a dialog above it.
- **`StatefulShellRoute.indexedStack`:** a navigator per tab, kept alive, so each tab keeps its stack and scroll position.
- **A drawer above nested Scaffolds:** the drawer belongs to the outer `Scaffold`, and an `InheritedWidget` (`ShellDrawerScope`) lets the inner tab app bars open it.
- **Sealed classes for a menu's results:** `DrawerDestination` is either a `TabDestination(index)` or a `ScreenDestination` (an enum that `implements` the sealed class), handled with an exhaustive `switch`.
- **Full-screen dialogs:** `MaterialPage(fullscreenDialog: true)` slides up and shows a Close button: Material's counterpart of an iOS sheet.
- **A pure redirect:** `firstLaunchRedirect` is a plain function, re-run by the router whenever its `refreshListenable` changes.
- **`ThemeExtension`:** colors Material has no slot for, switching and animating (`lerp`) with the theme.
- **`ColorScheme.fromSeed` as a palette generator:** each category's color becomes a tonal container pair that suits the brightness.
- **`MediaQuery.withNoTextScaling`** for the tab labels, with the label still available through a long press and to screen readers.
- **Accessibility guidelines in tests:** `meetsGuideline(androidTapTargetGuideline / labeledTapTargetGuideline / textContrastGuideline)`.

---

## 🔁 Data Flow (this phase)

```
App start ─▶ configureDependencies() ─▶ EventlyApp ─▶ GoRouter(initialLocation: /discover)
  redirect: firstLaunchRedirect(onboarded: PlaceholderOnboarding.onboarded, location)
    not onboarded ─▶ /welcome ── "Explore with demo data" / "Start fresh" ─▶ onboarding.complete()
                                     └─ notifyListeners ─▶ refreshListenable ─▶ redirect ─▶ /discover
    onboarded ─▶ the tab shell
      menu button ─▶ ShellDrawerScope.openDrawer ─▶ drawer
        tab item ─▶ goBranch(index)        Following / Settings / About ─▶ push (root navigator)
      Profile ─▶ Edit profile ─▶ ProfileEditRoute().push ─▶ full-screen dialog
      a link ─▶ /events/e1/rsvp ─▶ the event, with the RSVP dialog over it
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `.fvmrc`, `analysis_options.yaml`, `build.yaml`, `.github/workflows/flutter-ci.yml` | Toolchain, lints, codegen, CI. |
| `lib/core/design_system/**` | Theme, state colors, the category palette, tokens, state views, the large-text rule. |
| `lib/core/navigation/app_routes.dart` (+ `.g.dart`) | Every typed route. |
| `lib/core/navigation/app_router.dart`, `first_launch_redirect.dart`, `placeholder_onboarding.dart`, `fallback_close_button.dart` | The router, its gate, and the Close fallback for links. |
| `lib/features/shell/{main_shell,app_navigation_drawer,shell_drawer_scope}.dart` | Tabs and the drawer. |
| `lib/features/*/…_page.dart` | Welcome, Profile, Settings, About and the placeholder screens. |
| `lib/app/evently_app.dart`, `lib/di/injection.dart`, `lib/main.dart` | The app root and DI. |
| `test/app/accessibility_tour_test.dart`, `test/core/navigation/*`, `test/helpers/*` | The tour, navigation tests, the app harness. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `AppTheme` | final class (namespace) | Themes from a seed or any `ColorScheme` | `core/design_system/theme` |
| `AppColors` | `ThemeExtension` | Going, sold out, moved and cancelled colors | `core/design_system/theme` |
| `CategoryPalette`, `CategoryStyle` | final class / value | A category's name → its container pair and icon for a brightness | `core/design_system/theme`: views use it; the API and the domain hold only the name |
| `firstLaunchRedirect` | pure function | Welcome until started | `core/navigation`: one-line unit tests |
| `PlaceholderOnboarding` | `ChangeNotifier` (temporary) | The onboarded flag, in memory | replaced in Phase 2 |
| `MainShell` | StatefulWidget | Tabs and the drawer | `features/shell` |
| `AppTab`, `DrawerDestination` (`TabDestination`, `ScreenDestination`) | enum / sealed class | What the drawer and bar offer | `features/shell` |
| `ShellDrawerScope`, `DrawerMenuButton` | InheritedWidget / widget | Open the drawer from any tab | `features/shell` |

---

## 🌱 Folder Structure Changes

- **New project.** `lib/app`, `lib/core/{design_system,navigation}`, `lib/features/*`, `lib/di`; `test/` mirroring it, plus `test/app` and `test/helpers`.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Project | Compose, Hilt, Navigation Compose | SwiftUI, `AppEnvironment`, `Route` + `Router` | FVM-pinned Flutter, `get_it` + `injectable`, typed `go_router` |
| Tabs | bottom navigation (tabs not named) | `TabView`: Discover, Search, Saved, Tickets, Profile | `StatefulShellRoute` + `NavigationBar`: iOS's five |
| Secondary screens | a `ModalNavigationDrawer` | Schedule, Organizer and Settings from detail screens or a More menu | a `Drawer` (as Android): Following, Settings, About; Settings also on Profile; the event's screens (RSVP, agenda, organizer) pushed from the event |
| RSVP presentation | a screen | "may be a sheet" | a full-screen dialog over its event |
| Theme | Material 3, dark mode, dynamic color | light/dark, Dynamic Type | Material 3 from a seed; `fromScheme` ready for dynamic color; a category palette with icons (no network images); the large-text rule |
| Placeholders | placeholder screens | `TabView` with placeholders | placeholders with their final app bars, tested |
| CI | Phase 8 | Phase 8 | Phase 1 |
| Accessibility checks | — | — | a test tour of every screen from Phase 1 |

The Android spec has a drawer but doesn't name its tabs; the iOS spec names five tabs but has no drawer. The Flutter edition takes both: iOS's tabs in a Material bar, and Android's drawer for the screens that don't fit in it.

---

## 🎤 Interview Notes

**Q: How does a link to `/events/e1/rsvp` know to show the event underneath?**
A: RSVP is declared as a *child* route of `/events/:eventId`. go_router builds the whole matched chain as pages, so the event's page is under the dialog. Close pops to it; with nothing underneath (a top-level route opened cold) the Close button `go`es to a sensible home instead.

**Q: Why is Settings not a tab?**
A: The five tabs are what people use every day: discovering, searching, saved events, tickets, the profile. Settings is reached from the drawer and from Profile, pushed above the tabs, as the iOS spec suggests for its secondary screens.

**Q: Why no images for event banners?**
A: Offline-first is the point of the app, and network images need a cache and placeholders to work offline. A banner made of the category's color and icon works everywhere, costs nothing, and keeps the UI simple. The API's URLs can drive images later without changing the domain.

**Q: How does the app decide between Welcome and Discover?**
A: The router does, with a pure function of two inputs, re-run whenever the onboarding flag changes. Welcome only records the choice; it never navigates.

---

## 📝 Learning Checklist

- ✅ Pin Flutter per project with FVM, and gate every commit with CI
- ✅ Build Material 3 themes from a seed, ready for any `ColorScheme`
- ✅ Add app-specific colors with a `ThemeExtension`, and a seed-derived palette, contrast-tested
- ✅ Declare typed routes, a tab shell, child routes, and full-screen dialogs above it
- ✅ Combine a bottom bar with a navigation drawer over nested Scaffolds
- ✅ Gate the app with a pure redirect and a `refreshListenable`
- ✅ Check accessibility guidelines in widget tests
- ⬜ The models with time zones, the drift cache, the fake API and Welcome for real (Phase 2)

---

## 🚀 Future Improvements

- **Phase 2:** the domain models (events as instants with a time zone, locations, ticket offers, tickets, sessions, organizers, the profile), the drift cache with separate catalog and user tables, the in-memory fake API seeded from JSON, a real Welcome (preferred city, fetch, error, Try again), and the saved first-launch flag.
- **Phase 3:** Discover and Event detail.
- **Later:** a `NavigationRail` instead of the drawer on tablets and in landscape.
