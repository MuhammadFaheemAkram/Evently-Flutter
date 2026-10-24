import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/features/agenda/cubit/agenda_cubit.dart';
import 'package:evently/features/agenda/cubit/agenda_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<AgendaCubit> opened(String eventId) async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
    final cubit = AgendaCubit(stack.watchAgenda, stack.setSessionBookmarked)
      ..load(eventId);
    addTearDown(cubit.close);
    await waitFor(cubit, (s) => s.status != AgendaStatus.loading);
    return cubit;
  }

  test('opens on the first day', () async {
    final cubit = await opened('ev_design_conf');

    expect(cubit.state.days, hasLength(2));
    expect(cubit.state.currentDay?.day, CalendarDate(2026, 11, 2));
    expect(cubit.state.visibleSessions, isNotEmpty);
  });

  test('another day, and My sessions', () async {
    final cubit = await opened('ev_design_conf');

    cubit.selectDay(CalendarDate(2026, 11, 3));
    expect(cubit.state.currentDay?.day, CalendarDate(2026, 11, 3));

    cubit
      ..selectDay(CalendarDate(2026, 11, 2))
      ..toggleMyOnly();
    expect(cubit.state.visibleSessions.every((s) => s.isBookmarked), isTrue);
    expect(cubit.state.visibleSessions, isNotEmpty);
  });

  test('a bookmark toggled shows at once, with its clashes', () async {
    final cubit = await opened('ev_design_conf');
    final type = cubit.state.visibleSessions.singleWhere(
      (s) => s.session.id == 'ses_conf_type',
    );

    await cubit.toggleBookmark(type);
    final state = await waitFor(
      cubit,
      (s) => !s.visibleSessions
          .singleWhere((x) => x.session.id == 'ses_conf_type')
          .isBookmarked,
    );

    final trust = state.visibleSessions.singleWhere(
      (s) => s.session.id == 'ses_conf_trust',
    );
    expect(trust.clashesWith, isEmpty);
  });

  test('a failed bookmark says why', () async {
    final cubit = await opened('ev_design_conf');
    final first = cubit.state.visibleSessions.first;
    await stack.db.customStatement('DROP TABLE session_bookmarks');

    await cubit.toggleBookmark(first);

    expect(cubit.state.messageSerial, 1);
  });

  test('not cached: not found', () async {
    final cubit = await opened('ev_nowhere');

    expect(cubit.state.status, AgendaStatus.notFound);
  });
}
