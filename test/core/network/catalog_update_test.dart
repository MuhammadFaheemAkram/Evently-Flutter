import 'package:clock/clock.dart';
import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

// The developer's "Publish a catalog update", on the fake server.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeEventlyApi server;

  setUp(() {
    server = FakeEventlyApi(
      AssetJsonLoader(rootBundle),
      NetworkSimulator(latency: Duration.zero),
      Clock.fixed(demoNow),
    );
  });

  EventDto find(CatalogDto catalog, String id) =>
      catalog.events.singleWhere((e) => e.id == id);

  test('before publishing, nothing has changed', () async {
    final catalog = await server.fetchCatalog();

    expect(catalog.events, hasLength(25));
    expect(
      catalog.events.every((e) => e.status == EventStatus.scheduled),
      isTrue,
    );
  });

  test('says what it changed', () async {
    expect(
      await server.publishUpdate(),
      '1 moved, 1 cancelled, 1 edited, 2 new',
    );
  });

  test(
    'after: one event a day later and marked moved, with where it was',
    () async {
      final before = find(await server.fetchCatalog(), 'ev_design_conf');

      await server.publishUpdate();
      final after = find(await server.fetchCatalog(), 'ev_design_conf');

      expect(after.status, EventStatus.moved);
      expect(after.previousStartsAt, before.startsAt);
      expect(
        after.startsAt.difference(before.startsAt),
        const Duration(days: 1),
      );
      // Its sessions move with it.
      expect(
        after.sessions.first.startsAt.difference(
          before.sessions.first.startsAt,
        ),
        const Duration(days: 1),
      );
    },
  );

  test('one cancelled, one edited, two new; the catalog still passes every '
      'check', () async {
    await server.publishUpdate();
    final catalog = await server.fetchCatalog();

    expect(
      find(catalog, 'ev_dart_patterns_live').status,
      EventStatus.cancelled,
    );
    expect(
      find(catalog, 'ev_ai_summit').description,
      endsWith('closing panel on regulation.'),
    );
    expect(catalog.events, hasLength(27));
    expect(find(catalog, 'ev_flutter_hack_night').featured, isTrue);
    expect(catalog.toCatalog().events, hasLength(27));
    final organizer = catalog.organizers.singleWhere(
      (o) => o.id == 'org_flutter_london',
    );
    expect(organizer.eventsCount, 6);
  });

  test('a cancelled event can no longer be booked', () async {
    await server.publishUpdate();

    await expectLater(
      server.rsvp(
        const RsvpRequestDto(
          eventId: 'ev_dart_patterns_live',
          type: TicketType.free,
        ),
      ),
      throwsA(isA<BookingClosedException>()),
    );
  });
}
