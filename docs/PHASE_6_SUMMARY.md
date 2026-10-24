# Phase 6 — Organizers + Profile + Settings

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 6, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 6 fills in the people and the controls:
- **organizers:** their page with Follow, and Following, with each one's next event;
- **the profile:** counts of what's yours, and Edit profile with validation and a discard guard;
- **Settings:**
  - appearance and dynamic color (Android 12+), applied app-wide;
  - the preferred city;
  - **Clear cache** (keeping everything you own anything of) and **Reset demo data**;
  - developer tools, including **Publish a catalog update**, so the server can change under the app.

---

## 🧱 What Was Implemented

- **Settings model:** `AppSettings` gains `themeMode` (System / Light / Dark) and `dynamicColor`. Only changed keys are written, and an unknown stored value falls back to the default.
- **App-wide `SettingsCubit`** above `MaterialApp.router`:
  - the theme mode;
  - the wallpaper's color as the seed when dynamic color is on, through `DynamicColorSource` / `MaterialYouColorSource` (`dynamic_color`, palette only);
  - `DeviceColors` and `AppInfo` (`package_info_plus`) read before the first frame.
- **Settings** (`SettingsToolsCubit` for the actions):
  - appearance (segments, a radio list at large text) and the Dynamic color switch, only where the device has wallpaper colors;
  - preferred city (a radio dialog of the cached cities, or "Anywhere");
  - **Clear cache** and **Reset demo data**, each confirmed first, with a spinner while it runs (one task at a time) and a SnackBar with the result;
  - **Developer:** Simulate network failure, and Publish a catalog update;
  - About.
- **Clear cache** (`CatalogDao.clearUnowned`):
  - one transaction deletes events that nothing of the user's points at (saved, ticketed even if cancelled, a bookmarked session, a reminder, a change alert), and organizers left with no event and no follower;
  - offers and sessions go by `CASCADE`;
  - returns how many events went.
- **Reset demo data:** refetches the catalog first (the demo points at its events), then replaces the user's data with the demo's in one transaction. Offline, nothing changes.
- **The fake server's catalog update** (`catalog_update.json`, from Settings → Developer):
  - the design conference moves a day later (marked moved, with where it was; its sessions move too);
  - Dart 3 Patterns is cancelled; the AI summit's description is edited; two events appear;
  - a cancelled event can't be booked;
  - it's in memory, so a restart takes it back.
- **`DeveloperTools`:** an interface in `domain/service`, implemented over the fake network and server.
- **Organizer** (`OrganizerCubit`): initials, followers and events count, **Follow / Following** (a local `followed_organizers` row, offline), the bio, their events coming up then past.
- **Following** (`FollowingCubit`): the organizers you follow, A to Z, each with their next event (the soonest not over and **not cancelled**).
- **Profile** (`ProfileCubit`):
  - name, email and initials, or "Add your profile" on a fresh start;
  - counts from one live query: upcoming tickets, saved events, organizers followed, sessions bookmarked;
  - Edit profile and Settings.
- **Edit profile** (`ProfileEditCubit`, a full-screen dialog):
  - name (required, ≤ 50 graphemes), email, avatar URL (optional, `https`);
  - errors after the first Save;
  - a `PopScope` discard guard ("Discard changes?" / "Keep editing").
  - The profile row is written with every column, so a cleared avatar becomes `null` (§11.57).
- **About:** the version, the editions on other platforms, the licenses.
- **Cards say what the organizer said:** "Moved" and "Cancelled" (an icon and the word) on `EventCard` and `FeaturedEventCard`, and "Cancelled" replaces the places line.
- **Tests:** 762 (96 new); 26 more mutation checks.

### Differences from the plan

- **Event cards show "Moved" and "Cancelled".** After a published update, a cancelled event in a list only lost its RSVP button, with no word saying why. The rule "state never by color alone" covers cards too; this was found checking Following on the simulator.
- **Following skips cancelled events as "next".** The same check showed Flutter London's "Next" was the event the update had cancelled.
- **Followers stay the server's count:** a follow is your row, and the number on the page is the organizer's own, as a real backend would report it.
- **The server is registered as `FakeEventlyApi` and exposed as `EventlyApi`,** so the developer tools reach the same instance.
- **Notifications in Settings arrive in Phase 7,** as planned.

---

## 💙 Flutter / Dart Concepts Demonstrated

- **App-wide state above the router:**
  - `BlocProvider` + `BlocBuilder` around `MaterialApp.router` (`buildWhen` on the theme only), so a theme change rebuilds the app without touching navigation.
- **Dynamic color on `material_ui`:**
  - only the palette comes from the plugin; the scheme is built with `ColorScheme.fromSeed` (the plugin's own scheme is `flutter/material.dart`'s class, §11.55);
  - the state and category colors stay the app's own, since they carry meaning and are contrast-tested.
- **`@preResolve` for platform reads:** the device's colors and the app's version are ready on the first frame.
- **`PopScope` with `onPopInvokedWithResult`:** a discard guard for the system back gesture as well as Close.
- **Combining live queries:** `stream_transform`'s `combineLatest` joins the organizer (and your follow) with their events, and the follows with all events.
- **One `customSelect` with sub-queries for counts:** `readsFrom` lists every table, so drift re-runs it on any change. `Variable<DateTime>` uses the same text format as the columns.
- **Deleting by exclusion:**
  - Clear cache asks the database for everything the user owns (a `UNION` of the user's tables), then deletes the rest;
  - the `RESTRICT` foreign keys stay the safety net.
- **Adaptive controls:** `SwitchListTile.adaptive`, adaptive confirm dialogs, segments that become radios at large text.

---

## 🔁 Data Flow (this phase)

```
MaterialApp.router ◀── SettingsCubit (settings.watch(), DeviceColors)
  theme: dynamicSeed ? AppTheme.fromSeed(wallpaper) : AppTheme.light/dark;  themeMode: System / Light / Dark

Settings ─▶ SettingsToolsCubit
  Clear cache ─▶ confirm ─▶ ClearCacheUseCase ─▶ CatalogDao.clearUnowned (transaction) ─▶ "Cleared N"
  Reset demo  ─▶ confirm ─▶ ResetDemoDataUseCase: refresh catalog ─ ok ─▶ DemoRepository.loadDemoUser (transaction)
  Publish     ─▶ DeveloperTools ─▶ FakeEventlyApi.publishUpdate ─▶ next fetch: moved / cancelled / edited / new
                    └─ pull to refresh ─▶ upsert ─▶ tickets "Moved", "Cancelled by the organizer"; cards say so

Organizer ─▶ OrganizerRepository.watchOrganizer: organizers ⟕ followed_organizers  ⨝combineLatest⨝  events by organizer
Follow    ─▶ SetFollowingUseCase ─▶ OrganizersDao.setFollowing (local, offline)
Profile   ─▶ ProfileDao.watchProfile + watchCounts(now) (one query, four counts)
Edit      ─▶ ProfileRules (form) ─▶ UpdateProfileUseCase (rules again) ─▶ ProfileDao.saveProfile (every column)
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `lib/domain/model/{app_settings,device_info,user_summary}.dart` | Settings, device info, profile counts and organizer read models. |
| `lib/domain/calculation/profile_validation.dart` | The profile's rules. |
| `lib/domain/service/{dynamic_color_source,developer_tools}.dart`, `lib/core/platform/material_you_color_source.dart`, `lib/core/network/fake_developer_tools.dart` | Wallpaper colors; the developer switches. |
| `assets/json/catalog_update.json`, `fake_evently_api.dart` (update) | The catalog update the server can publish. |
| `lib/core/database/daos/{organizers_dao,profile_dao}.dart`, `catalog_dao.dart` (`clearUnowned`) | Follows, the profile and counts; Clear cache. |
| `lib/data/repository/{organizer,profile}_repository_impl.dart` | Repositories. |
| `lib/domain/usecase/{organizer,profile,settings}_use_cases.dart` | Use cases. |
| `lib/features/{settings,organizer,following,profile,profile_edit,about}/**` | The screens and their Cubits. |
| `lib/core/design_system/widgets/{segmented_choice,attendance_label}.dart` | Segments that wrap; `EventStatusBadge`. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `AppThemeMode`, `AppSettings` (+ theme, dynamic color) | enum / freezed | The appearance settings | `domain/model` |
| `DeviceColors`, `AppInfo` | value classes | Read once before the first frame | `domain/model` |
| `DynamicColorSource`, `DeveloperTools` | interfaces | Wallpaper colors; the developer switches | `domain/service`; impls in `core/` |
| `ProfileCounts`, `OrganizerDetails`, `FollowedOrganizer` | freezed | Read models | `domain/model` |
| `ProfileRules` | final class | Name, email, avatar rules | `domain/calculation`: shared by form and use case |
| `OrganizersDao`, `ProfileDao` | drift accessors | Follows; profile and counts | `core/database/daos` |
| `OrganizerRepository`, `ProfileRepository` | interfaces (+ impls) | Organizers and follows; the profile | contracts in `domain`, impls in `data` |
| `SettingsCubit` | Cubit (app-wide) | Theme mode, dynamic color, city | above the router |
| `SettingsToolsCubit`, `OrganizerCubit`, `FollowingCubit`, `ProfileCubit`, `ProfileEditCubit` | Cubits | The screens | `features/*` |
| `EventStatusBadge` | widget | "Moved" / "Cancelled" with an icon | `core/design_system/widgets` |

---

## 🧪 Tests (762; 96 new)

| Area | New | What they pin |
|------|----:|---------------|
| Domain | 5 | Name required and ≤ 50 graphemes; email shape; avatar optional and `https` |
| Data | 29 | Appearance saved and read back, unknown values falling back; the catalog update (nothing before; moved a day with sessions, previous start, cancelled, edited, new, still valid; a cancelled event unbookable); Clear cache keeping every kind of owned event, dropping offers, sessions and unfollowed organizers; organizers, follows live, Following A to Z with next events (none when all are over, never a cancelled one); profile save, avatar cleared, invalid refused, counts; clear and reset (online, offline, no catalog → no reset); the developer switches |
| Cards | 2 | "Cancelled" instead of places, "Moved"; a featured card's status over Going |
| Settings | 20 | The Cubits (theme, dynamic color, city; the seed only while on; tools: cities, clear, reset, offline, publish, one at a time); the view (sections, segments and radios at large text, the dynamic switch only with wallpaper colors, the city dialog, confirmations and Cancel, spinners, developer switches, SnackBar) |
| Organizer | 9 | The Cubit (events split, follow and unfollow, saving, not found); the view (counts, Follow vs Following with a check, nothing planned, not found) |
| Profile, Following, Edit profile | 18 | Counts and the fresh start; Following's next events and empty state; Edit profile's start values, empty form, errors only after Save, saving, no changes when typed back, Close vs Discard vs Keep editing, the locked form |
| About, flows | 7 | The version; Dark app-wide; dynamic color as the seed; publish → refresh → Moved / Cancelled tickets; clear cache keeping Saved; follow → Following and the count; edit → Profile |
| Accessibility tour | 6 | Profile on a fresh start, Following with nobody, Edit profile with errors; both themes at 200 % |

**Mutation checks (26), each caught:**
- the profile rules weakened;
- the theme mode not saved, or the wrong fallback;
- Clear cache dropping tickets or bookmarked events, or followed organizers;
- the avatar not cleared;
- past tickets counted;
- a past event as "next";
- the update not marking moved, without the previous start, or always on;
- Reset demo without the catalog;
- the seed while dynamic color is off;
- two tools at once;
- dynamic color or Dark not applied;
- the switch shown without wallpaper colors;
- clear cache not asking (or not honouring Cancel);
- no discard guard;
- errors while typing;
- an invalid form sent;
- Follow and Following swapped;
- cards not saying Cancelled;
- a cancelled event as "next".

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Organizer | profile, events, a followers placeholder | profile, events | profile, events (upcoming / past), **Follow** as a user table, and **Following** with each organizer's next event |
| Profile | name, email, avatar | the same, `var` | initials, name, email, live counts; Edit profile with validation and a discard guard |
| Appearance | dark mode, **dynamic color** | appearance | System / Light / Dark app-wide; dynamic color on Android 12+ from the wallpaper, hidden elsewhere |
| Preferred city | DataStore | `@AppStorage` | preferences; Discover's "In your city" follows it |
| Clear cache | yes | yes | keeps everything the user owns anything of (saved, tickets, bookmarks, reminders, alerts), in one transaction |
| Reset demo data | yes | yes | refetch the catalog, then the demo in one transaction; offline, nothing changes |
| Developer tools | — | — | simulate failure; **publish a catalog update** (moved, cancelled, edited, new) |
| Settings storage | DataStore | `@AppStorage` | `SharedPreferencesWithCache`, only changed keys written |

The native specs list the settings. The Flutter edition adds a way to make the server change, so the app's handling of moved and cancelled events (and, in Phase 7, the alerts) can be seen without waiting for a real organizer.

---

## 🎤 Interview Notes

**Q: How does Clear cache avoid deleting something the user cares about?**
A: It never asks "what can I delete?"; it asks "what does the user own?". A `UNION` over saved events, tickets (even cancelled), bookmarked sessions, reminders and change alerts gives that set, and only the rest goes. The `RESTRICT` foreign keys would refuse anything else anyway: belt and braces.

**Q: Why does dynamic color only seed the scheme?**
A: The plugin's ready-made scheme is the other Material's class (`flutter/material.dart`), not `material_ui`'s. And the colors that carry meaning (going, sold out, moved, cancelled, the categories) shouldn't change with the wallpaper: they're contrast-tested against the app's surfaces.

**Q: How do you make a backend change without a backend?**
A: The fake server keeps state in memory. "Publish a catalog update" flips it to serve a second version of the seed, with an event moved, one cancelled, one edited and two new. The app's refresh, banners, ticket states and (next phase) alerts all react as they would to a real change.

**Q: Why the discard guard on Edit profile?**
A: Back is easy to hit by accident, especially the system gesture. `PopScope` stops the pop when there are unsaved changes and asks first; with nothing changed, it leaves freely.

---

## 📝 Learning Checklist

- ✅ Put app-wide settings above the router and theme the whole app from them
- ✅ Use the wallpaper's color as a seed without losing the app's meaningful colors
- ✅ Combine live queries into one read model
- ✅ Delete by exclusion, inside a transaction, with foreign keys as the safety net
- ✅ Guard a form against losing edits
- ✅ Give the fake server a way to change, to exercise the app's reactions
- ⬜ Notifications and background sync (Phase 7)

---

## 🚀 Future Improvements

- **Phase 7:**
  - reminders, the RSVP confirmation and the daily summary, planned and diffed (the Momentum planner);
  - a background sync that records moved and cancelled events and alerts once;
  - the notification settings.
- **Later:** a city picker that also offers cities not in the cache; profile photos for a real backend.
