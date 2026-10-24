import 'package:evently/domain/calculation/agenda_builder.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Berlin, Thursday 5 November (CET, UTC+1).
  ScheduleSession at(
    String id,
    int fromHour,
    int fromMinute,
    int toHour,
    int toMinute, {
    int day = 5,
  }) => ScheduleSession(
    id: id,
    eventId: 'ev_conf',
    title: 'Session $id',
    speaker: 'Someone',
    room: 'Main',
    start: DateTime.utc(2026, 11, day, fromHour - 1, fromMinute),
    end: DateTime.utc(2026, 11, day, toHour - 1, toMinute),
  );

  final trust = at('trust', 9, 30, 10, 30);
  final type = at('type', 10, 0, 11, 0);
  final next = at('next', 11, 0, 12, 0);
  final opening = at('opening', 9, 0, 9, 30);
  final dayTwo = at('two', 9, 0, 10, 0, day: 6);

  test('overlap is end-exclusive: back-to-back sessions do not clash', () {
    expect(overlaps(trust, type), isTrue);
    expect(overlaps(type, next), isFalse);
    expect(overlaps(opening, trust), isFalse);
  });

  test("days are the venue's, sessions in time order", () {
    final days = buildAgenda(
      [dayTwo, next, trust, opening, type],
      bookmarked: {},
      zone: 'Europe/Berlin',
    );

    expect(
      [for (final d in days) d.day],
      [CalendarDate(2026, 11, 5), CalendarDate(2026, 11, 6)],
    );
    expect(
      [for (final s in days.first.sessions) s.session.id],
      ['opening', 'trust', 'type', 'next'],
    );
  });

  test('a late session is on its venue day, whatever UTC says', () {
    // 00:30 in Berlin on the 6th is still the 5th in UTC.
    final late = ScheduleSession(
      id: 'late',
      eventId: 'ev_conf',
      title: 'Late',
      speaker: 'Someone',
      room: 'Main',
      start: DateTime.utc(2026, 11, 5, 23, 30),
      end: DateTime.utc(2026, 11, 6, 0, 30),
    );

    final days = buildAgenda([late], bookmarked: {}, zone: 'Europe/Berlin');

    expect(days.single.day, CalendarDate(2026, 11, 6));
  });

  test('only bookmarked sessions clash, and each names the other', () {
    final days = buildAgenda(
      [trust, type, next],
      bookmarked: {'trust', 'type', 'next'},
      zone: 'Europe/Berlin',
    );
    final sessions = {for (final s in days.single.sessions) s.session.id: s};

    expect(sessions['trust']!.clashesWith, [type]);
    expect(sessions['type']!.clashesWith, [trust]);
    expect(sessions['next']!.clashesWith, isEmpty);
  });

  test('an overlap with a session not bookmarked is no clash', () {
    final days = buildAgenda(
      [trust, type],
      bookmarked: {'trust'},
      zone: 'Europe/Berlin',
    );
    final sessions = days.single.sessions;

    expect(sessions.first.isBookmarked, isTrue);
    expect(sessions.first.clashesWith, isEmpty);
    expect(sessions.last.isBookmarked, isFalse);
    expect(sessions.last.clashesWith, isEmpty);
  });

  test('no sessions: no days', () {
    expect(buildAgenda([], bookmarked: {}, zone: 'Europe/Berlin'), isEmpty);
  });
}
