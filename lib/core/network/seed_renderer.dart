import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/time_of_day_value.dart';
import 'package:timezone/timezone.dart' as tz;

/// The fake server's templates, rendered into the JSON a real API would
/// send, as of [now].
///
/// The seed files describe events the way people plan them: "in 3 days at
/// 18:30, in London". Rendering turns that into what goes over the wire:
/// ISO-8601 instants with the venue's offset ("…T18:30:00.000+0100"), so
/// the demo always has events today, this weekend and next month, and a
/// few past ones, whatever the date. "In 3 days" counts from the *venue's*
/// today: at 01:00 in London it's already tomorrow in Lahore.
///
/// It also does what a server would compute: an event's attendee count and
/// capacity from its ticket offers, and each organizer's events count. The
/// app then parses the result with its checked DTOs, exactly as it would a
/// real response.
abstract final class SeedRenderer {
  static Map<String, dynamic> catalog(Map<String, dynamic> seed, DateTime now) {
    final events = [
      for (final event in _list(seed['events'])) _event(event, now),
    ];
    return {
      'organizers': [
        for (final organizer in _list(seed['organizers']))
          {
            ...organizer,
            'eventsCount': events
                .where((e) => e['organizerId'] == organizer['id'])
                .length,
          },
      ],
      'events': events,
    };
  }

  static Map<String, dynamic> demoUser(
    Map<String, dynamic> seed,
    DateTime now,
  ) {
    String ago(Object? days) =>
        now.toUtc().subtract(Duration(days: days! as int)).toIso8601String();
    return {
      'profile': seed['profile'],
      'saved': [
        for (final saved in _list(seed['saved']))
          {'eventId': saved['eventId'], 'savedAt': ago(saved['daysAgo'])},
      ],
      'tickets': [
        for (final ticket in _list(seed['tickets']))
          {
            'id': ticket['id'],
            'eventId': ticket['eventId'],
            'code': ticket['code'],
            'type': ticket['type'],
            'note': ticket['note'],
            'bookedAt': ago(ticket['bookedDaysAgo']),
          },
      ],
      'bookmarks': [
        for (final bookmark in _list(seed['bookmarks']))
          {
            'sessionId': bookmark['sessionId'],
            'createdAt': ago(bookmark['daysAgo']),
          },
      ],
      'follows': [
        for (final follow in _list(seed['follows']))
          {
            'organizerId': follow['organizerId'],
            'followedAt': ago(follow['daysAgo']),
          },
      ],
    };
  }

  static Map<String, dynamic> _event(Map<String, dynamic> seed, DateTime now) {
    final location = tz.getLocation(seed['timeZone']! as String);
    final today = CalendarDate.fromDateTime(tz.TZDateTime.from(now, location));
    final starts = seed['starts']! as Map<String, dynamic>;
    final ends = seed['ends']! as Map<String, dynamic>;
    final startDay = today.addDays(starts['inDays']! as int);
    String at(CalendarDate day, Object? hhMm) {
      final time = TimeOfDayValue.parse(hhMm! as String);
      return tz.TZDateTime(
        location,
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      ).toIso8601String();
    }

    final offers = _list(seed['offers']);
    int sum(int Function(Map<String, dynamic> offer) of) =>
        offers.fold(0, (total, offer) => total + of(offer));
    return {
      'id': seed['id'],
      'title': seed['title'],
      'description': seed['description'],
      'category': seed['category'],
      'organizerId': seed['organizerId'],
      'startsAt': at(startDay, starts['at']),
      'endsAt': at(today.addDays(ends['inDays']! as int), ends['at']),
      'timeZone': seed['timeZone'],
      'venue': seed['venue'],
      'joinUrl': seed['joinUrl'],
      'featured': seed['featured'] ?? false,
      'attendeeCount': sum(
        (o) => (o['capacity']! as int) - (o['remaining']! as int),
      ),
      'capacity': sum((o) => o['capacity']! as int),
      'status': 'scheduled',
      'offers': offers,
      'sessions': [
        for (final session in _list(seed['sessions']))
          {
            'id': session['id'],
            'title': session['title'],
            'speaker': session['speaker'],
            'room': session['room'],
            'startsAt': at(
              startDay.addDays(session['day']! as int),
              session['from'],
            ),
            'endsAt': at(
              startDay.addDays(session['day']! as int),
              session['to'],
            ),
          },
      ],
    };
  }

  static List<Map<String, dynamic>> _list(Object? json) => [
    for (final item in (json as List<Object?>?) ?? const [])
      item! as Map<String, dynamic>,
  ];
}
