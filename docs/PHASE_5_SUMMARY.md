# Phase 5 — RSVP + Tickets + Schedule

> A beginner-to-intermediate friendly write-up covering:
> - what shipped in Phase 5, and why;
> - the Flutter / Dart concepts it demonstrates;
> - how the Android and iOS editions planned the same phase.

---

## 🎯 Phase Goal

Phase 5 is where the server owns state the user changes:
- **RSVP, confirmed by the server:**
  - no ticket exists until the (fake) server answers;
  - its answer (the ticket and the event's new place counts) is written in **one transaction**;
  - a failure writes nothing and says why.
- **Tickets:** upcoming and past, each with a real **QR code** of a code that carries a check character; cancel before the event starts, server first.
- **The agenda:** sessions by the venue's days, bookmarks, and **clashes** between bookmarked sessions.

---

## 🧱 What Was Implemented

- **Domain:**
  - `TicketCodes` (`EVT-XXXX-XXXX` from an alphabet without 0/O/1/I, with a **Luhn mod N** check character);
  - `validateRsvp`: a sealed `RsvpProblem` (closed, no type, type not sold, type sold out, note over 200 characters counted as graphemes);
  - `TicketItem` with `TicketStatus` (confirmed, moved, cancelled by the organizer, cancelled by you);
  - `cancelBlock` (cancelled already, event cancelled, started);
  - `Agenda` / `AgendaDay` / `AgendaSession` and `buildAgenda` (days in the event's zone, clashes between bookmarked sessions, end-exclusive).
- **The fake server, with state** (in memory, reset on launch):
  - places taken per event and type, applied to every catalog it serves;
  - the tickets it issued (and the demo's, once sent);
  - `rsvp` refuses a cancelled, started, sold-out or already-booked event (`BookingClosedException`, `SoldOutException`, `AlreadyBookedException`) and issues a code;
  - `cancelRsvp` gives the place back. It carries the event and type, so a server that restarted and forgot the ticket still can.
- **Data:**
  - `BookingDto`, `RsvpRequestDto`, `CancelRequestDto`;
  - `EventDto.toEvent()` (the catalog's per-event checks, now shared);
  - `TicketDto.toTicket()` (refuses a code failing its check);
  - `TicketsDao.book` / `cancel`: the ticket and the event's rows in one transaction;
  - `SessionBookmarksDao`: sessions LEFT JOIN bookmarks;
  - `BookingRepository` and `ScheduleRepository`.
- **Use cases:**
  - `RsvpEventUseCase` checks the form again against the latest cached event before calling the server;
  - `CancelRsvpUseCase` refuses after the start;
  - the watch use cases, and `SetSessionBookmarkedUseCase`.
- **RSVP** (a full-screen dialog, `RsvpCubit`):
  - the event summary;
  - a `RadioGroup` of the event's offers (price, places left; sold-out ones off; the only type preselected);
  - an optional note with a counter;
  - errors after the first Confirm;
  - "Confirm · £45";
  - Submitting, then a failure card with Try again;
  - on success a **one-time effect** replaces the dialog with the new ticket (`pushReplacement`), so Back returns to the event.
- **Tickets** (a tab): Upcoming / Past tabs, `TicketCard`s with the state in words and an icon, an empty state per tab.
- **Ticket detail:**
  - the QR (`TicketQr`: black on white in both themes, labelled "QR code for ticket …");
  - the code on one line (it shrinks to fit at large text);
  - when, where, type, note, booked on; Open the event;
  - **Cancel RSVP** (adaptive confirm dialog, "Keep it"), only before the start; no QR once cancelled.
- **Agenda:** day chips for multi-day events, "My sessions", `ScheduleSessionCard`s (slot on the venue's clock, speaker and room, a star to bookmark), "Clashes with …".
- **Design system:** `TicketCard`, `TicketStatusLabel`, `TicketQr`, `ScheduleSessionCard`, `showConfirmDialog` (adaptive).
- **Tests:** 666 (120 new); 24 more mutation checks.

### Differences from the plan

- **The check character is Luhn mod N, not a weighted sum.** The first algorithm (Σ position × value mod 32, the one the Phase 2 seed used) missed every substitution of characters 16 apart at an even position: an exhaustive test caught "K" → "3". Luhn mod N doubles every other value as a permutation, so no single substitution goes unseen. The demo's four codes got new check characters.
- **The cancel request carries the event and type,** not only the ticket id: the fake server forgets its tickets on restart, and the place must still go back.
- **No `cancelledBy` column:** "cancelled by the organizer" is the event's status; "cancelled by you" is the ticket's `cancelledAt`. The ticket's state is derived from both.
- **The demo user's codes are checked too** (like a booking's), after the simulator showed a ticket with a pre-Luhn code.
- **A `booked` state** marks the form after the server's yes. The effect fires once, and the form stays locked while the ticket opens.

---

## 💙 Flutter / Dart Concepts Demonstrated

- **Server-confirmed writes:** no optimistic UI for a booking. The repository calls the API, checks the answer, and only then writes, inside a drift `transaction` that holds the ticket insert *and* the event's upsert. The partial unique index is the last guard against a double booking.
- **Nested transactions in drift:** `TicketsDao.book` calls `CatalogDao.upsertCatalog` (itself a transaction) inside its own; drift runs the inner one as part of the outer.
- **One-time effects from state:**
  - `ticketId` is set once;
  - `BlocListener.listenWhen: previous.ticketId == null && current.ticketId != null` navigates;
  - `TicketDetailRoute(...).pushReplacement` swaps the dialog for the ticket.
- **`RadioGroup` + `RadioListTile`** (the current Material radio API), with disabled tiles for sold-out offers.
- **`TextField(maxLength:, maxLengthEnforcement: none)`:** the counter and the over-limit styling, without silently cutting what was typed. Graphemes counted with `characters`, so an emoji is one.
- **A third-party widget on `material_ui`:**
  - `qr_flutter` builds on `flutter/material.dart`, so its white comes from an explicit `backgroundColor`, not a theme (§11.55);
  - its defaults are black squares, and a style passed with only a color turns them round (§11.75).
- **Adaptive dialogs:** `showAdaptiveDialog` + `AlertDialog.adaptive` with `CupertinoDialogAction`s on iOS (a red destructive action).
- **`FittedBox(fit: BoxFit.scaleDown)`** for a value that must stay on one line at any text size.

---

## 🔁 Data Flow (this phase)

```
RSVP dialog ─▶ RsvpCubit.confirm()
  validateRsvp(form) ─ problem ─▶ errors shown, nothing sent
  ─▶ RsvpEventUseCase: validate again against the latest cached event
  ─▶ BookingRepository.rsvp ─▶ FakeEventlyApi.rsvp (server: closed? booked already? places left?)
        ok  ─▶ BookingDto ─▶ toTicket() (code check) + toEvent() (event checks)
              ─▶ TicketsDao.book: transaction { insert ticket; upsert event + offers }
              ─▶ Ok(ticket) ─▶ status booked, ticketId ─▶ pushReplacement(TicketDetailRoute)
        err ─▶ Err(SoldOut / AlreadyBooked / BookingClosed / Network / DataFormat) ─▶ "Not booked. …"

Ticket detail ─▶ Cancel RSVP ─▶ confirm dialog ─▶ CancelRsvpUseCase (before the start only)
  ─▶ FakeEventlyApi.cancelRsvp (place back) ─▶ TicketsDao.cancel: transaction { cancelled_at; upsert event }

Agenda ─▶ ScheduleRepository.watchAgenda: events ⟕ sessions ⟕ session_bookmarks
  ─▶ buildAgenda(zone): venue days, time order, clashes among bookmarked (end-exclusive)
```

---

## 📁 Important Files Added

| File | Purpose |
|------|---------|
| `lib/domain/calculation/{ticket_codes,rsvp_validation,ticket_rules,agenda_builder}.dart` | Codes, form rules, cancel rules, agenda days and clashes. |
| `lib/domain/model/{ticket_item,agenda}.dart` | Read models. |
| `lib/core/network/dto/booking_dto.dart`, `fake_evently_api.dart` (server state) | Booking over the wire, and the server's memory. |
| `lib/core/database/daos/{tickets_dao,session_bookmarks_dao}.dart` | Booking and cancel transactions; sessions with bookmarks. |
| `lib/data/mapper/booking_mappers.dart`, `catalog_mappers.dart` (`EventDto.toEvent`) | Checking the server's answers. |
| `lib/data/repository/{booking,schedule}_repository_impl.dart` | Repositories. |
| `lib/domain/usecase/{booking,schedule}_use_cases.dart` | Use cases. |
| `lib/features/{rsvp,tickets,ticket_detail,agenda}/**` | The four screens and their Cubits. |
| `lib/core/design_system/widgets/{ticket_widgets,schedule_session_card,confirm_dialog}.dart` | Ticket card, status, QR; session card; adaptive confirm. |

---

## 🧩 Important Types Added

| Type | Kind | Responsibility | Why it lives here |
|------|------|----------------|-------------------|
| `TicketCodes` | final class | Generate and validate codes (Luhn mod N) | `domain/calculation`: pure, used by the server and the app |
| `RsvpProblem` (+ subtypes), `validateRsvp`, `RsvpRules` | sealed / function | The form's rules | `domain/calculation`: shared by form and use case |
| `TicketItem`, `TicketStatus`, `cancelBlock` | freezed / enum / function | A ticket's state; can it be cancelled | `domain` |
| `Agenda`, `AgendaDay`, `AgendaSession`, `buildAgenda`, `overlaps` | freezed / functions | Days, bookmarks, clashes | `domain` |
| `BookingDto`, `RsvpRequestDto`, `CancelRequestDto` | DTOs | The booking API | `core/network/dto` |
| `TicketsDao`, `SessionBookmarksDao` | drift accessors | Transactions; joined reads | `core/database/daos` |
| `BookingRepository`, `ScheduleRepository` | interfaces (+ impls) | Server-first booking; agenda | contracts in `domain`, impls in `data` |
| `RsvpCubit`, `TicketsCubit`, `TicketDetailCubit`, `AgendaCubit` | Cubits | The four screens | `features/*` |
| `TicketQr`, `TicketCard`, `TicketStatusLabel`, `ScheduleSessionCard`, `showConfirmDialog` | widgets | Shared UI | `core/design_system/widgets` |

---

## 🧪 Tests (666; 120 new)

| Area | New | What they pin |
|------|----:|---------------|
| Domain | 24 | Generated codes valid; **every** single substitution and neighbour swaps caught; shape; each RSVP problem and the closed reasons first; 200 graphemes (an emoji is one); ticket status and cancel rules; overlaps end-exclusive; venue days; clashes only between bookmarked sessions |
| Server and data | 29 | The server: a booking takes a place and an attendee, refuses a second booking, the demo's, sold out, a type not sold, a started or unknown event, offline; cancel gives the place back (even forgotten), never above capacity, refused after the start. The DAO: book and cancel in one transaction (a refused event write takes the ticket with it), cancelling twice. The repository: success; offline, refused or damaged answers writing nothing; cancel and cancel offline. The schedule. The demo's codes checked |
| Use cases | 7 | No type, a long note, already going: refused before the server is asked; not cached; the note trimmed; cancel refused after the start |
| RSVP | 19 | The Cubit: no type for several offers, preselected for one, errors only after Confirm, the effect once and the form locked after, offline then Try again, no double send, going closed, not found. The view: offers, disabled sold-out, total, errors, submitting, failure, closed, booked |
| Tickets and Ticket detail | 18 | Upcoming / past and a new booking joining; the four states in words; empty and Past tab; the QR and its label, white in the dark theme; cancel asking first; no QR or Cancel once cancelled; no Cancel after the start; cancelling; not found |
| Agenda | 11 | The Cubit: first day, another day, My sessions, a bookmark ending a clash, a failed bookmark, not found. The view: the venue's clock, clashes both ways, chips, star tooltips per session, empty My sessions, one-day events, no agenda |
| Flows | 4 | Book from the event → the ticket replaces the dialog → Back to the event, going; offline booking fails, Try again books; cancel from a deep-linked ticket → on Tickets too; bookmark → My sessions |
| Accessibility tour | 8 | RSVP with errors, RSVP closed, a past ticket, Tickets → Past; both themes at 200 % |

**Mutation checks (24), each caught:**
- Luhn without doubling;
- validation missing sold-out types, or counting UTF-16 units;
- the organizer's cancellation hiding yours;
- cancelling after the start;
- clashes end-inclusive, or between sessions not bookmarked;
- the agenda on UTC's days;
- the server allowing two bookings, taking no place, or booking a started event;
- the booking outside a transaction, or without the event's counts;
- the server's code unchecked;
- the use case not validating;
- the form unlocked after booking;
- no field errors before sending;
- no preselected single type;
- the ticket pushed over the form instead of replacing it;
- cancelling without asking;
- a QR on a cancelled ticket, or not on white;
- My sessions showing everything;
- Past tickets dropped.

---

## 🤖🍏 Android / iOS Comparison

From the two native specs:

| Concept | Android (Kotlin) | iOS (Swift) | Flutter (Dart) |
|---|---|---|---|
| RSVP | ticket type, note, **fake booking confirmation**, validation, loading, one-time navigation | the same | **server-confirmed**: the fake server checks places, status and duplicates; no ticket until it answers; ticket and counts in one transaction; the ticket replaces the form |
| RSVP storage | `RsvpEntity` and `TicketEntity` | ticket | one `tickets` table: the ticket *is* the RSVP, one active per event (partial unique index) |
| Ticket | `qrCodeText`, a QR placeholder | the same | a real QR (`qr_flutter`) of an `EVT-XXXX-XXXX` code with a Luhn check character, labelled for screen readers |
| Ticket states | — | — | confirmed, moved, cancelled by the organizer, cancelled by you |
| Cancel RSVP | `cancelRsvp(eventId)` | the same | server first, only before the start, with an adaptive confirm dialog |
| Agenda | sessions by day, bookmarks, filter by day | the same | days in the **venue's** zone, bookmarks as a user table, **clashes** between bookmarked sessions, My sessions |
| Tests | — | ticket generation, cancel | codes exhaustively, validation, the server's rules, transactions, every screen, flows, the tour, mutation checks |

Both native specs fake the booking in the app ("fake booking confirmation"). The Flutter edition moves that decision to the (fake) server and writes nothing until it answers. That's the shape a real backend needs, and a failure can't leave a ticket behind.

---

## 🎤 Interview Notes

**Q: Why not show the ticket at once and roll back if the server says no?**
A: Because a ticket is a promise of a place, and only the server can make it. An optimistic ticket would be visible (and screenshot-able, QR and all) before it exists. Saves and bookmarks are optimistic in effect (they're local, the user's own notes); bookings aren't.

**Q: How do you keep the ticket and the place count consistent?**
A: Both come from the server's single answer and are written in one drift transaction. Either both land or neither does, and a test proves the ticket disappears when the event write is refused.

**Q: Why a check character, and why Luhn mod N?**
A: A code read aloud at a door or typed from a screenshot gets mistyped; a check character catches it before any lookup. A plain weighted sum mod 32 misses some substitutions (even weights times 16 is 0 mod 32), which an exhaustive test found. Luhn mod N doubles every other value in a way that stays a permutation, so every single substitution is caught.

**Q: How does the RSVP dialog navigate exactly once?**
A: The Cubit sets `ticketId` once, in a `booked` state that also locks the form. A `BlocListener` fires only on its null → value change and calls `pushReplacement`, so Back returns to the event, not to a finished form.

---

## 📝 Learning Checklist

- ✅ Write only what the server confirmed, and write it atomically
- ✅ Validate twice (form and use case), and let the server have the last word
- ✅ Fire a navigation effect once, from state
- ✅ Generate and validate codes with a check character, and test it exhaustively
- ✅ Use a third-party widget on `material_ui` safely
- ✅ Group by the venue's days and detect overlaps end-exclusively
- ⬜ Organizers, profile and settings (Phase 6)

---

## 🚀 Future Improvements

- **Phase 6:** organizers and Following, the profile and Edit profile, Settings (appearance, dynamic color, preferred city, clear cache, reset demo data, developer tools).
- **Later:** add a ticket to Apple Wallet / Google Wallet; a "Scan at the door" mode for organizers that validates codes.
