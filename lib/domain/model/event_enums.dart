/// The eight categories an event can be in. The design system draws each by
/// its [name] (`CategoryPalette`), so the API's value, the database's and the
/// palette's key are the same string.
enum EventCategory {
  technology('Technology'),
  business('Business'),
  design('Design'),
  sports('Sports'),
  education('Education'),
  music('Music'),
  community('Community'),
  health('Health');

  const EventCategory(this.label);

  final String label;
}

/// The kinds of ticket an event can offer. Each event offers some of them,
/// each with its own price and number of places (`TicketOffer`).
enum TicketType {
  free('Free'),
  standard('Standard'),
  vip('VIP'),
  workshop('Workshop pass');

  const TicketType(this.label);

  final String label;
}

/// Where an event stands, as the organizer last said.
enum EventStatus {
  /// On, at its original time.
  scheduled,

  /// On, at a new time (the event keeps the time it moved from).
  moved,

  /// Off. It stays in the catalog, so a ticket for it can say so.
  cancelled,
}

/// What a sync noticed about an event you hold a ticket for (Phase 7's
/// alerts).
enum EventChangeKind { moved, cancelled }
