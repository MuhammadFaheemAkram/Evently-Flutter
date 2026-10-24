import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/agenda.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/schedule_session.dart';
import 'package:evently/features/agenda/agenda_page.dart';
import 'package:evently/features/agenda/cubit/agenda_cubit.dart';
import 'package:evently/features/agenda/cubit/agenda_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockAgendaCubit extends MockCubit<AgendaState> implements AgendaCubit {}

void main() {
  late _MockAgendaCubit cubit;

  ScheduleSession session(String id, String title, int hour) => ScheduleSession(
    id: id,
    eventId: 'ev_conf',
    title: title,
    speaker: 'Amara Okafor',
    room: 'Main Hall',
    start: DateTime.utc(2026, 11, 5, hour - 1),
    end: DateTime.utc(2026, 11, 5, hour),
  );

  final trust = session('trust', 'Designing for Trust', 10);
  final type = session('type', 'Type at Scale', 10);
  final opening = session('opening', 'Opening', 9);
  final thursday = CalendarDate(2026, 11, 5);
  final agenda = Agenda(
    eventId: 'ev_conf',
    eventTitle: 'Berlin Design Conference',
    zone: 'Europe/Berlin',
    days: [
      AgendaDay(
        day: thursday,
        sessions: [
          AgendaSession(session: opening),
          AgendaSession(
            session: trust,
            isBookmarked: true,
            clashesWith: [type],
          ),
          AgendaSession(
            session: type,
            isBookmarked: true,
            clashesWith: [trust],
          ),
        ],
      ),
      AgendaDay(day: thursday.addDays(1), sessions: const []),
    ],
  );
  final ready = AgendaState(status: AgendaStatus.ready, agenda: agenda);

  setUpAll(() => registerFallbackValue(AgendaSession(session: opening)));

  setUp(() {
    cubit = _MockAgendaCubit();
    when(() => cubit.toggleBookmark(any())).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, AgendaState state) {
    when(() => cubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      BlocProvider<AgendaCubit>.value(
        value: cubit,
        child: const AgendaView(eventId: 'ev_conf'),
      ),
    );
  }

  testWidgets("the day's sessions on the venue's clock, with clashes", (
    tester,
  ) async {
    await pump(tester, ready);

    expect(find.text('Berlin Design Conference'), findsOneWidget);
    expect(find.text('Opening'), findsOneWidget);
    // 08:00–09:00 UTC is 9:00–10:00 in Berlin (the test clock is 12-hour).
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.data ?? '').replaceAll(' ', ' ') == '9:00 AM–10:00 AM',
      ),
      findsWidgets,
    );
    expect(find.text('Clashes with Type at Scale'), findsOneWidget);
    expect(find.text('Clashes with Designing for Trust'), findsOneWidget);
  });

  testWidgets('a chip per day, and My sessions', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.text('Fri 6 Nov'));
    await tester.tap(find.text('My sessions'));

    verify(() => cubit.selectDay(thursday.addDays(1))).called(1);
    verify(() => cubit.toggleMyOnly()).called(1);
  });

  testWidgets('each bookmark says what a tap does, for which session', (
    tester,
  ) async {
    await pump(tester, ready);

    expect(find.byTooltip('Bookmark: Opening'), findsOneWidget);
    expect(find.byTooltip('Remove bookmark: Type at Scale'), findsOneWidget);
    await tester.tap(find.byTooltip('Bookmark: Opening'));
    verify(() => cubit.toggleBookmark(AgendaSession(session: opening)))
        .called(1);
  });

  testWidgets('My sessions on a day with none: says how to add some', (
    tester,
  ) async {
    await pump(
      tester,
      ready.copyWith(selectedDay: thursday.addDays(1), myOnly: true),
    );

    expect(find.textContaining('No bookmarked sessions'), findsOneWidget);
  });

  testWidgets('one day only: no day chips', (tester) async {
    await pump(
      tester,
      ready.copyWith(agenda: agenda.copyWith(days: [agenda.days.first])),
    );

    expect(find.byType(ChoiceChip), findsNothing);
    expect(find.text('My sessions'), findsOneWidget);
  });

  testWidgets('no sessions at all', (tester) async {
    await pump(tester, ready.copyWith(agenda: agenda.copyWith(days: [])));

    expect(find.text('No agenda'), findsOneWidget);
  });
}
