# Phase 8 — Documentation & CI

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 8, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 8 turns a working app into a finished open-source project:
- **the docs** a reader needs to learn from it: how it's built, how its data, time zones, notifications and background work behave, how it's tested, and what to ask about it in an interview;
- **the files** a contributor needs: CONTRIBUTING, a code of conduct, a security policy, a changelog, issue and PR templates, and CI;
- **one last check of the key behaviours:** every correctness rule broken on purpose, against the whole suite;
- **screenshots** in light, dark, large text and Android dynamic color, which meant one more look at the app on both platforms. That look found two device-only bugs, fixed here.

---

## 🧱 What Was Implemented

- **Docs** (`docs/`):
  - [ARCHITECTURE](ARCHITECTURE.md): layers and their import rules, who owns what, state, errors, navigation, DI, platform services, accessibility, key decisions;
  - [DATA_MODEL](DATA_MODEL.md): every table, constraint and foreign key, the joins, the transactions, the preferences;
  - [OFFLINE_FIRST](OFFLINE_FIRST.md): the cache, refresh and sync, server-confirmed writes, what works offline;
  - [TIME_ZONES](TIME_ZONES.md): instants and zones, which clock each screen shows, worked examples from the demo, daylight saving;
  - [NOTIFICATIONS](NOTIFICATIONS.md) and [BACKGROUND_WORK](BACKGROUND_WORK.md): the planner and the diff, change alerts, permission, taps; workmanager on both platforms, the background graph, checking it on a device;
  - [API_SIMULATION](API_SIMULATION.md): the fake server, its seed and calendar, bookings, the catalog update;
  - [TESTING](TESTING.md): 896 tests by area, how they're built, all 175 mutation checks, the gotchas;
  - [LEARNING_NOTES](LEARNING_NOTES.md), [INTERVIEW_NOTES](INTERVIEW_NOTES.md), [ROADMAP](ROADMAP.md);
  - [SCREENSHOTS](SCREENSHOTS.md): 24, with alt text, what to look for, and how to retake them.
- **The README** is final: screenshots, the demo and the fake API, local persistence, notifications and background work, the tests by area, the full "same app on other platforms" table, and every doc.
- **Open-source files:** CONTRIBUTING (the architecture rules, setup, schema changes, the seed, tests), CODE_OF_CONDUCT (Contributor Covenant 2.1), SECURITY (what the app holds, and doesn't), CHANGELOG (a version per phase), and the `.github` issue and PR templates. CI was already current: the FVM-pinned Flutter, generated code checked, format, analyze, test.
- **Summaries:** "Folder Structure Changes" added to Phases 2–7 (the conventions ask for it; only Phase 1 had it).
- **Cleanup:** no comment says which phase something arrived in; a scan found no unused classes.
- **Mutation checks of the key behaviours (21):** the correctness rules broken again on the final code, each against the whole suite. One was missed (below) and got its test.
- **Fixes found on devices:**
  - **A release build stuck on its launch screen.** Resource shrinking removed `ic_notification`, which Dart names only as a string; the plugin's `initialize` threw inside `launchTarget()`, before `runApp`. Fixed with `res/raw/keep.xml` (Momentum had it; Evently's Phase 7 missed it), and `main` now reads the launch notification best-effort, so a plugin error can't stop the app from starting.
  - **On Android, turning notifications on could leave the switch off.** Closing the permission dialog resumes the app, which reloads the settings. On Android the preferences store (DataStore) let that reload's read overtake the switch's own write, so the old value came back. Fixed in `SettingsRepositoryImpl.reload()`: it waits for this isolate's pending writes, and drops what it read if a change was made meanwhile.
  - **The demo calendar's anchor is read once per isolate:** a reload empties the preferences cache for a moment, and a read then would have started a new calendar.
- **Tests:** 896 (5 new): the reload racing a write (two stores that answer late), the anchor read once, a booking answer for another event, and the summary after the clocks go back. 21 more mutation checks.

### Differences from the plan

- **Two code fixes in a docs phase.** Both were found while taking the screenshots on the Android emulator; neither shows in a debug build's unit tests. They're small, tested (where a test can reach them), and recorded as conventions traps §11.84 and §11.85.
- **The final mutation pass ran against the whole suite,** not chosen test files: a mutation counts as caught if *any* test fails.
- **No new CI steps:** the workflow already matched the conventions (generated code checked, format, analyze, test). A release-build launch stays a device check (CONTRIBUTING says when).

---

## 💙 Flutter / Dart Concepts Demonstrated

- **Release-only behaviour:** resource shrinking and tree shaking happen only in release builds; anything named only from Dart (a drawable's name, an entry point) needs a keep rule or `@pragma('vm:entry-point')`.
- **Nothing fallible before `runApp`:** a `try` around `launchTarget()`, so the worst case is starting on the usual screen.
- **Ordering assumptions across a platform channel:** `SharedPreferencesAsync` on Android doesn't keep a read behind an earlier write. Code that reloads must wait for its own writes, and a newer local change beats a stale read.
- **Testing a race:** subclass the in-memory platform store (`InMemorySharedPreferencesAsync` is a `base class`) so writes or reads answer late, and drive the interleaving with short delays.
- **A heisenbug as a clue:** the switch bug vanished once `print`s were added, which pointed to timing rather than logic.
- **Mutation testing at the end:** the rules from the spec, broken one at a time, against the final code.

---

## 🔁 Data Flow (this phase)

```
resume ──▶ SettingsRepositoryImpl.reload()
             1. await this isolate's pending writes      (a read can't overtake them)
             2. note how many changes this isolate made
             3. reload the preferences cache from disk
             4. a change made meanwhile? keep it, drop what was read
             5. otherwise publish what was read

main ──▶ configureDependencies ──▶ _launchTarget() (best effort) ──▶ runApp
            a plugin error ──▶ logged, null ──▶ the usual start
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `docs/{ARCHITECTURE,DATA_MODEL,OFFLINE_FIRST,TIME_ZONES,NOTIFICATIONS,BACKGROUND_WORK,API_SIMULATION,TESTING,LEARNING_NOTES,INTERVIEW_NOTES,ROADMAP,SCREENSHOTS}.md` | The guides. |
| `docs/screenshots/*.png` | 24 screenshots. |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `CHANGELOG.md` | Open-source files. |
| `.github/ISSUE_TEMPLATE/{bug_report,feature_request}.md`, `.github/PULL_REQUEST_TEMPLATE.md` | Templates. |
| `android/app/src/main/res/raw/keep.xml` | Keeps the notification icon in release builds. |

---

## 🧩 Important Types Added

No new types; three changed:

| Type | Change | Why |
|------|--------|-----|
| `SettingsRepositoryImpl` | `reload()` waits for pending writes and yields to a newer change | Android's store doesn't order a read behind a write |
| `StoredDemoCalendar` | the anchor read once, then kept in memory | a reload empties the cache for a moment |
| `main` (`_launchTarget`) | reads the launch notification best-effort | nothing before `runApp` may stop the app |

---

## 🌱 Folder Structure Changes

- **New:** `docs/screenshots/`, `.github/ISSUE_TEMPLATE/`, `android/app/src/main/res/raw/`; the guides in `docs/`; the open-source files at the root.

---

## 🧪 Tests (896; 5 new)

| Area | New | What they pin |
|------|----:|---------------|
| Settings | 2 | A reload waits for its own writes (a store whose writes land late); a change made while a reload reads wins (a store whose reads answer late) |
| The calendar | 1 | Read once: with no stored anchor for a moment, and the clock a day later, the calendar keeps its anchor |
| Bookings | 1 | A booking answer for another event is refused, and nothing is written |
| The planner | 1 | After London's clocks go back, the 08:00 summary is 08:00 UTC |

**Mutation checks (21), each caught by the whole suite:**
- the upsert as `INSERT OR REPLACE`; the sync without its transaction;
- a cancelled ticket counted as going;
- the booking without its transaction; an answer for another event accepted (**missed at first**: nothing tested it; the test above was added);
- the one-active-ticket index made non-unique;
- bookings after the start; a sold-out type accepted; cancelling after the start;
- "upcoming" ending at the start; in-person events on the user's clock;
- Clear cache dropping ticketed events; the demo's replace without its transaction;
- foreign keys off; `LIKE` wildcards unescaped; the first-launch gate open; every settings key written; the wallpaper's color while dynamic color is off;
- the reload not waiting for its writes; the reload overriding a newer change; the anchor read again. The last two were missed by the first versions of their tests, which were too weak; both were strengthened.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| Final docs | README, ARCHITECTURE, TESTING, ROADMAP, DATA_MODEL, NOTIFICATION_SYSTEM, WORKMANAGER, API_SIMULATION, SCREENSHOTS | README, DATA_MODEL, NOTIFICATIONS, BACKGROUND_TASKS, the conventions' set | the same set, plus OFFLINE_FIRST and TIME_ZONES (the two ideas this edition leans on), LEARNING_NOTES and INTERVIEW_NOTES |
| Open-source files | CONTRIBUTING, CODE_OF_CONDUCT, LICENSE, CHANGELOG, SECURITY, templates | the same | the same |
| CI | `android-ci.yml` | `ios-ci.yml` | `flutter-ci.yml` on Ubuntu: generated code checked, format, analyze, test |
| Cleanup | code and test cleanup | cleanup | phase notes out of comments; a final mutation pass of the correctness rules |

Both native specs end with polish. The Flutter edition also re-ran its rules as mutations and took its screenshots on both platforms, including a release build, which is where its last two bugs were.

---

## 🎤 Interview Notes

**Q: Why did a bug only show in a release build?**
A: Release builds shrink resources and tree-shake code. The notification icon was named only as a string from Dart, so the shrinker saw no reference and removed it; the plugin then failed to initialize before `runApp`. Debug builds keep everything. A keep rule fixes it; launching a release build once is the check.

**Q: How did you find a race you couldn't reproduce with logging?**
A: It failed twice without logs and passed five times with them, which pointed to timing. I worked out which two operations could overlap (a settings reload on resume and the switch's write), then wrote tests with stores that answer late, so the overlap happens every time. Both tests failed before the fix.

**Q: What does mutation testing tell you that coverage doesn't?**
A: Coverage says a line ran; a mutation says a test would notice if the line were wrong. Of 21 final mutations, one survived (an answer for another event was accepted unnoticed), and two of my new tests were too weak until a mutation showed it.

---

## 📝 Learning Checklist

- ✅ Document a project for learners: architecture, data, time, offline, notifications, background, testing
- ✅ Ship the open-source file set and keep CI honest
- ✅ Prove the tests can fail, rule by rule
- ✅ Check a release build, not just debug
- ✅ Turn a timing bug into a deterministic test
- ✅ All eight phases

---

## 🚀 Future Improvements

See the [roadmap](ROADMAP.md): exact alarms on Android, a real backend with push, add to calendar, sharing, the app icon, large-text carousels, an initial delay for the first background run in release builds, localization, tablets.
