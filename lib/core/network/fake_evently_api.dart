import 'dart:math';

import 'package:clock/clock.dart';
import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/core/network/seed_renderer.dart';
import 'package:evently/domain/calculation/ticket_codes.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:injectable/injectable.dart';

/// Plays the server: renders its seed files as of now ([SeedRenderer])
/// after a simulated network delay (700 ms) that can also fail on request.
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
@LazySingleton(as: EventlyApi)
class FakeEventlyApi implements EventlyApi {
  FakeEventlyApi(
    this._json,
    this._network,
    this._clock, {
    @ignoreParam Random? random,
  }) : _random = random ?? Random();

  static const catalogPath = 'assets/json/catalog_seed.json';
  static const demoUserPath = 'assets/json/demo_user.json';

  final AssetJsonLoader _json;
  final NetworkSimulator _network;
  final Clock _clock;
  final Random _random;

  /// Places taken since launch, by "eventId/type".
  final _taken = <String, int>{};

  /// Active tickets the server knows, by event id.
  final _activeTicketByEvent = <String, String>{};

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
      SeedRenderer.demoUser(seed, _clock.now()),
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

  /// The catalog as of now, with the places taken since launch applied.
  Future<Map<String, dynamic>> _catalogJson() async {
    final seed = await _json.loadObject(catalogPath);
    final catalog = SeedRenderer.catalog(seed, _clock.now());
    for (final event
        in (catalog['events']! as List).cast<Map<String, dynamic>>()) {
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

  Future<Map<String, dynamic>?> _eventJson(String eventId) async {
    final events = ((await _catalogJson())['events']! as List)
        .cast<Map<String, dynamic>>();
    return events.where((e) => e['id'] == eventId).firstOrNull;
  }

  static List<Map<String, dynamic>> _offers(Map<String, dynamic> event) =>
      (event['offers']! as List).cast<Map<String, dynamic>>();
}
