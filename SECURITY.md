# Security Policy

## Supported Versions

Evently is a learning/reference project. Security fixes are applied to the latest `main` only.

| Version | Supported |
|---------|:---------:|
| `main`  | ✅ |

## Reporting a Vulnerability

Please **do not** open a public issue for security problems.

Instead, email **muhammadfaheem004@gmail.com** with:

- a description of the issue and its impact;
- steps to reproduce (a proof of concept if possible);
- any suggested remediation.

You can expect an acknowledgement within a few business days.

## What the App Holds

Evently has **no backend, no account and no API key**. The "API" is a fake server inside the app: it renders its events from JSON files bundled with the app and keeps its state (places taken, the tickets it issued) in memory. The app makes no network request of its own.

- **The cache and the user's data** (events, saved events, tickets and their codes, bookmarks, follows, reminder choices, recent searches, a name, an email and an avatar link) live in a SQLite database (drift) in the app's documents directory. It is not encrypted at rest; it is protected by the operating system's app sandbox like any app's private files. Reset demo data replaces the user's data; everything goes when the app is removed.
- **Ticket codes** are demo values with a check character, not secrets: the fake server issues them, and nothing redeems them.
- **Preferences** hold only the onboarding flag, the preferred city, the appearance, dynamic color, the notification settings and times, and the fake server's calendar anchor.
- **Search is injection-safe:** the user's text reaches SQLite only as a bound parameter of a `LIKE`, with `%`, `_` and `\` escaped; it is never concatenated into SQL.
- **Links:** directions and join links open outside the app, `https` only; anything else is refused. The profile's avatar link must be `https` too.
- **Notifications** are local, scheduled on the device; their payloads hold only an event or ticket id and a time. A tap with an unknown payload is ignored.
- **Background work** runs on the device only (WorkManager, BGTaskScheduler) and touches only the app's own database and preferences.

The practical attack surface is small. Reports about data handling, link handling, notification handling, dependency issues or unsafe patterns are still very welcome.
