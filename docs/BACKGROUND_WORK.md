# Background Work

Every few hours, the OS runs Evently's **background sync** while the app is closed, using `workmanager` (WorkManager on Android, BGTaskScheduler on iOS). It keeps the cache, the change alerts and the notification plan current even if the app isn't opened for days.

```
OS (WorkManager / BGTaskScheduler)
  └─▶ callbackDispatcher()                  @pragma('vm:entry-point'), a fresh isolate
        └─▶ dispatchBackgroundTask(task, BackgroundGraph.open)
              ├─ an unknown task (an older version's)? done at once
              └─▶ BackgroundGraph.open(): its own small graph, the same database
                    └─▶ RunBackgroundSyncUseCase
                          1. refresh the catalog   (records moves and cancellations of ticketed events)
                          2. alert the changes     (claimed once, shown if notifications are on)
                          3. re-plan notifications (the 7-day window rolls on; a moved event's reminder moves)
                    └─▶ close: the database connection, the settings
              └─ always "done": a failure is logged, and the next run tries again
```

## What the sync does, and why it isn't time-critical

`RunBackgroundSyncUseCase` runs three steps, each whatever the others did:

1. **Refresh** (`CatalogRepository.refresh`): fetch, check and write the catalog in one transaction, recording changes to events you hold tickets for. Offline, this fails; the other steps still run.
2. **Alert** (`AlertCatalogChangesUseCase`): claim the changes not yet alerted and show them. Changes recorded earlier, by a refresh that couldn't alert, are alerted here.
3. **Re-plan** (`SyncNotificationsUseCase`): the plan for the next seven days, applied as a diff; a revoked permission turns the switch off.

When it runs isn't guaranteed. Android defers work in Doze, to batch it with other apps, and until its constraints hold. iOS runs it when it judges best, and rarely for an app the user seldom opens. Nothing here is urgent: the reminders are already scheduled with the OS, days ahead. The sync only keeps them, and the cache, current.

The same use case runs in the app from **Settings → Developer → Run background sync now**, which reports what it did ("Synced. 2 change alerts. 1 notification planned.").

## The entry point

`lib/background/background_entry.dart`:

- `callbackDispatcher` is a **top-level function marked `@pragma('vm:entry-point')`**. The OS starts it by name from native code, with nothing in the Dart program calling it; without the annotation, a release build's tree shaking would remove it.
- `dispatchBackgroundTask(task, openGraph)` runs the sync for `syncTask` (`co.bitfuse.flutter.evently.sync`) and for iOS's generic `Workmanager.iOSBackgroundTask`; anything else is done at once.
- It **always returns `true`:** a failure is logged and the next run tries again, rather than Android retrying it with backoff. The graph is closed even when the sync throws.
- Taking `openGraph` as a parameter makes the dispatch testable with a graph of fakes.

## Its own small dependency graph

An isolate shares no memory: in the background isolate `getIt` is empty, and the app may not be running at all. Building the whole app graph (screens' Cubits, the router's settings stream, the wallpaper's colors) would be wasted work in a job that has seconds to run. So `BackgroundGraph.open()` builds just what the sync needs, by hand, from the **same classes** the app uses (correctness rule 14):

| Built | From |
|---|---|
| the time-zone database, then `EventClock` with the device's zone | `initializeTimeZones()`, `readDeviceTimeZone()` |
| `AppDatabase()` | the same file, shared |
| `SharedPreferencesWithCache` → `SettingsLocalDataSource` → `SettingsRepositoryImpl` | the same preferences |
| `FakeEventlyApi` with `StoredDemoCalendar` | the same calendar anchor (see below) |
| `CatalogRepositoryImpl`, `ReminderRepositoryImpl` | the DAOs of that database |
| `LocalNotifications` | its own plugin wrapper |
| `AlertCatalogChangesUseCase`, `SyncNotificationsUseCase` → `RunBackgroundSyncUseCase` | |

Anything new the sync needs must be added there too (`getIt` won't provide it).

## The shared database

`AppDatabase` opens with `shareAcrossIsolates: true`. The first isolate to open it starts a **drift server isolate** that owns the only SQLite connection; the other talks to it through a port. So:

- the two isolates' writes never collide, and transactions stay atomic across both;
- a change alert is **claimed** in one transaction, so only one isolate can alert it;
- the app's screens, if open, see the background's refresh at once, through their `watch()` streams.

## Preferences across isolates

Each isolate has its own `SharedPreferencesWithCache`. So:

- **only the keys that changed are written** (§11.64): a background sync that turns the switch off writes that one key, not a stale copy of all of them;
- **the app reloads on resume**, after its own pending writes, and keeps a change it made meanwhile (§11.84);
- **the fake server's calendar anchor** lives there too, read once per isolate.

## The fake server in the background

The fake server keeps its state in memory, so the background isolate's server is a **fresh one**, as if the server had restarted: it hasn't seen the app's bookings or a published catalog update. Its **calendar is shared** (the anchor is in the preferences), so the events are where the app's server has them. A real backend is one server for both; the developer's "Run background sync now" runs against the app's own server. See [API_SIMULATION.md](API_SIMULATION.md).

## Android: WorkManager

`WorkmanagerBackgroundWork.registerSync()` runs at every launch (unawaited, best effort):

- a **periodic task** every 6 hours (WorkManager decides exactly; Doze and App Standby defer it);
- **constraints:** a connected network (the sync fetches) and the battery not low;
- `ExistingPeriodicWorkPolicy.update`: re-registering keeps the existing timing;
- **no initial delay:** the first run comes right after install. That keeps the real worker checkable on a device (§11.66), but on a fresh install it also refreshes beside Welcome's first fetch. In a debug build both took about 18 s on a busy emulator; a release build's background run took about 2 s;
- it survives reboots and app updates.

## iOS: BGTaskScheduler

- `Info.plist` permits the identifier (`BGTaskSchedulerPermittedIdentifiers`: `co.bitfuse.flutter.evently.sync`) and the `fetch` background mode.
- `AppDelegate` registers the task's handler **before launching finishes**, as BGTaskScheduler requires (with UIScene, plugins register later), with 6 hours as the earliest start: `WorkmanagerPlugin.registerPeriodicTask(withIdentifier:earliestBeginInSeconds:)`.
- Background engines need the plugins too: `setPluginRegistrantCallback` for workmanager and flutter_local_notifications.
- iOS decides when (and whether) it runs. The simulator never runs it on its own; Run background sync now exercises the same code.

## Checking it on a device

- **In the app:** Settings → Developer → Publish a catalog update, then Run background sync now: two change alerts, and the plan re-made.
- **The real worker on Android** (debug build): WorkManager won't run periodic work before its period, even when forced (§11.66). To see a first run again, force-stop the app, delete its WorkManager database (`run-as <pkg> rm /data/data/<pkg>/no_backup/androidx.work.workdb*`), and relaunch: the worker runs within seconds (`WM-WorkerWrapper: Worker result SUCCESS … BackgroundWorker`). Checked in Phase 7: after a published update and an in-app sync, the background run (with its fresh server) posted a "moved" alert while the app was open.

## Testing

- **The dispatch** with a graph of fakes: the sync task opens the graph, runs the sync and closes it; iOS's task too; an unknown task is done at once; a failing sync still closes the graph and reports done; a graph that won't open is reported done.
- **The sync** on the real data stack: refresh, alert and re-plan; offline, the changes recorded earlier are still alerted and the plan still rolls on; a cancelled event's reminder and its day's summary go.
- **The real graph** needs the platform (the database file, the plugins), so it's checked on devices.
