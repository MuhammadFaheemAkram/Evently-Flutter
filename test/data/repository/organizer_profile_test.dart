import 'package:evently/core/common/app_exception.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/result_matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  setUp(() async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
  });

  group('organizers', () {
    test('one organizer: followed by the demo, with their events', () async {
      final details = (await stack.watchOrganizer('org_berlin_design').first)!;

      expect(details.organizer.name, 'Berlin Design Collective');
      expect(details.isFollowing, isTrue);
      expect(details.events, hasLength(5));
      expect(
        details.events.every((e) => e.event.organizerId == 'org_berlin_design'),
        isTrue,
      );
    });

    test('follow and unfollow, live', () async {
      final seen = <bool>[];
      final subscription = stack
          .watchOrganizer('org_soundwaves')
          .listen((d) => seen.add(d!.isFollowing));
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      expect(
        await stack.setFollowing('org_soundwaves', following: true),
        isOk(),
      );
      await pumpEventQueue();
      await stack.setFollowing('org_soundwaves', following: false);
      await pumpEventQueue();

      expect(seen, [false, true, false]);
    });

    test('an unknown organizer: null; following one fails cleanly', () async {
      expect(await stack.watchOrganizer('org_nowhere').first, isNull);
      expect(
        await stack.setFollowing('org_nowhere', following: true),
        isErr<UnknownException>(),
      );
    });

    test('Following: A to Z, each with their soonest event not over', () async {
      final following = await stack.watchFollowing().first;

      expect(
        [for (final f in following) f.organizer.id],
        ['org_berlin_design', 'org_flutter_london'],
      );
      final flutterLondon = following.last;
      expect(flutterLondon.nextEvent?.event.id, 'ev_flutter_london_meetup');
    });

    test('an organizer whose events are all over: no next event', () async {
      final fresh = DataStack();
      addTearDown(fresh.close);
      await fresh.db.catalogDao.upsertCatalog(
        catalogOf([
          event(
            time: EventTime(
              start: DateTime.utc(2026, 10, 1, 18),
              end: DateTime.utc(2026, 10, 1, 20),
              zone: 'Europe/London',
            ),
          ),
        ]).toRows(),
      );
      await fresh.setFollowing('org_1', following: true);

      final following = await fresh.watchFollowing().first;

      expect(following.single.organizer.id, 'org_1');
      expect(following.single.nextEvent, isNull);
    });

    test("a cancelled event is nobody's next event", () async {
      // 21:30 in London: tonight's meetup is over, so Flutter London's
      // soonest event is Dart 3 Patterns, which the update cancels.
      final later = DataStack(now: DateTime.utc(2026, 10, 21, 20, 30));
      addTearDown(later.close);
      await later.loadDemo();
      expect(
        (await later.watchFollowing().first).last.nextEvent?.event.id,
        'ev_dart_patterns_live',
      );

      await later.developer.publishCatalogUpdate();
      await later.catalog.refresh();

      final next = (await later.watchFollowing().first).last.nextEvent;
      expect(next, isNotNull);
      expect(next!.event.id, isNot('ev_dart_patterns_live'));
    });

    test('unfollowing takes an organizer off Following', () async {
      await stack.setFollowing('org_berlin_design', following: false);

      final following = await stack.watchFollowing().first;
      expect(
        [for (final f in following) f.organizer.id],
        ['org_flutter_london'],
      );
    });
  });

  group('profile', () {
    test("the demo's, then saved", () async {
      expect(
        await stack.watchProfile().first,
        const UserProfile(name: 'Sara Ahmed', email: 'sara.ahmed@example.com'),
      );

      expect(
        await stack.updateProfile(
          name: '  Sara A. ',
          email: ' sara@example.com',
          avatarUrl: 'https://example.com/sara.png',
        ),
        isOk(),
      );
      final saved = (await stack.watchProfile().first)!;
      expect(saved.name, 'Sara A.');
      expect(saved.email, 'sara@example.com');
      expect(saved.avatarUrl, Uri.parse('https://example.com/sara.png'));
    });

    test('an avatar cleared is cleared (every column is written)', () async {
      await stack.updateProfile(
        name: 'Sara',
        email: 'sara@example.com',
        avatarUrl: 'https://example.com/sara.png',
      );

      await stack.updateProfile(name: 'Sara', email: 'sara@example.com');

      expect((await stack.watchProfile().first)!.avatarUrl, isNull);
    });

    test('invalid: refused with the first problem, nothing saved', () async {
      expect(
        await stack.updateProfile(name: '', email: 'sara@example.com'),
        isErrSaying('Enter your name.'),
      );
      expect(
        await stack.updateProfile(
          name: 'Sara',
          email: 'sara@example.com',
          avatarUrl: 'http://x.com/a.png',
        ),
        isErr<InvalidInputException>(),
      );
      expect((await stack.watchProfile().first)!.name, 'Sara Ahmed');
    });

    test("the demo's counts, and a booking's", () async {
      expect(
        await stack.watchProfileCounts().first,
        const ProfileCounts(
          upcomingTickets: 3,
          savedEvents: 4,
          organizersFollowed: 2,
          sessionsBookmarked: 3,
        ),
      );
    });
  });

  group('settings tools', () {
    test('clear cache: the demo keeps what it owns', () async {
      final result = await stack.clearCache();

      expect(result, isOk(greaterThan(0)));
      final cards = await stack.catalog.watchEventCards().first;
      expect(cards.where((c) => c.isSaved), hasLength(4));
      expect(cards.where((c) => c.isGoing), hasLength(4));
      expect(cards.length, lessThan(25));
    });

    test('reset demo data: back to the demo, the catalog refetched', () async {
      await stack.updateProfile(name: 'Someone', email: 'x@example.com');
      await stack.savedEvents.unsave('ev_jazz_vaults');
      await stack.clearCache();

      expect(await stack.resetDemoData(), isOk());

      expect((await stack.watchProfile().first)!.name, 'Sara Ahmed');
      final cards = await stack.catalog.watchEventCards().first;
      expect(cards, hasLength(25));
      expect(cards.where((c) => c.isSaved), hasLength(4));
    });

    test('reset demo data offline: nothing changes', () async {
      await stack.updateProfile(name: 'Someone', email: 'x@example.com');
      stack.network.failRequests = true;

      expect(await stack.resetDemoData(), isErr<NetworkException>());
      expect((await stack.watchProfile().first)!.name, 'Someone');
    });

    test('reset demo data: no catalog, no reset (even if the demo user '
        'would load)', () async {
      final scripted = DataStack(
        api: (real) =>
            ScriptedEventlyApi(real, catalog: [const NetworkException()]),
      );
      addTearDown(scripted.close);
      await scripted.db.catalogDao.upsertCatalog(
        await stack.db.catalogDao.readAll(),
      );

      expect(await scripted.resetDemoData(), isErr<NetworkException>());
      expect(await scripted.watchProfile().first, isNull);
    });

    test('the developer switches reach the fake network and server', () async {
      stack.developer.setFailingRequests(fail: true);
      expect(stack.network.failRequests, isTrue);
      expect(stack.developer.failingRequests, isTrue);
      stack.developer.setFailingRequests(fail: false);

      expect(
        await stack.developer.publishCatalogUpdate(),
        '1 moved, 1 cancelled, 1 edited, 2 new',
      );
      await stack.catalog.refresh();
      final cards = await stack.catalog.watchEventCards().first;
      expect(cards, hasLength(27));
    });
  });
}
