import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/catalog_dao.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/organizer.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:timezone/timezone.dart' as tz;

// The catalog's three shapes, and the ways between them:
// - DTO → domain: checked first, so damaged data never reaches the cache;
// - domain → rows: what a refresh writes;
// - rows → domain: what the screens read (from Phase 3).

extension CatalogDtoToDomain on CatalogDto {
  /// The catalog, after checking every rule a type can't express. Throws a
  /// [FormatException] naming the first one broken; nothing is written.
  ///
  /// - ids are unique, every event's organizer exists;
  /// - each event ends after it starts, in a time zone the database knows;
  /// - a venue (named, with a city) or an https join link, never both;
  /// - at least one ticket type, each once, with a price ≥ 0, a currency
  ///   code, and 0 ≤ places left ≤ places; attendees ≤ capacity;
  /// - a moved event says when it was, and only a moved one;
  /// - sessions fall within their event, and end after they start.
  ///
  /// Instants are kept in UTC: the API sends them with the venue's offset.
  Catalog toCatalog() {
    void check(bool condition, String problem) {
      if (!condition) throw FormatException('Catalog: $problem');
    }

    final organizerIds = <String>{};
    for (final organizer in organizers) {
      check(organizerIds.add(organizer.id), 'organizer ${organizer.id} twice');
      check(organizer.name.trim().isNotEmpty, '${organizer.id} has no name');
      check(
        organizer.followers >= 0 && organizer.eventsCount >= 0,
        '${organizer.id} has a negative count',
      );
    }

    final eventIds = <String>{};
    final sessionIds = <String>{};
    final domainEvents = <Event>[];
    final domainSessions = <ScheduleSession>[];
    for (final event in events) {
      final id = event.id;
      check(eventIds.add(id), 'event $id twice');
      check(event.title.trim().isNotEmpty, '$id has no title');
      check(
        organizerIds.contains(event.organizerId),
        '$id names an unknown organizer',
      );
      try {
        tz.getLocation(event.timeZone);
      } on tz.LocationNotFoundException {
        check(false, '$id is in an unknown time zone, ${event.timeZone}');
      }
      final start = event.startsAt.toUtc();
      final end = event.endsAt.toUtc();
      check(end.isAfter(start), '$id ends before it starts');

      final venue = event.venue;
      final joinUrl = event.joinUrl;
      check(
        (venue == null) != (joinUrl == null),
        '$id needs a venue or a join link, not both',
      );
      final EventLocation location;
      if (venue != null) {
        check(
          venue.name.trim().isNotEmpty && venue.city.trim().isNotEmpty,
          "$id's venue needs a name and a city",
        );
        location = EventLocation.venue(
          name: venue.name,
          address: venue.address,
          city: venue.city,
        );
      } else {
        final uri = Uri.tryParse(joinUrl!);
        check(
          uri != null && uri.isScheme('https') && uri.host.isNotEmpty,
          "$id's join link isn't an https address",
        );
        location = EventLocation.online(joinUrl: uri!);
      }

      check(event.capacity > 0, '$id has no places');
      check(
        event.attendeeCount >= 0 && event.attendeeCount <= event.capacity,
        '$id has more attendees than places',
      );
      check(event.offers.isNotEmpty, '$id sells no tickets');
      final types = <TicketType>{};
      for (final offer in event.offers) {
        check(types.add(offer.type), '$id sells ${offer.type.name} twice');
        check(offer.priceMinor >= 0, "$id's ${offer.type.name} costs < 0");
        check(
          RegExp(r'^[A-Z]{3}$').hasMatch(offer.currency),
          "$id's ${offer.type.name} has no currency code",
        );
        check(
          offer.capacity > 0 &&
              offer.remaining >= 0 &&
              offer.remaining <= offer.capacity,
          "$id's ${offer.type.name} has impossible places",
        );
      }
      check(
        (event.status == EventStatus.moved) == (event.previousStartsAt != null),
        '$id: only a moved event has a previous start',
      );

      for (final session in event.sessions) {
        final sessionStart = session.startsAt.toUtc();
        final sessionEnd = session.endsAt.toUtc();
        check(sessionIds.add(session.id), 'session ${session.id} twice');
        check(session.title.trim().isNotEmpty, '${session.id} has no title');
        check(
          sessionEnd.isAfter(sessionStart),
          '${session.id} ends before it starts',
        );
        check(
          !sessionStart.isBefore(start) && !sessionEnd.isAfter(end),
          '${session.id} falls outside $id',
        );
        domainSessions.add(
          ScheduleSession(
            id: session.id,
            eventId: id,
            title: session.title,
            speaker: session.speaker,
            room: session.room,
            start: sessionStart,
            end: sessionEnd,
          ),
        );
      }

      domainEvents.add(
        Event(
          id: id,
          title: event.title,
          description: event.description,
          category: event.category,
          organizerId: event.organizerId,
          time: EventTime(start: start, end: end, zone: event.timeZone),
          location: location,
          featured: event.featured,
          attendeeCount: event.attendeeCount,
          capacity: event.capacity,
          status: event.status,
          previousStart: event.previousStartsAt?.toUtc(),
          offers: [
            for (final offer in event.offers)
              TicketOffer(
                type: offer.type,
                priceMinor: offer.priceMinor,
                currency: offer.currency,
                capacity: offer.capacity,
                remaining: offer.remaining,
              ),
          ],
        ),
      );
    }

    return Catalog(
      organizers: [
        for (final organizer in organizers)
          Organizer(
            id: organizer.id,
            name: organizer.name,
            bio: organizer.bio,
            followers: organizer.followers,
            eventsCount: organizer.eventsCount,
          ),
      ],
      events: domainEvents,
      sessions: domainSessions,
    );
  }
}

extension CatalogToRows on Catalog {
  CatalogRows toRows() => CatalogRows(
    organizers: [for (final organizer in organizers) organizer.toRow()],
    events: [for (final event in events) event.toRow()],
    offers: [
      for (final event in events)
        for (final (index, offer) in event.offers.indexed)
          TicketOfferRow(
            eventId: event.id,
            type: offer.type,
            priceMinor: offer.priceMinor,
            currency: offer.currency,
            capacity: offer.capacity,
            remaining: offer.remaining,
            sortOrder: index,
          ),
    ],
    sessions: [for (final session in sessions) session.toRow()],
  );
}

extension on Organizer {
  OrganizerRow toRow() => OrganizerRow(
    id: id,
    name: name,
    bio: bio,
    followers: followers,
    eventsCount: eventsCount,
  );
}

extension EventToRow on Event {
  EventRow toRow() {
    final (venueName, venueAddress, city, joinUrl) = switch (location) {
      Venue(:final name, :final address, :final city) => (
        name,
        address,
        city,
        null,
      ),
      Online(:final joinUrl) => (null, null, null, joinUrl),
    };
    return EventRow(
      id: id,
      title: title,
      description: description,
      category: category,
      organizerId: organizerId,
      startsAt: time.start,
      endsAt: time.end,
      timeZone: time.zone,
      venueName: venueName,
      venueAddress: venueAddress,
      city: city,
      joinUrl: joinUrl,
      featured: featured,
      attendeeCount: attendeeCount,
      capacity: capacity,
      status: status,
      previousStartsAt: previousStart,
    );
  }
}

extension on ScheduleSession {
  SessionRow toRow() => SessionRow(
    id: id,
    eventId: eventId,
    title: title,
    speaker: speaker,
    room: room,
    startsAt: start,
    endsAt: end,
  );
}

extension OrganizerRowToDomain on OrganizerRow {
  Organizer toDomain() => Organizer(
    id: id,
    name: name,
    bio: bio,
    followers: followers,
    eventsCount: eventsCount,
  );
}

extension EventRowToDomain on EventRow {
  /// The event, with [offers] (its rows, in any order: they are put in the
  /// server's order). The table's `CHECK` guarantees a venue's columns or a
  /// link.
  Event toDomain(Iterable<TicketOfferRow> offers) => Event(
    id: id,
    title: title,
    description: description,
    category: category,
    organizerId: organizerId,
    time: EventTime(start: startsAt, end: endsAt, zone: timeZone),
    location: joinUrl == null
        ? EventLocation.venue(
            name: venueName!,
            address: venueAddress!,
            city: city!,
          )
        : EventLocation.online(joinUrl: joinUrl!),
    featured: featured,
    attendeeCount: attendeeCount,
    capacity: capacity,
    status: status,
    previousStart: previousStartsAt,
    offers: [
      for (final offer
          in offers.toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)))
        TicketOffer(
          type: offer.type,
          priceMinor: offer.priceMinor,
          currency: offer.currency,
          capacity: offer.capacity,
          remaining: offer.remaining,
        ),
    ],
  );
}

extension SessionRowToDomain on SessionRow {
  ScheduleSession toDomain() => ScheduleSession(
    id: id,
    eventId: eventId,
    title: title,
    speaker: speaker,
    room: room,
    start: startsAt,
    end: endsAt,
  );
}

extension CatalogRowsToDomain on CatalogRows {
  /// The whole cached catalog (for round-trip tests; screens read slices).
  Catalog toCatalog() {
    final offersByEvent = <String, List<TicketOfferRow>>{};
    for (final offer in offers) {
      (offersByEvent[offer.eventId] ??= []).add(offer);
    }
    return Catalog(
      organizers: [for (final row in organizers) row.toDomain()],
      events: [
        for (final row in events) row.toDomain(offersByEvent[row.id] ?? []),
      ],
      sessions: [for (final row in sessions) row.toDomain()],
    );
  }
}
