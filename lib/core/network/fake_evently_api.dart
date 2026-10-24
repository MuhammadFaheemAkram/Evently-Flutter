import 'dart:math';

import 'package:clock/clock.dart';
import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/demo_calendar.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/core/network/seed_renderer.dart';
import 'package:evently/domain/calculation/ticket_codes.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:injectable/injectable.dart';

/// Plays the server: renders its seed files from its calendar's anchor
/// ([SeedRenderer], [DemoCalendar]) after a simulated network delay
/// (700 ms) that can also fail on request.
///
/// It also keeps the server's own state, in memory, reset on every launch
/// (a fake backend only shows how the app talks to one):
/// - **places taken** per event and ticket type, applied to every catalog
///   it serves (places left, attendee counts);
/// - **the tickets it issued** (and the demo user's, once fetched), so it
///   refuses a second booking for the same event, as a real one would.
///
/// A booking is checked here too, whatever the app already checked: the
/// event exists and isn't cancelled or started, the type is sold, a place
/// is left, and you aren't going already.
@lazySingleton
class FakeEventlyApi implements EventlyApi {
  FakeEventlyApi(
    this._json,
    this._network,
    this._clock,
    this._calendar, {
    @ignoreParam Random? random,
  }) : _random = random ?? Random();

  static const catalogPath = 'assets/json/catalog_seed.json';
  static const demoUserPath = 'assets/json/demo_user.json';
  static const updatePath = 'assets/json/catalog_update.json';

  final AssetJsonLoader _json;
  final NetworkSimulator _network;
  final Clock _clock;
  final DemoCalendar _calendar;
  final Random _random;

  /// Places taken since launch, by "eventId/type".
  final _taken = <String, int>{};

  /// Active tickets the server knows, by event id.
  final _activeTicketByEvent = <String, String>{};

  /// Whether the developer published the catalog update.
  var _updated = false;

  /// From now on, every catalog includes `catalog_update.json`: an event
  /// moves (a day later), another is cancelled, one is edited, and new ones
  /// appear. In memory, like the rest: a restart takes it back.
  ///
  /// Returns what changed, for the developer's SnackBar.
  Future<String> publishUpdate() async {
    final update = await _json.loadObject(updatePath);
    _updated = true;
    int count(String key) => (update[key]! as List).length;
    return '${count('moves')} moved, ${count('cancels')} cancelled, '
        '${count('edits')} edited, ${count('events')} new';
  }

  @override
  Future<CatalogDto> fetchCatalog() async {
    await _network();
    return CatalogDto.fromJson(await _catalogJson());
  }

  @override
  Future<DemoUserDto> fetchDemoUser() async {
    await _network();
    final seed = await _json.loadObject(demoUserPath);
    final user = DemoUserDto.fromJson(
      SeedRenderer.demoUser(seed, _calendar.anchor()),
    );
    // The demo's tickets were "issued" by this server: the seed's places
    // left already count them.
    for (final ticket in user.tickets) {
      _activeTicketByEvent[ticket.eventId] = ticket.id;
    }
    return user;
  }

  @override
  Future<BookingDto> rsvp(RsvpRequestDto request) async {
    await _network();
    final event = await _eventJson(request.eventId);
    final now = _clock.now();
    if (event == null || event['status'] == EventStatus.cancelled.name) {
      throw const BookingClosedException('This event was cancelled.');
    }
    if (!now.isBefore(DateTime.parse(event['startsAt']! as String))) {
      throw const BookingClosedException('Bookings closed when it started.');
    }
    if (_activeTicketByEvent.containsKey(request.eventId)) {
      throw const AlreadyBookedException();
    }
    final offer = _offers(event).where((o) => o['type'] == request.type.name);
    if (offer.isEmpty || (offer.single['remaining']! as int) <= 0) {
      throw const SoldOutException();
    }

    final code = TicketCodes.generate(_random);
    final ticketId = 'tkt_${code.replaceAll('-', '').toLowerCase()}';
    _take(request.eventId, request.type, 1);
    _activeTicketByEvent[request.eventId] = ticketId;
    return BookingDto.fromJson({
      'ticket': {
        'id': ticketId,
        'eventId': request.eventId,
        'code': code,
        'type': request.type.name,
        'note': request.note.trim(),
        'bookedAt': now.toUtc().toIso8601String(),
      },
      'event': (await _eventJson(request.eventId))!,
    });
  }

  @override
  Future<EventDto> cancelRsvp(CancelRequestDto request) async {
    await _network();
    final event = await _eventJson(request.eventId);
    if (event == null) throw const NotFoundException('event');
    if (!_clock.now().isBefore(DateTime.parse(event['startsAt']! as String))) {
      throw const BookingClosedException(
        'A place can only be given back before the event starts.',
      );
    }
    if (_activeTicketByEvent[request.eventId] == request.ticketId ||
        !_activeTicketByEvent.containsKey(request.eventId)) {
      _activeTicketByEvent.remove(request.eventId);
      _take(request.eventId, request.type, -1);
    }
    return EventDto.fromJson((await _eventJson(request.eventId))!);
  }

  void _take(String eventId, TicketType type, int places) {
    final key = '$eventId/${type.name}';
    _taken[key] = (_taken[key] ?? 0) + places;
  }

  /// The catalog: the seed from the calendar's anchor (with the update,
  /// once published), and the places taken since launch.
  Future<Map<String, dynamic>> _catalogJson() async {
    final seed = await _json.loadObject(catalogPath);
    final anchor = _calendar.anchor();
    final Map<String, dynamic> catalog;
    if (_updated) {
      // Where the moved events were, before they moved.
      final before = _byId(SeedRenderer.catalog(seed, anchor));
      final update = await _json.loadObject(updatePath);
      catalog = SeedRenderer.catalog(_applyUpdate(seed, update), anchor);
      _markChanges(catalog, update, before);
    } else {
      catalog = SeedRenderer.catalog(seed, anchor);
    }
    for (final event in _events(catalog)) {
      final offers = _offers(event);
      for (final offer in offers) {
        final taken = _taken['${event['id']}/${offer['type']}'] ?? 0;
        final capacity = offer['capacity']! as int;
        offer['remaining'] = ((offer['remaining']! as int) - taken).clamp(
          0,
          capacity,
        );
      }
      event['attendeeCount'] = offers.fold<int>(
        0,
        (sum, o) => sum + (o['capacity']! as int) - (o['remaining']! as int),
      );
    }
    return catalog;
  }

  /// The seed with the update applied: moved events start (and end) later
  /// by whole days, and the new events added.
  static Map<String, dynamic> _applyUpdate(
    Map<String, dynamic> seed,
    Map<String, dynamic> update,
  ) {
    final moves = {
      for (final move in _list(update['moves']))
        move['eventId']! as String: move['byDays']! as int,
    };
    final edits = {
      for (final edit in _list(update['edits']))
        edit['eventId']! as String: edit['description']! as String,
    };
    Map<String, dynamic> shifted(Map<String, dynamic> at, int days) => {
      ...at,
      'inDays': (at['inDays']! as int) + days,
    };
    return {
      ...seed,
      'events': [
        for (final event in _list(seed['events']))
          {
            ...event,
            if (moves[event['id']] case final days?) ...{
              'starts': shifted(event['starts']! as Map<String, dynamic>, days),
              'ends': shifted(event['ends']! as Map<String, dynamic>, days),
            },
            // Left out when there's no edit: the seed's stays.
            'description': ?edits[event['id']],
          },
        ..._list(update['events']),
      ],
    };
  }

  /// The organizer's word on the changed events: moved (with where they
  /// were) or cancelled.
  static void _markChanges(
    Map<String, dynamic> catalog,
    Map<String, dynamic> update,
    Map<String, Map<String, dynamic>> before,
  ) {
    final moved = {
      for (final move in _list(update['moves'])) move['eventId']! as String,
    };
    final cancelled = {...(update['cancels']! as List).cast<String>()};
    for (final event in _events(catalog)) {
      final id = event['id']! as String;
      if (cancelled.contains(id)) {
        event['status'] = EventStatus.cancelled.name;
      } else if (moved.contains(id)) {
        event['status'] = EventStatus.moved.name;
        event['previousStartsAt'] = before[id]!['startsAt'];
      }
    }
  }

  static Map<String, Map<String, dynamic>> _byId(
    Map<String, dynamic> catalog,
  ) => {for (final event in _events(catalog)) event['id']! as String: event};

  static List<Map<String, dynamic>> _events(Map<String, dynamic> catalog) =>
      (catalog['events']! as List).cast<Map<String, dynamic>>();

  static List<Map<String, dynamic>> _list(Object? json) =>
      ((json as List?) ?? const []).cast<Map<String, dynamic>>();

  Future<Map<String, dynamic>?> _eventJson(String eventId) async {
    final events = ((await _catalogJson())['events']! as List)
        .cast<Map<String, dynamic>>();
    return events.where((e) => e['id'] == eventId).firstOrNull;
  }

  static List<Map<String, dynamic>> _offers(Map<String, dynamic> event) =>
      (event['offers']! as List).cast<Map<String, dynamic>>();
}
