# Time Zones

An event happens at **one moment everywhere**, and is **told in one place's clock**. Evently keeps those two facts apart:

```dart
EventTime(
  start: DateTime.utc(2026, 10, 31, 20),   // the instants: the truth
  end:   DateTime.utc(2026, 10, 31, 23, 30),
  zone:  'Europe/London',                  // how the event is told
)
```

- **The instants decide everything time-based:** has it started, has it ended, is it upcoming, can it still be booked or cancelled, when its reminder rings. None of that moves when the phone changes zone.
- **The zone decides how it's told:** which clock a screen shows, and which calendar its days belong to.

A `DateTime` is either UTC or the *device's* zone, so it can't hold "18:30 in New York" on a phone in Lahore. `timezone`'s `TZDateTime` carries any IANA zone with its daylight-saving rules; `main` loads the database (`initializeTimeZones`) before anything reads a time.

## Three clocks

| Clock | Where it comes from | Used for |
|---|---|---|
| **The venue's** | `EventTime.zone` (an online event's organizer's) | an in-person event's time, the agenda's days and slots |
| **The user's** | `DeviceTimeZone`, read once with `flutter_timezone` (UTC if unknown) | "Today" / "Tomorrow", online events, date filters, the notification plan |
| **Now** | the injected `Clock`, read through `EventClock.now()` as UTC | upcoming and past, bookable, cancellable |

`EventClock` gives the user's "now" (`now()`), "today" (`today()`) and the day of any instant (`dayOf`). Widgets reach the user's zone through `UserTimeZone`, an `InheritedWidget` above the app, without a service.

## Which zone each screen shows

| Screen | In-person event | Online event |
|---|---|---|
| Event detail, a ticket | the venue's clock, and **"Your time"** below when the user's clock reads differently | the user's clock only (they join from where they are) |
| Cards (Discover, Search, Saved, Tickets, an organizer) | the venue's, with its zone's abbreviation ("6:30 PM GMT") | the user's |
| The agenda | the venue's days and slots | the venue's |
| Discover's days ("Today", "Tomorrow", "Wed 28 Oct") | the **user's** calendar | the user's |
| Search's date filters ("Today", "This weekend", "Next 7 days", custom) | the user's calendar, midnight to midnight | the user's |
| Notifications | the venue's time, with its abbreviation when it isn't the user's ("at 18:30 EDT") | the user's |

"Your time" appears only when the offsets differ at the start or the end (`EventFormats.differsIn`), so a London event on a London phone shows one line.

## Worked examples

All from the demo (its calendar started on Monday 26 October, as in the [screenshots](SCREENSHOTS.md)), on a phone in **Lahore** (UTC+5, no daylight saving):

- **Flutter London, 18:30–21:00 in London (Mon 26 Oct, GMT).** Event detail shows "Mon 26 Oct, 6:30 PM–9:00 PM GMT" and below it "Your time: Mon 26 Oct, 11:30 PM – Tue 27 Oct, 2:00 AM PKT": the user's clock crosses midnight, the venue's doesn't.
- **Midnight Code Jam, 23:30 in New York on Monday.** That's 08:30 on Tuesday in Lahore, so Discover lists it under **Tomorrow**, while the card says "Mon 26 Oct, 11:30 PM EDT": the user's calendar groups it, the venue's clock tells it.
- **Dart 3 Patterns Live Coding, online, 19:00 in London.** Online, so every screen shows the user's clock: "Wed 28 Oct, 12:00 AM PKT".
- **Form & Function, a two-day conference in Berlin.** Its agenda has a "Sat 7 Nov" and a "Sun 8 Nov" tab: the venue's days, whatever the phone's.

## Daylight saving

The demo deliberately straddles both autumn changes: London leaves summer time on **Sunday 25 October** (BST → GMT), New York on **Sunday 1 November** (EDT → EST).

- **Instants don't care:** an event at 18:30 on 24 October in London is 17:30 UTC; one at 18:30 on 26 October is 18:30 UTC. Each is stored as its instant.
- **The seed is written the way people plan** ("in 3 days at 18:30, in London") and rendered to instants with the zone's rules for that day, so 18:30 stays 18:30 across a change.
- **A local time that doesn't exist** (01:30 in London on the night clocks go forward) moves an hour later; **one that exists twice** (01:30 on the night they go back) is the second of the two, in standard time. That is `timezone`'s rule (conventions §11.70); organizers avoid both.
- **Days are midnight to midnight in their zone,** whatever the clocks do: "Today" on 25 October in London is 23 hours long, and the date filters' windows follow.
- **The daily summary** is planned at the user's wall-clock time (08:00) for each day, turned into an instant with that day's rules, so it stays at 08:00 across a change.

## Upcoming and past

- **Upcoming until its last instant:** `isUpcoming(event, now) = !event.time.hasEnded(now)`. An event that has started but not ended is still upcoming ("on now"), so it stays on Discover and in Tickets' Upcoming. Its end is exclusive: at 21:00 an event ending at 21:00 is over.
- **Booking closes at the start** (`hasStarted`), and so does cancelling: a place can only be given back before.
- **Search finds only what's still to come;** custom dates start today.

## The notification plan

`planNotifications` works in instants: a reminder is the event's start minus the lead time, wherever the phone is. The daily summary belongs to the user's day: events whose start falls on that day in the user's zone and haven't ended by the summary time. A phone that changes zone gets a new plan on the next sync (launch, resume, the background), because the plan depends on `EventClock`'s zone. See [NOTIFICATIONS.md](NOTIFICATIONS.md).

## Testing time

- **A fixed clock everywhere:** tests run at Wednesday 21 October 2026, 14:00 UTC (15:00 in London and Berlin, 10:00 in New York, 19:00 in Lahore), with London as the device's zone.
- **Pinned:** `EventTime` in four zones, across both clock changes and midnight, end-exclusive; the user's "today"; upcoming and past at their edges; day grouping across zones; date presets on a Saturday, a Sunday and across a change; agenda days; formatting in each zone with and without "Your time"; the summary on both sides of London's change and on a New York user's day.
- **The bundled seed passes every check as of six instants,** including both clock changes, so a day of the year can't break the demo.
