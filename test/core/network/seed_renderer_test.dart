import 'package:evently/core/network/seed_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> seedEvent({
    String id = 'ev_1',
    String zone = 'Europe/London',
    int inDays = 0,
    String at = '18:30',
    int endsInDays = 0,
    String endsAt = '21:00',
    List<Map<String, dynamic>> offers = const [
      {
        'type': 'free',
        'priceMinor': 0,
        'currency': 'GBP',
        'capacity': 100,
        'remaining': 90,
      },
    ],
    List<Map<String, dynamic>> sessions = const [],
  }) => {
    'id': id,
    'title': 'An event',
    'description': 'What happens.',
    'category': 'technology',
    'organizerId': 'org_1',
    'starts': {'inDays': inDays, 'at': at},
    'ends': {'inDays': endsInDays, 'at': endsAt},
    'timeZone': zone,
    'venue': {'name': 'Hall', 'address': '1 Road', 'city': 'London'},
    'offers': offers,
    'sessions': sessions,
  };

  Map<String, dynamic> render(
    List<Map<String, dynamic>> events, {
    required DateTime now,
    List<Map<String, dynamic>>? organizers,
  }) => SeedRenderer.catalog({
    'organizers':
        organizers ??
        [
          {'id': 'org_1', 'name': 'Org', 'bio': '', 'followers': 1},
        ],
    'events': events,
  }, now);

  Map<String, dynamic> only(Map<String, dynamic> catalog) =>
      (catalog['events'] as List).single as Map<String, dynamic>;

  final wednesday = DateTime.utc(2026, 10, 21, 14);

  group('a relative time becomes an instant with the venue\'s offset', () {
    test('today at 18:30 in London, in summer time', () {
      final event = only(render([seedEvent()], now: wednesday));

      expect(event['startsAt'], '2026-10-21T18:30:00.000+0100');
      expect(event['endsAt'], '2026-10-21T21:00:00.000+0100');
    });

    test('five days on, the clocks have gone back', () {
      final event = only(
        render([seedEvent(inDays: 5, endsInDays: 5)], now: wednesday),
      );

      expect(event['startsAt'], '2026-10-26T18:30:00.000+0000');
    });

    test('in the past, for a few past events', () {
      final event = only(
        render([seedEvent(inDays: -6, endsInDays: -6)], now: wednesday),
      );

      expect(event['startsAt'], '2026-10-15T18:30:00.000+0100');
    });

    test('a late event ends on its next day', () {
      final event = only(
        render([
          seedEvent(
            zone: 'America/New_York',
            at: '23:30',
            endsInDays: 1,
            endsAt: '03:00',
          ),
        ], now: wednesday),
      );

      expect(event['startsAt'], '2026-10-21T23:30:00.000-0400');
      expect(event['endsAt'], '2026-10-22T03:00:00.000-0400');
    });

    test("'today' is the venue's today: at 20:00 UTC it is already "
        'tomorrow in Lahore', () {
      final now = DateTime.utc(2026, 10, 21, 20);
      final catalog = render([
        seedEvent(),
        seedEvent(id: 'ev_2', zone: 'Asia/Karachi'),
      ], now: now);
      final events = (catalog['events'] as List).cast<Map<String, dynamic>>();

      expect(events[0]['startsAt'], '2026-10-21T18:30:00.000+0100');
      expect(events[1]['startsAt'], '2026-10-22T18:30:00.000+0500');
    });

    test("sessions fall on their event's days", () {
      final event = only(
        render([
          seedEvent(
            zone: 'Europe/Berlin',
            inDays: 3,
            at: '09:00',
            endsInDays: 4,
            endsAt: '18:00',
            sessions: [
              {
                'id': 'ses_1',
                'title': 'Day two',
                'speaker': 'Someone',
                'room': 'Main',
                'day': 1,
                'from': '10:00',
                'to': '11:00',
              },
            ],
          ),
        ], now: wednesday),
      );
      final session = (event['sessions'] as List).single as Map;

      // Saturday is Berlin's day two, still in summer time; Sunday's
      // 10:00 would be +0100.
      expect(session['startsAt'], '2026-10-25T10:00:00.000+0100');
      expect(event['startsAt'], '2026-10-24T09:00:00.000+0200');
    });
  });

  group('what the server computes', () {
    test("attendees and capacity from the offers' places", () {
      final event = only(
        render([
          seedEvent(
            offers: [
              {
                'type': 'standard',
                'priceMinor': 1800,
                'currency': 'GBP',
                'capacity': 150,
                'remaining': 40,
              },
              {
                'type': 'vip',
                'priceMinor': 4500,
                'currency': 'GBP',
                'capacity': 20,
                'remaining': 6,
              },
            ],
          ),
        ], now: wednesday),
      );

      expect(event['capacity'], 170);
      expect(event['attendeeCount'], 124);
    });

    test('each organizer\'s number of events', () {
      final catalog = render(
        [seedEvent(), seedEvent(id: 'ev_2')],
        now: wednesday,
        organizers: [
          {'id': 'org_1', 'name': 'One', 'bio': '', 'followers': 1},
          {'id': 'org_2', 'name': 'Two', 'bio': '', 'followers': 1},
        ],
      );
      final organizers = (catalog['organizers'] as List)
          .cast<Map<String, dynamic>>();

      expect(organizers.map((o) => o['eventsCount']), [2, 0]);
    });

    test('every event scheduled, and not featured unless the seed says', () {
      final event = only(render([seedEvent()], now: wednesday));

      expect(event['status'], 'scheduled');
      expect(event['featured'], isFalse);
    });
  });

  test("the demo user's days ago become UTC instants", () {
    final user = SeedRenderer.demoUser({
      'profile': {'name': 'Sara', 'email': 'sara@example.com'},
      'saved': [
        {'eventId': 'ev_1', 'daysAgo': 2},
      ],
      'tickets': [
        {
          'id': 't1',
          'eventId': 'ev_1',
          'code': 'EVT-7KQ2-M9XH',
          'type': 'free',
          'note': '',
          'bookedDaysAgo': 5,
        },
      ],
      'bookmarks': [
        {'sessionId': 'ses_1', 'daysAgo': 1},
      ],
      'follows': [
        {'organizerId': 'org_1', 'daysAgo': 30},
      ],
    }, wednesday);

    expect((user['saved'] as List).single, {
      'eventId': 'ev_1',
      'savedAt': '2026-10-19T14:00:00.000Z',
    });
    expect(
      ((user['tickets'] as List).single as Map)['bookedAt'],
      '2026-10-16T14:00:00.000Z',
    );
    expect(
      ((user['follows'] as List).single as Map)['followedAt'],
      '2026-09-21T14:00:00.000Z',
    );
  });
}
