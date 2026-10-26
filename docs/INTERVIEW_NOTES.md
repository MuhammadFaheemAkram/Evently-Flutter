# Interview Notes

Questions this app answers well, with short answers that point at the code. Each phase write-up has a few more.

---

## Architecture

**Q: Walk me through the layers.**
A: View → Cubit (or the one Bloc) → use case → repository → drift, with the fake API behind the repositories. `domain/` is pure Dart: models, rules, contracts and use cases. `data/` implements the contracts with drift and the API. Platform services (notifications, background work, links, wallpaper colors) are interfaces in `domain/service`, implemented in `core/platform`. A View never sees `data/`, and a Cubit never sees a plugin. See [ARCHITECTURE.md](ARCHITECTURE.md).

**Q: Why a use case for every action, even thin ones?**
A: They're where rules that aren't SQL live: the RSVP form is checked again against the latest event before the server is asked; a cancellation is refused after the start; a denied permission keeps notifications off. Thin ones (`WatchTickets`) keep the shape uniform, so a Cubit depends only on the domain.

**Q: Why Cubits, and one Bloc?**
A: A screen's state changes on a few intents, and a Cubit says that directly. Search is a stream of keystrokes and filter taps, where event transformers earn their place: one debounce for typing, then `restartable`, so a new query cancels the previous one's live results.

## Offline-first

**Q: What does "offline-first" mean here, exactly?**
A: Every screen reads drift, never the API. Only three things talk to the server: a refresh, a booking and a cancellation. A refresh writes the cache and the screens follow, because they're watching it; a failed refresh keeps the cache and says so. Discover, Search, Saved, Tickets and an event's page all work with no network. See [OFFLINE_FIRST.md](OFFLINE_FIRST.md).

**Q: How do you keep "saved" when a sync rewrites the event?**
A: "Saved" isn't on the event. It's a row in `saved_events`, and the screens LEFT JOIN it when they read. The same goes for going (an active ticket), bookmarked and following. A refresh upserts every column of an event and can't touch any of them.

**Q: Why not `INSERT OR REPLACE` for the upsert?**
A: SQLite implements it as delete-then-insert. The delete would cascade into the event's offers and sessions, or be refused because the user's rows point at the event. `ON CONFLICT DO UPDATE` changes the row in place, with every column written (nulls too) through a companion.

**Q: Why don't the user's tables cascade from events?**
A: A user row should keep its event. With `NO ACTION`, the database refuses to delete an event someone saved or booked, so Clear cache asks what the user owns and deletes only the rest, and a bug that tried more would fail loudly instead of silently losing data.

## Server-confirmed writes

**Q: Why does a booking wait for the server, when a save doesn't?**
A: Only the server knows whether a place is left, so a ticket exists only once it says so. A save is the user's own note and needs no one's permission. So RSVP shows a busy state and can fail cleanly (sold out, offline, closed), writing nothing; saving is instant and works offline.

**Q: Why one transaction for the ticket and the event?**
A: The server's answer carries both the ticket and the event's new places. Written separately, a crash between them would leave a ticket beside a place count that doesn't include it. One transaction lands both or neither. A test makes the event's write fail and checks the ticket goes too.

**Q: How do you stop two active tickets for one event?**
A: A partial unique index, `ON tickets (event_id) WHERE cancelled_at IS NULL`: cancelled tickets stay as history, and only one may be active. The server refuses a second booking too.

## Time

**Q: How do you store an event's time?**
A: As two UTC instants plus the venue's IANA zone. The instants decide everything time-based (started, ended, bookable, the reminder); the zone decides how it's told. A `DateTime` can't hold "18:30 in New York" on a phone in Lahore; `timezone`'s `TZDateTime` can. See [TIME_ZONES.md](TIME_ZONES.md).

**Q: Which clock does a screen show?**
A: An in-person event on its venue's clock (the poster's time), with "Your time" below when the user's clock reads differently. An online event on the user's clock, because they join from where they are. Discover's "Today" and "Tomorrow" are the user's days, so an event at 23:30 in New York is listed under tomorrow in Lahore.

**Q: How did you test daylight saving?**
A: The test clock sits a few days before London's clock change, and the demo straddles both London's and New York's. `EventTime` is tested across both changes and midnight; the seed is rendered as of six instants (both changes included) and must pass every check; the daily summary is tested on both sides of the change.

## Notifications and background work

**Q: How do the reminders stay right when so much can change?**
A: They're planned as data. A pure function, `planNotifications`, says what should be on the device now (a reminder a lead time before each event with one, a daily summary, at most 60 over seven days). `SyncNotificationsUseCase` compares that with what's pending and only cancels or schedules the difference. It runs after any change to the inputs, on resume and in the background, so a moved event's reminder moves and a cancelled one's goes. See [NOTIFICATIONS.md](NOTIFICATIONS.md).

**Q: How does the diff know a reminder changed time? The OS doesn't tell you.**
A: Ids are stable (a hash of the kind and the event), and the payload carries the ring time. A pending notification with the same id but a different payload is scheduled again.

**Q: How is a change alerted exactly once?**
A: Two "once"s. Recording: the refresh compares the cache with the new catalog inside the transaction that writes it, so the next refresh sees the change already applied and records nothing. Alerting: the unalerted records are claimed (marked `seen`) in one transaction before they're shown. Both isolates go through one drift server, so only one can claim each record.

**Q: Why does the background isolate build its own DI graph?**
A: An isolate shares no memory: `getIt` is empty there, and the app may not be running. The full app graph would be wasted work in a job with seconds to run. `BackgroundGraph` builds the few objects the sync needs, from the same classes, on the same database (`shareAcrossIsolates`). See [BACKGROUND_WORK.md](BACKGROUND_WORK.md).

**Q: What happens when the user revokes notification permission in the system settings?**
A: The next sync (resume or background) finds it gone, turns the switch off and cancels everything pending. The switch never reads "on" while nothing can ring.

**Q: Tell me about a bug you only found on a device.**
A: Three of them:
- **The fake server rendered its seed from today,** so every new day moved every event, and change detection would have alerted every ticket as moved. Tests never saw it, because their clock is fixed. Fix: a calendar anchor stored at the first fetch.
- **On Android, turning notifications on sometimes left the switch off.** Closing the permission dialog resumes the app, which reloads the settings. Android's preferences store (DataStore) let that reload's read overtake the switch's write, and the old value came back. It vanished when I added logging, which is what pointed to a race. Fix: reload after the isolate's own writes, and keep a change made during the read. The in-memory test store is too orderly, so the tests use a store whose writes or reads answer late.
- **A release build stuck on its launch screen.** Resource shrinking removed the notification icon, which Dart names only as a string, so the plugin threw before `runApp`. Fix: a `keep.xml`, and a guard so nothing before `runApp` can stop the app.

## Accessibility

**Q: How do you know the app is accessible?**
A: A test tour opens every screen and state in light and dark at 200 % text and runs Flutter's guidelines: tap targets ≥ 48 × 48, every tappable labelled, WCAG AA text contrast. It also fails on any layout overflow. Colors that carry meaning are contrast-tested in both themes, status is always an icon and a word, and time ranges are spoken in full.

## Testing

**Q: How do you test without mocking everything?**
A: Cubits, use cases and repositories run on a real stack: an in-memory drift database, the real fake server with zero latency, a fixed clock and a fake notification device. Only views mock their Cubit. Flows run on the real DI graph with a few swaps. See [TESTING.md](TESTING.md).

**Q: How do you know the tests are any good?**
A: Mutation checks: I break a rule on purpose (drop a transaction, remove a condition, reverse a sort) and confirm a test fails. 175 across the phases, each caught; the misses became new tests.

## Trade-offs and next steps

**Q: What would change with a real backend?**
A: `EventlyApi` gets an HTTP implementation; the DTOs and mappers stay. Server state stops being per-isolate (today the background's fake server is a fresh one), changes could arrive by push instead of polling, and auth would add a token store. See [ROADMAP.md](ROADMAP.md).

**Q: What's the weakest part today?**
A: Android reminders are inexact. Without the exact-alarm permission (denied by default from Android 14), Android can deliver a reminder within a window of up to an hour, which defeats a 15-minute lead time. The fix is to ask for exact alarms and fall back when they're denied.
