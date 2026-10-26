<!-- Thanks for contributing to Evently! -->

## Summary

<!-- What does this PR change, and why? -->

## Changes

-

## Checklist

- [ ] `fvm flutter analyze` reports no issues.
- [ ] `fvm dart format --output=none --set-exit-if-changed .` passes.
- [ ] `fvm flutter test` passes; new logic is covered by tests where practical (rules at their edges, time across zones and clock changes).
- [ ] Generated code is regenerated and committed (`fvm dart run build_runner build`).
- [ ] Architecture boundaries are respected (View → Cubit/Bloc → UseCase → Repository); screens read the cache, not the API.
- [ ] The catalog and the user's data stay apart: a sync writes no user table and deletes no event; "saved" and "going" stay joins.
- [ ] Bookings write only the server's answer, in one transaction.
- [ ] A schema change bumps `schemaVersion` and ships with `make-migrations` output and a migration test.
- [ ] Platform features go through a `domain/service` interface, with a fake for tests; notifications change only through the plan.
- [ ] Anything the background sync needs is wired into `BackgroundGraph` too.
- [ ] UI changes work in dark mode and at large text sizes, and new screens or states are added to the accessibility tour.
- [ ] A release build launches, if a plugin or native setup changed.
- [ ] Docs are updated if behaviour or structure changed.
- [ ] Commit messages follow Conventional Commits.

## Screenshots (if UI changed)

| Before | After |
|--------|-------|
|        |       |
