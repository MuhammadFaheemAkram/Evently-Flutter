import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:timezone/timezone.dart' as tz;

/// Whether two sessions overlap. End-exclusive: one ending at 10:00 and the
/// next starting at 10:00 don't clash, you just walk across.
bool overlaps(ScheduleSession a, ScheduleSession b) =>
    a.start.isBefore(b.end) && b.start.isBefore(a.end);

/// [sessions] (any order) as days of the event's own calendar ([zone]),
/// each in time order, with [bookmarked] marked, and each bookmarked
/// session's clashes with the other bookmarked ones.
///
/// The days are the venue's: a session at 09:00 in Berlin is on Thursday
/// in Berlin, whatever the user's clock says.
List<AgendaDay> buildAgenda(
  Iterable<ScheduleSession> sessions, {
  required Set<String> bookmarked,
  required String zone,
}) {
  final location = tz.getLocation(zone);
  final sorted = sessions.toList()
    ..sort((a, b) {
      final byStart = a.start.compareTo(b.start);
      return byStart != 0 ? byStart : a.id.compareTo(b.id);
    });
  final chosen = [
    for (final session in sorted)
      if (bookmarked.contains(session.id)) session,
  ];
  final days = <CalendarDate, List<AgendaSession>>{};
  for (final session in sorted) {
    final isBookmarked = bookmarked.contains(session.id);
    final day = CalendarDate.fromDateTime(
      tz.TZDateTime.from(session.start, location),
    );
    (days[day] ??= []).add(
      AgendaSession(
        session: session,
        isBookmarked: isBookmarked,
        clashesWith: isBookmarked
            ? [
                for (final other in chosen)
                  if (other.id != session.id && overlaps(session, other)) other,
              ]
            : const [],
      ),
    );
  }
  return [
    for (final entry in days.entries)
      AgendaDay(day: entry.key, sessions: entry.value),
  ];
}
