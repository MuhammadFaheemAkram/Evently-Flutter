# Phase 3 — Discover + Event Detail

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 3, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 3 puts the cached catalog on screen:
- **Discover:** featured events, events in your city, and what's coming up by day, filtered by category, with pull to refresh that works offline;
- **Event detail:** when (on the venue's clock, and yours when it differs), where (with directions, or the join link once you're going), how full, the tickets, the RSVP entry or why it's closed, the start of the agenda and the organizer;
- **saved and going as joins**, so a save or a booking shows everywhere at once, and a refresh can't undo them.

---

## 🧱 What Was Implemented

- **Domain:**
  - `EventCardItem` (an event, its organizer's name, `isSaved`, `isGoing`) and `EventDetails` (plus the organizer, the first three sessions, the agenda's size, your ticket);
  - `DayGroup<T>`;
  - pure calculations:
    - `isUpcoming` (until the event's last instant);
    - `groupByDay` (by the user's day; an event that started earlier and is still on is listed today);
    - `rsvpBlock` / `canRsvp` (going, cancelled, ended, started, sold out; the most decisive reason wins);
    - `discoverSections` (featured, in your city, upcoming by day);
    - `directionsTo` (an Apple Maps link on iOS, Google Maps elsewhere; both `https`);
  - `LinkOpener` (a service) and `OpenLinkUseCase` (`https` only);
  - `WatchEventCardsUseCase`, `WatchEventDetailsUseCase`, `SetEventSavedUseCase`, `WatchSettingsUseCase`.
- **The user's time zone:**
  - `DeviceTimeZone` (read once at launch with `flutter_timezone`, falling back to UTC);
  - `EventClock` (now, today and an instant's day, in the user's zone);
  - `UserTimeZone` (an `InheritedWidget` above the app, so any widget can tell a time in the user's zone).
- **Data:**
  - `EventsDao`: events with their organizer and offers, and the user's rows LEFT JOINed (a saved row, a ticket that isn't cancelled), watched;
  - `SavedEventsDao`: `INSERT OR IGNORE` and delete;
  - `CatalogRepository.watchEventCards` / `watchEventDetails`;
  - `SavedEventRepository`, which writes locally, so saving works offline;
  - `guardWrite` is back now that something uses it.
- **Formatting (`EventFormats`):**
  - day headings ("Today", "Tomorrow", "Sat, 24 Oct");
  - zoned times ("Sat 24 Oct, 18:30–21:00 BST", across days "Wed 21 Oct, 23:30 – Thu 22 Oct, 03:00 EDT"), read in full words by screen readers;
  - prices ("£18", "From £18", "Rs3,000", "Free");
  - counts ("2.4k followers"), places left, and the reason RSVP is off.
- **Design system:** `EventBanner`, `EventCard`, `FeaturedEventCard`, `CategoryChip`, `AttendanceLabel`, `GoingBadge`, `SaveButton`, `InitialsAvatar`, `OrganizerCard`, `ZonedTimeText`.
- **Discover** (`DiscoverCubit`):
  - a featured `PageView` with a page indicator;
  - "In London" (a row of compact cards; hidden for "Anywhere");
  - category chips filtering "Coming up", which is grouped by day;
  - Save on every card; RSVP or "Going" on the list's cards;
  - pull to refresh: offline, the events stay and a SnackBar says so;
  - an empty cache is filled first (loading, then error with Try again if offline).
- **Event detail** (`EventDetailCubit`):
  - a moved or cancelled banner;
  - the zoned time, the venue with **Directions** or "Online" with **Join online** once you're going;
  - attendance, the offers, RSVP (or "You're going" with **View ticket**, or disabled with the reason);
  - About, the agenda preview with **See full agenda (12 sessions)**, the organizer;
  - Save in the app bar; "not available" for a stale link.
- **Platform:** `UrlLauncherLinkOpener` (opens outside the app), and Android `<queries>` for `https`.
- **Tests:** 456 (144 new); 21 more mutation checks.

### Differences from the plan

- **Online events are told on the user's clock.** The plan shows an event in its venue's zone. An online event's "venue" is only its organizer's zone, so the first simulator run listed a 19:00 GMT stream under "Mon, 26 Oct" for a user in Pakistan (where it starts at midnight). An online event's time is now the viewer's own; in-person events keep the venue's time, with "Your time" below when it differs.
- **The featured card's time wraps at large text.** At AX3 the start was cut off ("6:30 …"); it may now take two lines, and the pager's height allows for it (found on the simulator).
- **The reminder toggle waits for Phase 7,** where notifications arrive: a toggle that schedules nothing would mislead.
- **Category chips filter "Coming up" only;** featured and "In your city" stay as they are, so a filter never empties the top of the screen.
- **No search entry point on Discover:** Search is a tab one tap away.
- **The join link shows only once you're going;** before that, Event detail says it will.

---

## 💙 Flutter / Dart Concepts Demonstrated

- **Joins instead of flags:**
  - LEFT JOINs over the user's tables give `isSaved` and `isGoing` each time the list is read;
  - because those tables are part of the query, drift re-runs it on a save or a booking, not only on a refresh;
  - each join matches at most one row (a primary key, the one-active-ticket index), so no event is listed twice.
- **One stream, two queries:** `watch().asyncMap(...)` loads the offers for the events the main query returned. Offers change only with their event, in the same transaction, so the event query is the trigger for both.
- **An `InheritedWidget` for an ambient value:** `UserTimeZone` puts the user's zone above `MaterialApp.router` (`builder:`), so cards and screens format times without a clock or a service, and tests can set any zone.
- **A `@preResolve` platform read with a fallback:** the device zone is read before the first frame; if that fails, the app falls back to UTC.
- **`RefreshIndicator.adaptive` over a `CustomScrollView`** of slivers, with `AlwaysScrollableScrollPhysics` so a short list can still be pulled.
- **Sizing for large text:**
  - a pager needs a height, so it's computed from the text scale (`textScaler.scale(16) / 16`);
  - a sideways row that must fit its tallest card uses `IntrinsicHeight` instead;
  - cards stack their actions under the attendance past 130 % (`prefersStackedLayout`).
- **One-time messages** with a serial number (`message` + `messageSerial`) and `BlocConsumer.listenWhen`.
- **Pattern matching** in views and Cubits: `if (location case final Venue venue)`, `switch (location) { Venue(:final city) => …, Online() => … }`.
- **`url_launcher` with `LaunchMode.externalApplication`,** behind a domain interface, and an `https`-only use case in front of it.

---

## 🔁 Data Flow (this phase)

```
DiscoverPage ─▶ DiscoverCubit.load()
  WatchEventCardsUseCase ─▶ CatalogRepository.watchEventCards()
    EventsDao.watchCards(): events ⋈ organizers ⟕ saved_events ⟕ tickets (not cancelled)
      .asyncMap(offers for those events) ─▶ EventCardItem(isSaved, isGoing)
  WatchSettingsUseCase ─▶ preferred city
  ─▶ discoverSections(cards, EventClock, city, category) ─▶ featured / in your city / upcoming by day

Pull to refresh ─▶ RefreshCatalogUseCase ─▶ upsert ─▶ the watched query re-runs by itself
  offline ─▶ Err(NetworkException) ─▶ SnackBar "You're offline. Showing the events you have."

Save (card or app bar) ─▶ SetEventSavedUseCase ─▶ SavedEventsDao (local, offline)
  ─▶ saved_events changes ─▶ every watching screen updates

EventDetailPage ─▶ EventDetailCubit.load(id)
  WatchEventDetailsUseCase ─▶ watchCard(id).asyncMap(organizer, first 3 sessions, count)
  Directions ─▶ directionsTo(venue, appleMaps: iOS) ─▶ OpenLinkUseCase (https only) ─▶ LinkOpener
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `lib/core/common/event_clock.dart` | `DeviceTimeZone` and `EventClock`: the user's now and today. |
| `lib/core/design_system/user_time_zone.dart` | The user's zone for every widget. |
| `lib/core/design_system/formatting/event_formats.dart` | Days, zoned times, prices, counts. |
| `lib/core/design_system/widgets/{event_card,featured_event_card,event_banner,attendance_label,save_button,category_chip,initials_avatar,organizer_card,zoned_time_text}.dart` | The event widgets. |
| `lib/core/database/daos/{events_dao,saved_events_dao}.dart` | Joined reads; saves. |
| `lib/domain/calculation/{event_timeline,rsvp_rules,discover_sections,directions}.dart` | The pure rules. |
| `lib/domain/model/{event_card_item,event_details,day_group}.dart` | Read models. |
| `lib/domain/service/link_opener.dart`, `lib/core/platform/url_launcher_link_opener.dart` | Opening links. |
| `lib/domain/usecase/{event_use_cases,open_link_use_case,settings_use_cases}.dart` | The use cases. |
| `lib/features/discover/**`, `lib/features/event_detail/**` | The two screens and their Cubits. |
| `test/app/discover_flows_test.dart`, `test/helpers/{event_card_fixtures,wait_for}.dart`, `fakes/recording_link_opener.dart` | Flows and test helpers. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `EventClock`, `DeviceTimeZone` | class | The user's now, today and day of an instant | `core/common`: used by Cubits and domain calculations |
| `UserTimeZone` | `InheritedWidget` | The user's zone for widgets | `core/design_system` |
| `EventCardItem`, `EventDetails`, `DayGroup<T>` | freezed | Read models | `domain/model` |
| `RsvpBlock`, `rsvpBlock`, `canRsvp` | enum / functions | Why an event can't be booked | `domain/calculation` |
| `discoverSections`, `groupByDay`, `isUpcoming`, `directionsTo` | functions | Discover's lists; time rules; maps links | `domain/calculation` |
| `EventsDao`, `EventCardRow` | drift accessor / row | Events joined with the user's rows | `core/database/daos` |
| `SavedEventRepository` | interface (+ impl) | Save / unsave, locally | contract in `domain`, impl in `data` |
| `LinkOpener`, `OpenLinkUseCase` | service / use case | Open links outside the app, `https` only | `domain` |
| `DiscoverCubit` / `DiscoverState` | Cubit / freezed | Lists, category, city, refresh, messages | `features/discover` |
| `EventDetailCubit` / `EventDetailState` | Cubit / freezed | One event, save, directions, join link | `features/event_detail` |
| `EventFormats` | final class | How events read | `core/design_system/formatting` |

---

## 🧪 Tests (456; 144 new)

| Area | New | What they pin |
|------|----:|---------------|
| Domain rules | 34 | The user's today across zones; upcoming at its edges; day grouping (a New York night is tomorrow in London, 23:59 is still today, an ongoing event is listed today, a late event goes on the user's day, not UTC's); every RSVP reason and their order; Discover's sections; maps links; `https` only |
| Data | 14 | Joins: saved, going, a cancelled ticket not going, one row per event, the list following saves and bookings; offers in the server's order; the agenda preview; saving twice; a refresh keeping saves and tickets; details with organizer and ticket |
| Formatting and widgets | 34 | Day headings; zoned ranges (one day, across days, summer and winter names, in the user's zone); spoken times; prices in four currencies; counts; the card's RSVP / Going / Save, its zone, its stacked layout; attendance; "Your time" |
| Discover | 22 | The Cubit on the real stack (sections, city following the setting, category, filling an empty cache, offline error then Try again, offline refresh message, saving everywhere, a failed save); the view in every state |
| Event detail | 25 | The Cubit (ready, every block, not found, save, following a booking, directions, join link only when going, a link that fails); the view (bookable, other zone, going, sold out, started, over, cancelled, moved, venue, online, agenda, not found, heading) |
| Flows | 7 | Discover → event → Back; save offline from a card; offline pull to refresh; RSVP from a card; an event's ticket, agenda and organizer; Directions; a stale link |
| Accessibility tour | 8 | Event detail going in another zone, online and going, sold out, over, not found; Discover now with the demo and a city; both themes at 200 % |

**Mutation checks (21), each caught. Examples:**
- bookings left open after the start, or "going" no longer winning;
- "upcoming" ending at the start;
- an ongoing event listed on its start day;
- featured including past events, or the category filtering featured;
- grouping by UTC's day;
- cancelled tickets counting as going;
- saving twice failing;
- `http` allowed;
- Apple and Google Maps swapped;
- online events on the organizer's clock, or "Your time" never shown;
- no "Tomorrow";
- "went" shown as "going";
- the offline message replaced by a raw error;
- an empty cache never filled;
- the join link opening for someone not going;
- no user zone app-wide, or the device zone ignored;
- RSVP on an unbookable card.

---

## 🌱 Folder Structure Changes

- **New:** `lib/core/common/event_clock.dart`, `lib/core/design_system/{formatting,widgets}/` filled out, `lib/core/platform/`, `lib/domain/calculation/`, `lib/domain/service/`, `lib/features/{discover,event_detail}/cubit/`.
- **Tests:** `test/app/discover_flows_test.dart`, `test/domain/calculation/`, `test/features/{discover,event_detail}/`.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Featured | carousel / card section | `LazyHStack` / `TabView` paging | `PageView` (88 % pages) with a page indicator and a label for screen readers |
| Upcoming | a list | a list | grouped by the user's day ("Today", "Tomorrow", "Sat, 24 Oct") |
| Your city | — (a setting only) | — | "In London": in-person events there, in a self-sizing row |
| Categories | a row | a row | chips filtering "Coming up" |
| Search entry | on Discover | on Discover | the Search tab |
| Refresh | pull to refresh | pull to refresh | `RefreshIndicator.adaptive`; offline keeps the cache and says so; an empty cache is filled first |
| Saved / going | flags on `Event` | `var` flags | LEFT JOINs, re-read on every save or booking |
| Event time | `Long` timestamps | `Date` | the venue's clock for in-person, the user's for online, and "Your time" when they differ |
| Location | location / online label | the same | the venue with Directions (Apple Maps on iOS, Google Maps elsewhere), or Online with the join link once going |
| RSVP entry | a button | a button | a button, or "You're going" with View ticket, or disabled with the reason |
| Reminder toggle | on Event detail | on Event detail | Phase 7, with notifications |
| Tests | unit tests | view model tests | rules, joins, formatting, both Cubits on the real stack, views, flows, the tour, mutation checks |

Both native specs keep `isSaved` and `isRsvped` as fields of the event and show its time as a timestamp. The Flutter edition derives both flags from the user's own rows, and tells each event in the zone that matters to the reader.

---

## 🎤 Interview Notes

**Q: Why does saving show on Discover without any refresh code?**
A: Discover watches a query that LEFT JOINs `saved_events`. Drift tracks every table a query reads, so a write to `saved_events` re-runs it, and the Cubit receives the new list. Nobody tells anyone; the database is the single source.

**Q: Which time zone does Event detail use?**
A: For an in-person event, the venue's: it's what the poster, the venue and every attendee say. The user's own time goes below when the clocks differ. For an online event, only the user's, since they join from where they are. "Today" and "Tomorrow" on Discover are always the user's days.

**Q: Why is the device zone an `InheritedWidget` and not a global?**
A: Widgets need it to format, and tests need to change it. Above `MaterialApp.router`, every widget can reach it, a test can put London or Lahore there, and nothing needs a service locator.

**Q: How does Discover behave offline?**
A: Exactly as online, from the cache. A pull to refresh that fails leaves the lists alone and shows a SnackBar. Only a cache that is empty *and* can't be filled is an error screen, with Try again.

**Q: Why refuse anything but `https` links?**
A: Join links come from the catalog. A `javascript:` or an app's own scheme there could do something the user never chose; refusing it in the use case means the platform never sees it.

---

## 📝 Learning Checklist

- ✅ Derive per-user flags with joins, and let the database drive the UI
- ✅ Tell times in the zone that matters to the reader, and test across zones
- ✅ Provide an ambient value with an `InheritedWidget`
- ✅ Build a sliver screen with pull to refresh, a pager and day groups that fit large text
- ✅ Keep offline states honest: cache first, errors only when there is nothing to show
- ✅ Put platform actions (links) behind an interface, with a safe use case in front
- ⬜ Search with a typed filter, and Saved (Phase 4)

---

## 🚀 Future Improvements

- **Phase 4:** Search (a debounced, restartable `SearchBloc` over the cache with a typed `EventFilter`) and Saved.
- **Later:**
  - follow the device's time zone while the app runs (it's read at launch);
  - refresh "upcoming" when an event ends with the screen open;
  - images for banners and avatars if a real backend sends them.
