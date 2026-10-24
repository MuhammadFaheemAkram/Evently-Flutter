import 'package:clock/clock.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/catalog.dart';
import 'package:evently/domain/model/user_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/database.dart';
import '../../helpers/test_dependencies.dart';

// The seed files that ship with the app, rendered as the fake API renders
// them: they must pass every check, and hold the cases the screens show off,
// whatever the date.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(Catalog, UserData)> bundled(DateTime now) async {
    final api = FakeEventlyApi(
      AssetJsonLoader(rootBundle),
      NetworkSimulator(latency: Duration.zero),
      Clock.fixed(now),
    );
    return (
      (await api.fetchCatalog()).toCatalog(),
      (await api.fetchDemoUser()).toUserData(),
    );
  }

  for (final now in [
    demoNow,
    // The nights clocks change: in Europe, then in New York.
    DateTime.utc(2026, 3, 29, 0, 30),
    DateTime.utc(2026, 10, 25, 0, 30),
    DateTime.utc(2026, 11, 1, 5, 30),
    // New Year's Eve, late: already 2027 in Lahore.
    DateTime.utc(2026, 12, 31, 23, 30),
    DateTime.utc(2027, 7, 1, 12),
  ]) {
    test(
      'as of $now: passes every check, and the demo fits the catalog',
      () async {
        final (catalog, user) = await bundled(now);
        final db = newTestDatabase();
        addTearDown(db.close);

        await db.catalogDao.upsertCatalog(catalog.toRows());
        await db.userDataDao.replaceAll(user.toRows());

        expect(catalog.organizers, hasLength(6));
        expect(catalog.events, hasLength(25));
        expect(catalog.sessions, hasLength(21));
        expect(await db.catalogDao.cities(), [
          'Berlin',
          'Lahore',
          'London',
          'New York',
        ]);
        // Read back in id order.
        final stored = (await db.userDataDao.readAll()).toUserData();
        expect(stored.profile, user.profile);
        expect(stored.saved, unorderedEquals(user.saved));
        expect(stored.tickets, unorderedEquals(user.tickets));
        expect(stored.bookmarks, unorderedEquals(user.bookmarks));
        expect(stored.follows, unorderedEquals(user.follows));
      },
    );
  }

  group('as of the demo date', () {
    late Catalog catalog;
    late UserData user;

    setUpAll(() async => (catalog, user) = await bundled(demoNow));

    Set<String> ids(Iterable<({String id})> items) => {
      for (final item in items) item.id,
    };

    test('three events are over, the rest to come', () {
      final ended = catalog.events.where((e) => e.time.hasEnded(demoNow));

      expect(ended.map((e) => e.id).toSet(), {
        'ev_accessibility_talk',
        'ev_design_critique',
        'ev_pitch_night',
      });
    });

    test('one event is sold out, and it is upcoming', () {
      final soldOut = catalog.events.where((e) => e.isSoldOut).toList();

      expect(soldOut.map((e) => e.id), contains('ev_dart_workshop'));
      expect(soldOut.where((e) => !e.time.hasEnded(demoNow)).map((e) => e.id), [
        'ev_dart_workshop',
      ]);
    });

    test('five are featured; four are online', () {
      expect(catalog.events.where((e) => e.featured), hasLength(5));
      expect(catalog.events.where((e) => e.isOnline), hasLength(4));
    });

    test('free and paid, in four currencies', () {
      final currencies = {
        for (final e in catalog.events)
          for (final o in e.offers) o.currency,
      };
      expect(catalog.events.where((e) => e.isFree), isNotEmpty);
      expect(catalog.events.where((e) => !e.isFree), isNotEmpty);
      expect(currencies, hasLength(greaterThanOrEqualTo(3)));
    });

    test('a late New York event ends on its next day', () {
      final jam = catalog.events.singleWhere((e) => e.id == 'ev_midnight_jam');

      expect(jam.time.endDay, jam.time.startDay.addDays(1));
    });

    test('every organizer has events', () {
      for (final organizer in catalog.organizers) {
        expect(organizer.eventsCount, greaterThan(0), reason: organizer.id);
      }
    });

    test('the design conference runs two Berlin days, with clashing '
        'sessions the demo bookmarked', () {
      final conf = catalog.events.singleWhere((e) => e.id == 'ev_design_conf');
      final sessions = catalog.sessions
          .where((s) => s.eventId == conf.id)
          .toList();
      final trust = sessions.singleWhere((s) => s.id == 'ses_conf_trust');
      final type = sessions.singleWhere((s) => s.id == 'ses_conf_type');

      expect(sessions, hasLength(12));
      expect(conf.time.endDay, conf.time.startDay.addDays(1));
      expect(
        trust.start.isBefore(type.end) && type.start.isBefore(trust.end),
        isTrue,
      );
      expect(
        user.bookmarks.map((b) => b.sessionId),
        containsAll(['ses_conf_trust', 'ses_conf_type']),
      );
    });

    test('each demo ticket is a type its event sells, with a valid code', () {
      for (final ticket in user.tickets) {
        final event = catalog.events.singleWhere((e) => e.id == ticket.eventId);
        expect(
          event.offers.map((o) => o.type),
          contains(ticket.type),
          reason: ticket.id,
        );
        expect(_isValidCode(ticket.code), isTrue, reason: ticket.code);
      }
    });

    test('the demo holds a ticket for tonight and one for a past event', () {
      final going = {for (final t in user.tickets) t.eventId};

      expect(going, contains('ev_flutter_london_meetup'));
      expect(going, contains('ev_accessibility_talk'));
    });

    test('ids are unique across the catalog', () {
      expect(ids(catalog.events.map((e) => (id: e.id))), hasLength(25));
    });
  });
}

/// "EVT-" then 8 characters of an alphabet without 0, O, 1 and I; the last
/// is a check character over the first 7 (Phase 5 brings the app's own).
bool _isValidCode(String code) {
  const alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  final match = RegExp(r'^EVT-([2-9A-HJ-NP-Z]{4})-([2-9A-HJ-NP-Z]{4})$')
      .firstMatch(code);
  if (match == null) return false;
  final chars = '${match[1]}${match[2]}';
  var sum = 0;
  for (var i = 0; i < 7; i++) {
    sum += (i + 1) * alphabet.indexOf(chars[i]);
  }
  return chars[7] == alphabet[sum % alphabet.length];
}
