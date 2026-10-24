# Phase 7 — Notifications + Background

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 7, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 7 makes Evently speak up when the user isn't looking:
- **reminders** a lead time before events you're going to (or saved with the reminder on), a **daily summary** of the day's events, an **RSVP confirmation**, and **change alerts** when an event you hold a ticket for moves or is cancelled;
- all of them **planned as data and applied as a diff** (the Momentum pattern);
- a **background sync** (`workmanager`) that refreshes the catalog, records what changed **once**, alerts **once**, and plans again, in a background isolate with its own small DI graph;
- the notification settings, the reminder toggle on Event detail, and developer tools to run the sync now and see the plan.

---

## 🧱 What Was Implemented

- **Settings:** `AppSettings` gains `notificationsEnabled` (off until the user turns it on), `reminderLead` (15 min, 1 h, 3 h, 1 day; default 1 h), `summaryEnabled` (on) and `summaryTime` (08:00). Saved under their own keys; an unreadable value falls back to the default. `SettingsRepository.reload()` reads what another isolate saved.
- **The reminder toggle** (`event_reminders`, Phase 2's table):
  - a LEFT JOIN into every event card (`EventCardItem.reminderChoice`);
  - `hasReminder`: your choice, or by default **on when you're going** and off for a saved event;
  - on Event detail for an event you're going to or saved that is still ahead and on; disabled with the reason while notifications are off.
- **The planner** (`planNotifications(now, items, settings, userZone, horizon: 7 days)`, pure):
  - a reminder `reminderLead` before each event with one, none for cancelled events;
  - the summary at the summary time (the user's clock) on each day with events you're going to that haven't ended by then: "Today" / "Flutter London: State of Flutter at 18:30, and 1 more";
  - past times and times beyond the horizon dropped; soonest first; at most 60 (iOS keeps 64);
  - **stable ids** (FNV-1a of kind and event or day), and the ring time kept in the payload, so a moved reminder is rescheduled.
- **Shown at once, never planned:** the RSVP confirmation ("You're going to …", the day, the type and the code) and the change alerts ("… has moved" with the old and new times; "… is cancelled").
- **`SyncNotificationsUseCase`:** plan → compare with what's pending → cancel the stale, schedule the new or changed, leave the rest. Off (or permission revoked) cancels everything; a revoked permission also turns the switch off. Calls queue, one at a time.
- **`KeepNotificationsInSyncUseCase`:** while the app runs, syncs after every change to the remindable events or the settings, debounced with `settled` (§11.63); again on every resume, after reloading the settings.
- **Change detection** (`diffCatalog`, pure, in the domain), inside the refresh's **one transaction**:
  - read the cache's start and status per event, upsert the catalog, mark events gone from the server **cancelled** (never deleted);
  - compare: **moved** (the start instant changed), **cancelled** (on before, off now; cancelled wins over moved), **added**;
  - record the moves and cancellations of events with an **active ticket** in `event_changes`.
  - Once per change: the next refresh compares against a cache that already has it.
- **Alerts once** (`AlertCatalogChangesUseCase`): the unalerted changes are **claimed** (marked `seen`) in one transaction, then shown. Two isolates can't both claim one. With notifications off they're claimed all the same, so turning them on later brings no stale news. Every successful refresh (pull to refresh too) alerts what it recorded.
- **`LocalNotifications`** (`flutter_local_notifications`), behind `NotificationScheduler` and `NotificationInteractions`:
  - three Android channels: Event reminders, Daily summary, Bookings and changes;
  - inexact scheduling at UTC instants;
  - permission asked only when the user turns notifications on; the system settings opened from the denied card.
- **Taps:** a reminder opens the event, the summary opens Tickets, a confirmation or change alert opens the ticket. A cold start reads the launch tap before `runApp` (`EventlyApp.locationFor`); a warm tap pushes the screen (Back returns).
- **Background** (`workmanager`):
  - `WorkmanagerBackgroundWork` registers a periodic task about every 6 hours (Android: network connected, battery not low; iOS: a `BGAppRefreshTask`, identifier `co.bitfuse.flutter.evently.sync`, permitted in `Info.plist` and registered in `AppDelegate`);
  - `callbackDispatcher` → `dispatchBackgroundTask` → `BackgroundGraph.open()`: the database (`shareAcrossIsolates`), preferences, the time zone, the fake API, and the same use cases, built by hand;
  - `RunBackgroundSyncUseCase`: refresh → alert → re-plan, each step whatever the others did.
- **Settings:** a Notifications section (master switch, denied card, lead time dialog, daily summary switch and time, Material clock on Android and a wheel on iOS). Developer gains **Run background sync now** and **Show planned notifications** (a sheet with the plan).
- **Platform setup:** Android `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, the plugin's receivers, core library desugaring and an `ic_notification` icon; iOS `UIBackgroundModes` (fetch), `BGTaskSchedulerPermittedIdentifiers`, the notification center delegate and plugin registrants for background engines.
- **The fake server's calendar** (`DemoCalendar`): the seed counts from an anchor (its first fetch, kept in preferences so both isolates share it), not from today; Reset demo data starts it again from now.
- **Tests:** 891 (129 new); 37 more mutation checks.

### Differences from the plan

- **The fake server counts from a fixed day.** Found on the simulator: the seed said "in 3 days" from *today*, so a refresh on a new day moved every event, and change detection would have alerted every ticket as moved. Tests never saw it (their clock is fixed). Now the seed renders from an anchor saved at the first fetch; the demo ages like real data until Reset demo data restarts it (conventions §11.83).
- **The background isolate's fake server is a fresh one.** The fake keeps its state in memory, so the background isolate's server hasn't seen the app's bookings or a published update, as after a restart. A real backend is one server for both. Settings → Developer → Run background sync now runs the same sync in the app's isolate, against the app's server.
- **No midnight tick.** Momentum re-plans at midnight; here the seven-day window rolls on at every launch, resume and background sync, days before its end matters.
- **Notification text is built in the domain.** The sync compares titles and bodies with what's pending, and the background isolate has no widgets. Times follow the screens' rule (venue's clock for in-person, yours for online, the zone's abbreviation when it isn't yours), in 24-hour time.
- **A saved event's reminder is off by default.** A save is "maybe"; a ticket is "going".
- **Inexact alarms on Android.** Exact alarms need a permission that's denied by default from Android 14. The cost is real: the emulator gave a reminder set hours ahead a one-hour delivery window (§11.82). Exact alarms where granted are on the roadmap.

---

## 💙 Flutter / Dart Concepts Demonstrated

- **Planned as data, applied as a diff:** a pure function makes the plan; a use case compares it with `pendingNotificationRequests()` by id, title, body and payload, and touches only what differs.
- **Change detection in one transaction:** `transaction(() { read; upsert; mark gone; diff; record })` on a DAO; nested calls join it. The comparison and the write can't be split by a crash or by the other isolate.
- **Claiming work across isolates:** select the unalerted rows and mark them in one transaction; through `shareAcrossIsolates` both isolates talk to one drift server, so only one gets each row.
- **Background isolates need their own graph:** `@pragma('vm:entry-point')` keeps the dispatcher through tree shaking; `getIt` is empty there, so the graph is built from the same classes by hand.
- **Per-isolate preferences:** `SharedPreferencesWithCache.reloadCache()` on resume; only changed keys written (§11.64).
- **A debounce that cancels:** `settled()` instead of `stream_transform`'s `debounce`, whose timer outlives a cancel (§11.63).
- **Cold vs warm notification taps:** `getNotificationAppLaunchDetails()` before `runApp` becomes `initialLocation`; `onDidReceiveNotificationResponse` pushes while running.
- **`AppLifecycleListener`:** `onResume` to reload settings and re-plan. In tests, every intermediate state must be reported in order.
- **Adaptive pickers:** `showTimePicker` on Android, a `CupertinoDatePicker` sheet on iOS.

---

## 🔁 Data Flow (this phase)

```
Any change (ticket, save, reminder toggle, refresh, settings) or resume
   └─▶ KeepNotificationsInSync (settled 300 ms) ─▶ SyncNotifications (queued)
         permission? ─ no ─▶ switch off, cancelAll
         plan = planNotifications(now, remindable events, settings, user zone)
         pending ─▶ cancel stale · schedule new/changed · keep the rest

RSVP ─▶ server confirms ─▶ ticket + counts (one transaction) ─▶ RSVP confirmation (if on)

Refresh (pull, Developer, background) ─▶ fetch ─▶ transaction {
      before = versions; upsert; cancelMissing; diffCatalog(before, after);
      record moved/cancelled for active tickets in event_changes }
   └─▶ AlertCatalogChanges: claim unalerted (mark seen, one transaction) ─▶ show (if on)

workmanager (≈6 h; Android: network, battery) ─▶ callbackDispatcher ─▶ BackgroundGraph.open()
   └─▶ RunBackgroundSync: refresh ─▶ alert ─▶ re-plan ─▶ close

Tap ─▶ reminder: Event · summary: Tickets · confirmation/change: Ticket   (cold: initialLocation; warm: push)
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `lib/domain/calculation/{notification_plan,catalog_diff}.dart` | The planner, the shown-at-once texts, stable ids; change detection. |
| `lib/domain/model/{planned_notification,event_change}.dart` | Planned, instant and pending notifications, targets, reports; a recorded change. |
| `lib/domain/service/{notification_scheduler,background_work}.dart` | The platform interfaces. |
| `lib/domain/usecase/{notification,background}_use_cases.dart` | Sync, keep in sync, switch, lead, summary, reminder toggle, confirmation, alerts, preview; the background sync. |
| `lib/domain/repository/reminder_repository.dart`, `lib/data/repository/reminder_repository_impl.dart` | Remindable events, toggles, claimed changes. |
| `lib/core/database/daos/reminders_dao.dart`, `catalog_dao.dart` (versions, `cancelMissing`) | Toggle rows, change records and claims; change detection's reads. |
| `lib/core/platform/{local_notifications,workmanager_background_work,device_time_zone_reader}.dart` | The plugins. |
| `lib/background/{background_entry,background_graph}.dart` | The OS's entry point and its hand-built graph. |
| `lib/core/common/settled_stream.dart` | A debounce that cancels its timer. |
| `lib/core/network/demo_calendar.dart` | The fake server's fixed calendar, shared by both isolates. |
| `lib/core/design_system/widgets/{reminder_toggle,time_picker}.dart` | The toggle; the adaptive time picker. |
| `lib/features/settings/widgets/planned_notifications_sheet.dart` | The plan, for the developer. |
| `android/…/AndroidManifest.xml`, `build.gradle.kts`, `drawable/ic_notification.xml`; `ios/Runner/{AppDelegate.swift,Info.plist}` | Platform setup. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `ReminderLead`, `AppSettings` (+ notifications) | enum / freezed | The notification settings | `domain/model` |
| `PlannedNotification`, `InstantNotification`, `PendingNotification`, `NotificationTarget` | freezed | What the device should hold, show, holds; where a tap leads | `domain/model` |
| `NotificationSyncReport`, `NotificationPlanPreview`, `BackgroundSyncReport` | value classes | What a sync did; the plan for the developer | `domain` |
| `EventVersion`, `CatalogDiff`, `EventChange` | record / freezed | Change detection and a recorded change | `domain` |
| `NotificationScheduler`, `NotificationInteractions`, `BackgroundWork` | interfaces | The device's notifications, taps, the OS scheduler | `domain/service`; impls in `core/platform` |
| `ReminderRepository` | interface (+ impl) | Remindable events, toggles, claims | contract in `domain`, impl in `data` |
| `RemindersDao` | drift accessor | Toggle rows; record and claim changes | `core/database/daos` |
| `SyncNotificationsUseCase` | lazy singleton | Plan → diff → apply, queued | one queue for the app |
| `BackgroundGraph` | final class | The background isolate's graph | `lib/background` |
| `DemoCalendar` | interface (+ stored impl) | The day the fake server counts from | `core/network`: part of the fake |
| `ReminderToggle` | widget | The per-event switch with its reason | `core/design_system/widgets` |

---

## 🧪 Tests (891; 129 new)

| Area | New | What they pin |
|------|----:|---------------|
| Planner | 22 | Lead times; going on by default, saved off, choices; cancelled, past and beyond-horizon dropped; a moved event at its new time; venue vs your clock and the zone's abbreviation; the summary's day, time (both sides of the clock change), "and N more", events over by then, only going; the cap and order; stable ids and payloads; confirmation and alert texts; targets round-trip |
| Change detection | 21 | `diffCatalog` (moved, the same instant in another zone, cancelled, cancelled wins, cancelled once, moved again, back on, added); only ticketed recorded; a published update recorded once; a cancelled ticket ignored; a vanished event kept as cancelled; a failed refresh records nothing; a refresh the next day moves nothing; Reset demo data restarts the calendar with no change left; claims once, two claims share; the toggle joined into cards; remindable events |
| Use cases | 24 | Sync (schedule the plan, keep, cancel a toggled reminder, a new lead time, stale, off, revoked, queued); the switch (asked, denied, off); alerts once, claimed while off, after a refresh; the RSVP confirmation (shown, not when off or failed, a broken device doesn't fail the booking); the background sync (all three steps, offline still alerts and plans, a cancelled event's reminder and summary gone); keep in sync; preview |
| Background | 5 | Dispatch: the sync task, iOS's task, an unknown task, a failure still closes, a graph that won't open |
| Settings | 21 | Saved keys, defaults, fallbacks, reload; Cubits (lead, summary, allowed, denied and the card, run sync now messages, preview); the view (section, switch, denied card, waiting switch, lead dialog, summary switch and time on Android and iOS, the sheet with and without a plan) |
| Event detail | 10 | The toggle's states, reason, absence (one state per test, §11.73); the Cubit following settings and saving a choice |
| Flows | 10 | Turn on → scheduled; denied → card → system settings; a saved event's reminder; RSVP → confirmation; update → sync now → alerted once → the ticket; warm taps (event, Tickets); a cold start on a ticket; locations; a revoked permission on resume |
| Accessibility tour | 10 | Settings with notifications on, denied, the lead time dialog, the plan sheet, an event with its reminder on; both themes at 200 % |
| Other | 6 | `settled()` (quiet, done, cancel); the calendar anchor (kept, shared with another isolate, restarted); the DI graph's notification roles |

**Mutation checks (37), each caught:**
- the planner: cancelled events planned, no reminder check, no lead time, past times kept, no horizon, no cap, latest first;
- the summary: saved events in it, events already over, the venue's day instead of the user's, "and N more" off by one;
- the reminder default: on for saved events, or for events neither saved nor booked;
- the diff: no cancellations, cancelled twice, the same instant as a move, untracked events recorded;
- the sync: gone events not cancelled, cancelled tickets counted, changes never marked alerted, saved events not remindable;
- plan → diff → apply: a revoked permission kept on, nothing cancelled when off, unchanged rescheduled, stale kept, two syncs interleaved;
- alerts shown while off; a refresh not alerting; no RSVP confirmation; no sync on resume;
- the background: the graph not closed, iOS's task ignored;
- the toggle enabled while off, or shown after the start (caught once the test was split, §11.73);
- the server counting from today; Reset demo data not restarting the calendar; the anchor not kept.

### Checked on devices

- **iOS simulator** (iPhone 17 Pro, in Lahore's zone), dark and light:
  - the permission prompt (the switch waits while it's up);
  - the section with its lead time dialog and the summary's wheel (7:00 saved);
  - the plan sheet;
  - Publish + Run background sync now: two change alerts, the move with "(was …)";
  - from the notification center, the move alert opens its ticket ("Moved", Back returns);
  - a saved event's reminder turned on ("1 hour before it starts").
- **Android emulator** (Pixel 10 Pro, API 36):
  - Don't allow → the denied card → Open settings reaches Evently's notification page; asked again → Allow;
  - the plan, and the reminder in `dumpsys alarm` (`ScheduledNotificationReceiver`, an hour before the event);
  - two alerts in the "Bookings and changes" channel;
  - the **real WorkManager job**: `BackgroundWorker` → `SUCCESS` in its own isolate while the app was open. It posted the move alert (its fresh server had the conference at its original day, the same calendar);
  - a **cold start** from that alert (process killed) opened the ticket with Close.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Notifications | `EventReminderScheduler` → WorkManager → NotificationManager, channels | `NotificationScheduler` protocol + UserNotifications | `NotificationScheduler` / `NotificationInteractions` + `flutter_local_notifications`, three channels |
| What's notified | reminder, RSVP confirmation, daily summary | the same | the same, plus **change alerts** for moved and cancelled events you hold tickets for |
| How reminders are kept right | schedule / cancel per event (use cases) | the same | **planned as data and diffed** after every change, on resume and in the background |
| Background | WorkManager (one-time + periodic, constraints): reminders, summary, fake sync | `BackgroundTaskCoordinator` + BGTaskScheduler: event sync, reminders | `workmanager` on both: a periodic sync (refresh, record changes, alert, re-plan) in a background isolate with its own graph |
| Change detection | — | — | `diffCatalog` in the domain, inside the refresh's transaction; recorded once, alerted once |
| Settings | notification toggle, reminder time | notifications toggle, reminder time | master switch with the permission flow, lead time, daily summary and its time |
| Per-event reminder | `ReminderToggle` | `ReminderToggle` | `ReminderToggle`: on by default when going, off for saved; disabled with the reason while notifications are off |

Both native specs schedule reminders one event at a time. The Flutter edition plans the whole week from the data and applies the difference, so a moved event, a cancelled ticket or a new lead time can't leave a stale reminder behind.

---

## 🎤 Interview Notes

**Q: Why plan notifications as data instead of scheduling them when things happen?**
A: Every event changes the set: a booking, a cancel, a toggle, a moved event, a new lead time, a permission revoked. Scheduling at each place means each must remember to cancel the right ids. A pure planner says what should exist now; the sync compares it with what's pending and fixes the difference. It's testable without a device, and the background isolate runs the same code.

**Q: How is a change alerted exactly once?**
A: Twice "once". Recording: the refresh compares the cache with the new catalog in the same transaction that writes it, so the next refresh sees the change already applied and records nothing. Alerting: the unalerted records are claimed (marked seen) in one transaction before they're shown, and both isolates go through one drift server, so only one can claim each.

**Q: Why does the background isolate build its own DI graph?**
A: An isolate shares no memory: the app's `getIt` doesn't exist there, and the app may not be running. The whole app graph would also be wasted work in a job with seconds to run. So `BackgroundGraph` builds the few objects the sync needs, from the same classes.

**Q: What happens if the user revokes notification permission in system settings?**
A: The next sync (on resume, or in the background) finds the permission gone, turns the switch off and cancels everything pending. The switch never reads "on" while nothing can ring.

**Q: Why record changes only for events with a ticket?**
A: A ticket is a commitment; a moved event you hold one for changes your evening. A saved event's card shows "Moved" anyway; alerting for every save would be noise.

---

## 📝 Learning Checklist

- ✅ Plan notifications as data and apply them as a diff
- ✅ Detect server changes in the domain, inside the write's transaction
- ✅ Alert once across two isolates by claiming rows
- ✅ Run use cases in a background isolate with a hand-built graph
- ✅ Route notification taps on a cold and a warm start
- ✅ Ask for permission at the moment it makes sense, and handle "denied"
- ⬜ Documentation and CI (Phase 8)

---

## 🚀 Future Improvements

- **Phase 8:** the final README and `docs/` (NOTIFICATIONS, BACKGROUND_WORK among them), CI, and a final mutation pass.
- **Later:** exact alarms where the user grants them (`SCHEDULE_EXACT_ALARM`); notification actions ("Get directions", "Cancel RSVP"); a server push instead of polling for changes; one fake server shared by both isolates (a small local server, or its state persisted) so the background sync sees published updates too.
