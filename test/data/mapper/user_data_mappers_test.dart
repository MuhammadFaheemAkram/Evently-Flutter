import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> ticketJson(String id, String eventId, String code) => {
    'id': id,
    'eventId': eventId,
    'code': code,
    'type': 'free',
    'bookedAt': '2026-10-20T10:00:00.000+0100',
  };

  Map<String, dynamic> demoJson() => {
    'profile': {'name': 'Sara Ahmed', 'email': 'sara@example.com'},
    'saved': [
      {'eventId': 'ev_1', 'savedAt': '2026-10-20T10:00:00.000+0100'},
    ],
    'tickets': [ticketJson('t1', 'ev_1', 'EVT-7KQ2-M9XX')],
    'bookmarks': [
      {'sessionId': 'ses_1', 'createdAt': '2026-10-20T09:00:00Z'},
    ],
    'follows': [
      {'organizerId': 'org_1', 'followedAt': '2026-10-20T09:00:00Z'},
    ],
  };

  Object? map(Map<String, dynamic> json) =>
      DemoUserDto.fromJson(json).toUserData();

  Matcher refused(String problem) => throwsA(
    isA<FormatException>().having(
      (e) => e.message,
      'message',
      'Demo user: $problem',
    ),
  );

  test('maps the demo user, its instants in UTC', () {
    final data = DemoUserDto.fromJson(demoJson()).toUserData();

    expect(data.profile?.name, 'Sara Ahmed');
    expect(data.profile?.avatarUrl, isNull);
    expect(data.saved.single.savedAt, DateTime.utc(2026, 10, 20, 9));
    expect(data.saved.single.savedAt.isUtc, isTrue);
    expect(data.tickets.single.type, TicketType.free);
    expect(data.tickets.single.note, '');
    expect(data.tickets.single.isActive, isTrue);
  });

  test('a demo user without a profile is fine (a fresh start has none)', () {
    final json = demoJson()..remove('profile');

    expect(DemoUserDto.fromJson(json).toUserData().profile, isNull);
  });

  group('refuses', () {
    test('an event saved twice', () {
      final json = demoJson();
      (json['saved'] as List).add((json['saved'] as List).first);
      expect(() => map(json), refused('an event saved twice'));
    });

    test('a session bookmarked twice', () {
      final json = demoJson();
      (json['bookmarks'] as List).add((json['bookmarks'] as List).first);
      expect(() => map(json), refused('a session bookmarked twice'));
    });

    test('an organizer followed twice', () {
      final json = demoJson();
      (json['follows'] as List).add((json['follows'] as List).first);
      expect(() => map(json), refused('an organizer followed twice'));
    });

    test('a ticket id twice', () {
      final json = demoJson();
      (json['tickets'] as List).add(ticketJson('t1', 'ev_2', 'EVT-H4TW-8RCW'));
      expect(() => map(json), refused('a ticket id twice'));
    });

    test('a ticket code twice', () {
      final json = demoJson();
      (json['tickets'] as List).add(ticketJson('t2', 'ev_2', 'EVT-7KQ2-M9XX'));
      expect(() => map(json), refused('a ticket code twice'));
    });

    test('two tickets for one event', () {
      final json = demoJson();
      (json['tickets'] as List).add(ticketJson('t2', 'ev_1', 'EVT-H4TW-8RCW'));
      expect(() => map(json), refused('two tickets for one event'));
    });

    test('a profile with no name, or no email', () {
      expect(
        () => map(
          demoJson()..['profile'] = {'name': ' ', 'email': 'sara@example.com'},
        ),
        refused('a profile with no name'),
      );
      expect(
        () => map(demoJson()..['profile'] = {'name': 'Sara', 'email': 'sara'}),
        refused('a profile with no email'),
      );
    });

    test("an avatar that isn't https", () {
      expect(
        () => map(
          demoJson()
            ..['profile'] = {
              'name': 'Sara',
              'email': 'sara@example.com',
              'avatarUrl': 'http://example.com/sara.png',
            },
        ),
        refused("an avatar that isn't https"),
      );
    });
  });
}
