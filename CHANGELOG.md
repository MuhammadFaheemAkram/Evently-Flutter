# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project follows [Conventional Commits](https://www.conventionalcommits.org/).

## [Unreleased]

_All eight build phases are complete. See [`docs/ROADMAP.md`](docs/ROADMAP.md) for what's next._

### Fixed
- **The Close fallback** asked `Navigator.canPop()`, which answers for the whole stack. An event opened by a link and booked from (it changes to "You're going" while the ticket covers it) lost Close, and after Back from the ticket had no way out. It now asks its own route (`ModalRoute.impliesAppBarDismissal`, as the `AppBar` does). Tested on the helper and by that booking flow.

## [0.8.0] — 2026-10-26 — Phase 8: Documentation & CI

### Added
- **Docs:** ARCHITECTURE, DATA_MODEL, OFFLINE_FIRST, TIME_ZONES (worked examples across zones and clock changes), NOTIFICATIONS, BACKGROUND_WORK, API_SIMULATION, TESTING (tests per area and all 175 mutation checks), LEARNING_NOTES, INTERVIEW_NOTES, ROADMAP, and SCREENSHOTS (24: light, dark, large text, Android dynamic color and notifications); the Phase 8 summary.
- **Open-source files:** CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, this CHANGELOG, and the GitHub issue and PR templates.
- **Mutation checks** of 21 key behaviours against the whole suite (every correctness rule, and this phase's fixes), each caught; the one missed at first (a booking answer for another event) got its test.
- "Folder Structure Changes" in the Phase 2–7 summaries.

### Fixed
- **A release build stuck on its launch screen:** resource shrinking removed the notification icon (named only from Dart), so the plugin failed before `runApp`. The icon is kept (`res/raw/keep.xml`), and reading the launch notification can no longer stop the app from starting.
- **On Android, turning notifications on could leave the switch off:** closing the permission dialog resumes the app, and the settings reload could overtake the switch's own write (DataStore keeps no order between them). A reload now waits for this isolate's writes and keeps a change made while it read.
- **The fake server's calendar anchor is read once per isolate,** so a preferences reload (which empties the cache for a moment) can't start a new calendar.

### Changed
- Comments no longer say which phase something arrived in.
- The README is final: features, screenshots, a short test summary linking to TESTING, and every doc.

## [0.7.0] — 2026-10-25 — Phase 7: Notifications + Background

### Added
- **The notification planner:** reminders a lead time (15 min to 1 day) before events you're going to (or saved with the reminder on), a daily summary, over seven days, at most 60, with stable ids and the time in the payload.
- **`SyncNotificationsUseCase`:** plan → compare with what's pending → cancel stale, schedule new or changed; after every change, on resume and in the background; a revoked permission turns notifications off.
- **The RSVP confirmation and change alerts,** shown at once; taps open the event, Tickets or the ticket, on a cold and a warm start.
- **Change detection** (`diffCatalog`) inside the refresh's transaction: moves and cancellations of ticketed events recorded once, claimed once across isolates, alerted once; an event gone from the server is marked cancelled.
- **The reminder toggle** on Event detail and the notification settings (the permission flow with a denied card, the lead time, the daily summary and its time).
- **Background sync** with `workmanager` in its own isolate and hand-built graph: refresh, alert, re-plan. Developer tools: run it now, show the plan.
- 129 tests (891 in total); 37 mutation checks.

### Fixed
- **Events moved a day every day:** the fake server rendered its seed from today, so change detection would have alerted every ticket. It now renders from a stored calendar anchor that Reset demo data restarts (found on the simulator).

## [0.6.0] — 2026-10-25 — Phase 6: Organizers + Profile + Settings

### Added
- **Organizers** with Follow, and **Following** with each one's next event; the **profile** with live counts, and **Edit profile** with validation and a discard guard.
- **Settings:** System / Light / Dark app-wide, dynamic color on Android 12+, the preferred city, **Clear cache** (keeping everything the user owns), **Reset demo data**, developer tools (simulate failure, **publish a catalog update**), About.
- 96 tests (762 in total); 26 mutation checks.

### Changed
- Event cards say "Moved" and "Cancelled"; Following's next event skips cancelled ones (both found on the simulator).

## [0.5.0] — 2026-10-24 — Phase 5: RSVP, Tickets + Agenda

### Added
- **RSVP confirmed by the server:** a ticket type, a note, the total; the ticket and the event's counts written in one transaction; sold out, closed and offline fail cleanly, writing nothing.
- **Tickets** with QR codes (Luhn mod N check characters), upcoming and past, cancel before the start; **the agenda** by the venue's days, bookmarks, and clashes.
- 120 tests (666 in total); 24 mutation checks.

### Fixed
- The ticket code's check character missed some typos (a weighted sum mod 32); it is now Luhn mod N, and the demo's codes were recomputed.

## [0.4.0] — 2026-10-24 — Phase 4: Search + Saved

### Added
- **Search** over the cache: text plus categories, dates (presets and custom), price, format and your RSVP, one drift query with `LIKE` escaped; debounced and restartable in `SearchBloc`; recent searches.
- **Saved,** coming up and past, with swipe to remove and Undo.
- 90 tests (546 in total); 21 mutation checks.

## [0.3.0] — 2026-10-24 — Phase 3: Discover + Event detail

### Added
- **Discover:** featured, in your city, coming up by day (the user's days), categories, pull to refresh, save and RSVP from a card.
- **Event detail:** the venue's time with "Your time", the place with directions or the join link, attendance, prices, the agenda preview, the organizer.
- 144 tests (456 in total); 21 mutation checks.

### Changed
- Online events are told on the user's clock (found on the simulator).

## [0.2.0] — 2026-10-24 — Phase 2: Data layer

### Added
- **Models with time zones** (`EventTime`: two instants and a zone), the drift cache (catalog and user tables, `CHECK`s, a partial unique index, no cascades from the user's rows), the fake API rendering its seed, **Welcome** with the demo or a fresh start.
- 190 tests (312 in total); 25 mutation checks.

## [0.1.0] — 2026-10-24 — Phase 1: Foundation

### Added
- The FVM-pinned project, the design system with the category palette, typed routes with a first-launch gate, five tabs with a navigation drawer, the accessibility tour, CI.
- 122 tests.
