# Notifications

Evently sends four kinds of notification:

| Kind | When | Tap opens | How |
|---|---|---|---|
| **Reminder** | a lead time (15 min, 1 h, 3 h, 1 day) before an event you're going to, or saved with the reminder on | the event | planned |
| **Daily summary** | at the summary time (08:00 by default) on days with events you're going to: "Today" / "Flutter London: State of Flutter at 18:30, and 1 more" | Tickets | planned |
| **RSVP confirmation** | right after the server confirms a booking: "You're going to Late Jazz at the Vaults" | the ticket | shown at once |
| **Change alert** | when a sync finds that an event you hold a ticket for moved ("… has moved. Now Sun 8 Nov at 09:00 CET (was Sat 7 Nov at 09:00 CET)") or was cancelled | the ticket | shown at once |

All of them need the master switch on **and** the system's permission.

## Planned as data, applied as a diff

The reminders and summaries are not scheduled at the moment something happens. A pure function says what should be on the device now, and a use case makes the device match:

```
tickets, saves, reminder choices, the catalog, settings, the clock
        │
        ▼
planNotifications(now, items, settings, userZone)   ── pure, domain/calculation
        │  List<PlannedNotification>
        ▼
SyncNotificationsUseCase ── compares with pendingNotificationRequests()
        ├─ cancel what's no longer wanted
        ├─ schedule what's new or changed (same id: replaced)
        └─ leave the rest
```

Why: many things change what should ring: a booking, a cancellation, a save, a toggle, a moved or cancelled event, a new lead time, a summary time, a revoked permission, the week rolling on. Scheduling at each of those places means each must remember which ids to cancel. Planning makes the rule one function, tested without a device; the diff touches only what changed (correctness rule 10).

## The planner (`planNotifications`)

From the events you're going to or saved (`ReminderRepository.watchRemindable`), the settings and the user's zone:

- **A reminder** `reminderLead` before each event with one:
  - `hasReminder` is your choice on the event's toggle, or by default **on when you're going** and **off for a saved event** (a save is "maybe");
  - none for a cancelled event; a moved event is reminded at its new time.
- **The daily summary** at the summary time on each of your days with events you're going to that haven't ended by then. The first event (soonest), then "and N more". None on a day with nothing, and none when the summary is off.
- **A seven-day window:** times already past, or beyond seven days, are dropped. The plan rolls forward at every launch, resume and background sync.
- **At most 60,** soonest first: iOS keeps only the 64 soonest pending notifications per app and silently drops the rest.

### Ids

`notificationId(kind, key)` is the 32-bit FNV-1a hash of the kind and its key (the event's id for a reminder, the day for a summary, the ticket's id for a confirmation, the change record's id for an alert), kept positive for Android. **Stable:** the same reminder has the same id in every plan, so an unchanged one is recognised and left alone, and a moved event's reminder replaces itself.

### The payload

`pendingNotificationRequests()` gives back an id, a title, a body and a payload, but not the time. So the payload carries the target and the ring time (`event:ev_1#2026-10-24T16:30:00.000Z`). A reminder whose event moved has the same id but a different payload, and the sync schedules it again. A tap reads only the target part.

### Words

A notification's text is part of the plan, because the sync compares it with what's pending, and the background isolate has no widgets to format with. So the planner writes it in the domain (the one exception to "formatting lives in the design system"). Times follow the screens' rule: an in-person event on its venue's clock, an online one on the user's, 24-hour, with the zone's abbreviation when it isn't the user's ("Starts in 1 hour, at 23:30 EDT · Recurse Space", for New York's Midnight Code Jam on a phone in London). See [TIME_ZONES.md](TIME_ZONES.md).

## The sync (`SyncNotificationsUseCase`)

1. **Permission first:** if notifications are on but the system no longer allows them (revoked in the system settings), turn the switch **off** and cancel everything. The switch never reads "on" while nothing can ring (rule 11).
2. **Off:** cancel whatever is pending.
3. **On:** plan, then cancel the stale, schedule the new or changed, keep the rest. It reports what it did (`NotificationSyncReport`).

**One at a time:** calls queue up (a singleton holds the queue), so two syncs never interleave their cancels and schedules.

### When it runs

- **While the app runs:** `KeepNotificationsInSyncUseCase` watches the remindable events and the settings and syncs after every change, debounced (`settled`, 300 ms; a timer that's cancelled with the subscription, §11.63), so a refresh or the demo syncs once.
- **On resume:** after reloading the settings (the background isolate may have turned the switch off).
- **In the background:** the last step of `RunBackgroundSync`. See [BACKGROUND_WORK.md](BACKGROUND_WORK.md).
- **From Settings → Developer → Run background sync now.**

## Shown at once

- **The RSVP confirmation** (`ShowRsvpConfirmationUseCase`) runs after the server confirms a booking, when notifications are on and allowed. It never fails the booking: if it can't be shown, that's logged.
- **Change alerts** (`AlertCatalogChangesUseCase`):
  - a refresh records the moves and cancellations of events you hold a ticket for, inside its transaction, once per change (rule 9);
  - the alert step **claims** the records not yet alerted (marks them `seen` in one transaction), then shows them. The app and the background isolate share one drift server, so only one of them can claim each change;
  - with notifications off, the records are claimed all the same, so turning notifications on later brings no stale news;
  - every successful refresh alerts what it recorded: a pull to refresh doesn't leave the news for the next background sync.

Shown notifications aren't pending, so no sync ever cancels them.

## The platform side (`LocalNotifications`)

`flutter_local_notifications`, behind two interfaces: `NotificationScheduler` (permission, pending, schedule, show, cancel, the system settings) and `NotificationInteractions` (the launch tap, taps while running). One wrapper serves both roles in the app; the background graph builds its own.

- **Instants:** each planned notification is scheduled at its UTC instant (`zonedSchedule` with `TZDateTime` in UTC). A reminder an hour before an event rings an hour before it wherever the phone is.
- **Three Android channels:** "Event reminders" (high importance), "Daily summary", "Bookings and changes" (high). The user can silence the summary and keep the reminders.
- **Inexact on Android:** exact alarms need a permission that's denied by default from Android 14. Android then picks a delivery window: the emulator gave a reminder set hours ahead a one-hour window (`dumpsys alarm`, conventions §11.82). Exact alarms where granted are on the [roadmap](ROADMAP.md).
- **Survives a reboot** through the plugin's boot receiver (in the manifest), and app updates.
- **The icon** `ic_notification` is a white vector drawable, kept from resource shrinking by `res/raw/keep.xml`. Without it, a release build can't initialize the plugin (§11.85).
- **iOS:** the notification center's delegate is set in `AppDelegate`, so notifications show while the app is in the foreground and taps reach it.

## Permission

- **Asked when the user turns notifications on,** never at launch, so the prompt has a reason: Android 13+ shows its dialog (at most twice), and iOS its alert.
- **Denied:** the switch stays off, and a card explains, with **Open settings** (the app's notification page in the system settings). Once denied, only the system settings can change it.
- **Revoked later:** the next sync (resume, background) turns the switch off.
- **Granted, then closing the dialog resumes the app:** the reload on resume waits for the switch's own write, so the switch can't flip back (§11.84, found on the emulator).

## Taps

| Target | Payload | Cold start (the app was killed) | Warm (the app runs) |
|---|---|---|---|
| An event | `event:<id>` | `getNotificationAppLaunchDetails()` before `runApp` → the event as the initial location (with Close) | pushed; Back returns |
| A ticket | `ticket:<id>` | the ticket | pushed |
| Tickets | `tickets` | Tickets | switches to Tickets |

A payload that isn't the app's (an older format, none) is ignored. Reading the launch tap is guarded: if the plugin fails there, the app starts normally.

## The reminder toggle and the settings

- **Event detail's "Remind me"** (`ReminderToggle`, an adaptive switch) shows for an event you're going to or saved that is still ahead and on. It says when ("1 hour before it starts"), or why it can't ring ("Notifications are off. Turn them on in Settings.") and is disabled.
- **Settings → Notifications:** the master switch (the permission flow, the denied card), the reminder lead time (a dialog of four), the daily summary on or off, and its time (Material's clock on Android, a wheel on iOS).
- **Settings → Developer:** Run background sync now; Show planned notifications (the plan for the next seven days, and how many are pending on the device).

## Testing

- **The planner** (pure): every lead time; going on by default, saved off, choices either way; cancelled, past and beyond-horizon dropped; a moved event at its new time; venue vs user clock and the abbreviation; the summary's day, time (both sides of London's clock change, a New York user's day), "and N more", events over by then; the cap and the order; stable ids and payloads; the confirmation and alert texts; targets round-trip.
- **The sync** against `FakeNotificationScheduler` on the real data stack: the plan scheduled; nothing changed, no calls; a toggled reminder cancelled; a new lead time rescheduled (and one now past dropped); a stale id cancelled; off cancels; a revoked permission turns the switch off; two syncs queue.
- **Alerts:** once each, claimed while off, alerted after a refresh; two claims at once share the changes.
- **Flows:** turn on → scheduled; denied → card → system settings; a reminder from an event's page; RSVP → confirmation; publish → sync now → alerted once → the alert opens the ticket; warm taps; a cold start on a ticket; a permission revoked while away.
- **On devices:** the iOS simulator and an Android emulator (permission prompts, the shade, a reminder in `dumpsys alarm`, the real background worker posting an alert, a cold start from a notification, a release build).
