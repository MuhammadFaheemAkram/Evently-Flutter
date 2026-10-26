# Roadmap

Evently was built in eight phases. Each ended with a building app, a clean analyzer, passing tests, a write-up and one commit.

## Done

| Phase | Scope | Write-up |
|---:|---|---|
| 1 | Foundation: FVM, the design system and category palette, typed routes with a first-launch gate, the tab shell with a drawer, CI | [PHASE_1_SUMMARY.md](PHASE_1_SUMMARY.md) |
| 2 | Data models with time zones, the drift cache (catalog and user tables), the fake API, Welcome | [PHASE_2_SUMMARY.md](PHASE_2_SUMMARY.md) |
| 3 | Discover and Event detail | [PHASE_3_SUMMARY.md](PHASE_3_SUMMARY.md) |
| 4 | Search with filters, and Saved | [PHASE_4_SUMMARY.md](PHASE_4_SUMMARY.md) |
| 5 | RSVP confirmed by the server, tickets with QR codes, the agenda | [PHASE_5_SUMMARY.md](PHASE_5_SUMMARY.md) |
| 6 | Organizers and Following, the profile, settings, the catalog update | [PHASE_6_SUMMARY.md](PHASE_6_SUMMARY.md) |
| 7 | Notifications planned and diffed, change alerts, the background sync | [PHASE_7_SUMMARY.md](PHASE_7_SUMMARY.md) |
| 8 | Documentation, CI, a final mutation pass, and two device-only fixes | [PHASE_8_SUMMARY.md](PHASE_8_SUMMARY.md) |

## Next ideas

**Reminders**
- **Exact alarms on Android where the user grants them** (`SCHEDULE_EXACT_ALARM`, checked with `canScheduleExactNotifications()`), falling back to inexact. Today Android may deliver a reminder within a window of up to an hour.
- **Notification actions:** "Directions" and "View ticket" on a reminder; "Cancel RSVP" on a change alert.
- **A per-event lead time** beside the global one.

**Data and sync**
- **A real backend:** an HTTP `EventlyApi`; the DTOs and mappers stay. One server for both isolates (the background's fake server is a fresh one today).
- **Push instead of polling** for changes to events you hold tickets for.
- **Incremental sync** (`updatedAt` since the last refresh) instead of the whole catalog.
- **Accounts:** sign-in, tickets across devices, a token in secure storage.

**Events**
- **Add to calendar** (an `.ics` file, or the device's calendar).
- **Share an event** (a link that opens its page, through the existing deep links).
- **Distance and a map:** events near you, a map view, directions from where you are.
- **Waitlists** for sold-out events.

**Polish**
- **The app icon:** it's still Flutter's default.
- **At the largest text sizes** (AX3), Discover's "In your city" carousel cuts long titles; the list below shows them whole. A taller card, or a list at large text.
- **The first launch:** WorkManager's first run refreshes beside Welcome (cheap in a release build, about 18 s in a debug build on a busy emulator). An initial delay in release builds would avoid the overlap.
- **Localization:** the words and the date patterns (`EEE d MMM`) are English only; 12- or 24-hour time already follows the device.
- **Tablets:** a navigation rail and two panes (the list and an event).
