# Phase 4 — Search + Saved

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 4, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 4 lets the user find events and keep them:
- **Search, over the cache:**
  - text (title, organizer, venue, city) plus a **typed filter** (categories, dates, price, format, your RSVP), built into **one drift query**;
  - debounced and restartable in a `SearchBloc`;
  - works offline.
- **Saved:** the events you saved, offline, upcoming then past; swipe one away (or tap its bookmark) and Undo.

---

## 🧱 What Was Implemented

- **Domain:**
  - `EventFilter` (query, categories, `DatePreset` (any, today, this weekend, next 7 days, custom with `from` / `to`), `PriceFilter`, `FormatFilter`, `RsvpFilter`), with `activeCount` for the badge;
  - `SearchCriteria`: the filter resolved against the clock;
  - pure calculations: `daysFor` (the days a preset covers in the user's calendar), `criteriaFor` (those days as instants, midnight to midnight in the user's zone) and `splitByEnd` (upcoming soonest first, past most recent first).
- **Data:**
  - `EventsDao.watchSearch`: every filter is a `WHERE` clause on the same joined query Discover uses:
    - only events not yet over;
    - the text matched with an escaped `LIKE` against title, organizer, venue and city;
    - categories with `IN`;
    - the window by overlap (an ongoing event counts for "Today");
    - free / paid with an `EXISTS` over the offers;
    - online / in person by the join link;
    - going / not going from the LEFT JOIN on active tickets;
  - `EventsDao.watchSavedCards`;
  - `RecentSearchesDao`: newest first, case-insensitive de-duplication, the last 10, one transaction per save;
  - `SearchRepository`, `RecentSearchesRepository` and `SavedEventRepository.watch`.
- **Use cases:** `SearchEventsUseCase` (resolves the presets with `EventClock`), `WatchRecentSearchesUseCase`, `SaveRecentSearchUseCase` (trimmed; two characters at least), `ClearRecentSearchesUseCase`, `WatchSavedEventsUseCase`.
- **Search** (`SearchBloc`):
  - **Events:**
    - typed text is debounced (300 ms);
    - applied filters, a tapped recent search and the keyboard's Search key run at once;
    - every input restarts the live results;
    - text under two characters with no filter shows the recent searches;
    - filters alone search.
  - **The view:**
    - `AppSearchField` and a filter button whose badge counts the filters that are on;
    - removable chips for each active filter;
    - recent searches (tap to reuse, Clear all);
    - "N events" (a live region) and `EventCard`s with Save and RSVP;
    - "No events match", with Clear filters when filters are on.
- **The filter sheet:** a draft until Apply:
  - multi-select category chips;
  - date presets, with Custom… opening `showDateRangePicker` (from today on);
  - price, format and RSVP;
  - Reset;
  - shown above the tab bar.
- **Saved** (`SavedCubit`):
  - "Coming up" and "Past" sections;
  - swipe to remove (`Dismissible`) or tap the bookmark, then a SnackBar with Undo;
  - an empty state leading to Discover.
- **Tests:** 546 (90 new); 21 more mutation checks.

### Differences from the plan

- **Search finds what's still to come.** Past events are left out, and custom dates start today: "can I go to it?" is what Search answers. Past events you saved or booked are in Saved and Tickets.
- **Recent searches live in drift** (the `recent_searches` table from Phase 2), not in preferences: they're the user's data, cleared with it.
- **The keyboard's Search key counts as acting on a search,** like opening a result, so it's remembered.
- **Undo saves the event again** with a new time; Saved is ordered by the event's own time, so nothing visible changes.

---

## 💙 Flutter / Dart Concepts Demonstrated

- **A Bloc where a Cubit would need timers:**
  - `on<SearchInputChanged>(…, transformer: debounceRestartable(…))`;
  - `switchMap` to a delayed value debounces, and `restartable()` cancels the previous handler and its live `emit.forEach` results;
  - text changes and filter changes are subtypes of one sealed event, so one transformer orders them and the newest always wins.
- **A typed filter compiled to SQL:** each optional part adds a condition; `Expression.and` joins them. `existsQuery(...).not()` expresses "no paid offer".
- **`LIKE` safely:** the user's `%`, `_` and the escape character are escaped (`ESCAPE '\'`); a test proves `_` is literal.
- **Time windows by overlap:** `start < until AND end > from`, with the window built from the user's midnights (`TZDateTime`), so a 49-hour weekend (clocks going back) is right.
- **`showModalBottomSheet(useRootNavigator: true)`** returning a value; a draft edited in a `StatefulWidget`.
- **`Dismissible` + `SnackBarAction`** for remove with Undo, with the removal as a one-time state (`removed` + `removedSerial`).
- **Testing time two ways:** `fake_async` proves the 300 ms debounce exactly. Switching between live searches awaits a real stream cancel, so it's tested in real time with a short debounce (conventions §11.45).

---

## 🔁 Data Flow (this phase)

```
Typing ─▶ SearchQueryChanged (debounced 300 ms) ─┐
Apply / remove a chip ─▶ SearchFiltersChanged ───┤ one sealed event, restartable
Recent search tapped ─▶ SearchQueryChanged(now) ─┘
  ─▶ EventFilter (text ≥ 2 chars, or any filter)
  ─▶ SearchEventsUseCase: criteriaFor(filter, EventClock) ─▶ SearchCriteria (instants, now)
  ─▶ EventsDao.watchSearch: events ⋈ organizers ⟕ saved ⟕ active tickets
        WHERE ends_at > now AND (title|organizer|venue|city LIKE %text%) AND category IN …
              AND starts_at < until AND ends_at > from AND [no] paid offer AND …
  ─▶ emit.forEach: live results (a save or a booking updates them)

Saved ─▶ SavedCubit ─▶ EventsDao.watchSavedCards ─▶ splitByEnd ─▶ Coming up / Past
  swipe ─▶ unsave ─▶ SnackBar "Removed …" ─▶ Undo ─▶ save
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `lib/domain/model/{event_filter,search_criteria}.dart` | The typed filter, and its resolved form. |
| `lib/domain/calculation/date_presets.dart` | Presets → days → instants. |
| `lib/core/database/daos/recent_searches_dao.dart` | Recent searches. |
| `lib/core/database/daos/events_dao.dart` (extended) | The search query; saved cards. |
| `lib/data/repository/{search,recent_searches}_repository_impl.dart` | Repositories. |
| `lib/domain/usecase/search_use_cases.dart` | Search and recent-search use cases. |
| `lib/features/search/{search_page,bloc/*,widgets/filter_sheet}.dart` | Search, its Bloc, the filter sheet. |
| `lib/features/saved/{saved_page,cubit/*}.dart` | Saved. |
| `lib/core/design_system/{widgets/app_search_field,formatting/filter_labels}.dart` | The search field; filter labels and chips. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `EventFilter`, `DatePreset`, `PriceFilter`, `FormatFilter`, `RsvpFilter` | freezed / enums | What Search asks for | `domain/model` |
| `SearchCriteria` | freezed | The filter as instants and "now" | `domain/model` |
| `daysFor`, `criteriaFor`, `splitByEnd` | functions | Presets and time rules | `domain/calculation` |
| `RecentSearchesDao` | drift accessor | Newest first, case-insensitive, ten | `core/database/daos` |
| `SearchRepository`, `RecentSearchesRepository` | interfaces (+ impls) | Search and its history | contracts in `domain`, impls in `data` |
| `SearchBloc`, `SearchEvent`, `SearchState`, `debounceRestartable` | Bloc | Typing, filters, results, recent searches | `features/search/bloc` |
| `FilterSheet`, `showFilterSheet` | widget / function | Editing the filter as a draft | `features/search/widgets` |
| `SavedCubit`, `SavedState` | Cubit / freezed | Saved, remove, Undo | `features/saved` |
| `FilterLabels` | final class | How filters read; the removable chips | `core/design_system/formatting` |

---

## 🧪 Tests (546; 90 new)

| Area | New | What they pin |
|------|----:|---------------|
| Domain | 15 | Each preset's days (this weekend on a weekday, a Saturday, a Sunday, a Monday; custom in order; missing ends); the user's midnights in summer time and across the clock change (a 49-hour weekend); the filter's count and removals; the past/upcoming split |
| Data | 25 | The search query: each text field, case, past left out, `%` and `_` literal; categories; window overlap at both edges; free vs paid (a free tier still paid); online / in person; going vs a cancelled ticket; everything at once; live on a save; saved cards. Recent searches: order, case, ten, clear, trimming, too short |
| Filter labels and sheet | 9 | Labels; custom range text; each chip removing only itself; the sheet as a draft, toggling, Reset keeping text, the date picker, closing without Apply |
| Search | 24 | The Bloc: the 300 ms debounce and the immediate inputs in fake time; the last text winning, too short idle, filters alone, text and filters kept, a newer search stopping older results, failure; on the real stack: results, saves, recent searches. The view in each state, chips, badge, sheet, Save |
| Saved | 10 | The Cubit (demo order, Past, remove and Undo, empty, a failed undo); the view (empty, sections, swipe, bookmark, Undo) |
| Flows | 3 | Search offline → open → recent search; filters alone and a chip removed; saved from Discover → Saved → swiped → Undo |
| Accessibility tour | 4 | Search with results and filters, the filter sheet; both themes at 200 % |

**Mutation checks (21), each caught:**
- `LIKE` unescaped;
- the organizer not searched;
- past events found;
- the window not by overlap;
- "free" as "has a free offer";
- not going ignoring tickets;
- recent searches case-sensitive, unlimited, or keeping one letter;
- this weekend on a Sunday;
- midnights in UTC;
- next 7 days as 8;
- no debounce, or concurrent instead of restartable;
- filters alone not searching;
- applied filters dropping the text, or short text sent with them;
- a chip removing every filter;
- the badge counting categories as one;
- Saved without Past, or without Undo.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Where search runs | the API: `searchEvents(query)` | the service | the **cache**, so it works offline |
| Debounce | Flow `debounce` | debounced | a Bloc transformer: debounce + restartable, filters at once |
| Text matched | title / organizer / location | the same | title, organizer, venue, city; `%` and `_` literal |
| Filters | category, date, location | category, date range, free/paid, online/offline, RSVP status | the iOS set as a typed `EventFilter`, compiled to one drift query; presets in the user's calendar |
| Active filters | — | — | removable chips and a badge |
| Recent searches | Room entity | persisted, clear | drift, newest first, case-insensitive, ten, clear all |
| Saved | from Room, offline | from SwiftData, offline, remove | drift, upcoming then past, swipe or bookmark to remove, Undo |
| Tests | — | search logic | the query for every filter, presets, the Bloc in fake and real time, views, flows, the tour, mutation checks |

The Android spec searches through the API, so search needs the network. Like iOS, the Flutter edition keeps search on the device, and goes further: the filters are one SQL query over the same cache Discover reads.

---

## 🎤 Interview Notes

**Q: Why is Search a Bloc when every other screen is a Cubit?**
A: Typing is a stream of events that needs shaping: wait for a pause, drop the stale ones, cancel the previous live query. A Bloc's event transformer says that in one place (`debounceRestartable`). A Cubit would need timers and subscriptions managed by hand.

**Q: Why are text and filter changes one event type?**
A: So they share one transformer. If they were separate handlers, an older text search could finish after a newer filter change and overwrite its results. As subtypes of one sealed event, the newest input always wins.

**Q: How does "This weekend" handle the night the clocks go back?**
A: The preset is resolved to calendar days first (Saturday and Sunday in the user's calendar), and only then to instants: midnight to midnight in the user's zone with `TZDateTime`. That weekend is 49 hours long, and the test says so.

**Q: How is "free" expressed in SQL?**
A: As "no offer has a price": `NOT EXISTS (SELECT … FROM ticket_offers WHERE event_id = events.id AND price_minor > 0)`. "Has a free offer" would wrongly count an event with a free tier and a VIP tier as free.

---

## 📝 Learning Checklist

- ✅ Shape user input with a Bloc's event transformers (debounce + restartable)
- ✅ Compile a typed filter to one SQL query, with `EXISTS`, `IN`, overlap and escaped `LIKE`
- ✅ Resolve calendar presets in the user's zone, including clock changes
- ✅ Edit filters as a draft in a bottom sheet, show them as removable chips
- ✅ Remove with Undo, as a one-time state
- ✅ Test time in fake time where possible, and real time where a cancel must finish
- ⬜ RSVP, tickets and the agenda (Phase 5)

---

## 🚀 Future Improvements

- **Phase 5:** server-confirmed RSVP, tickets with QR codes, and the agenda with bookmarks and clashes.
- **Later:**
  - full-text search (SQLite FTS5) with ranking, once the catalog grows;
  - searching past events behind a toggle;
  - remembering the last filters between launches.
