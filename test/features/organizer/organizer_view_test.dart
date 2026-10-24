import 'package:bloc_test/bloc_test.dart';
import 'package:evently/features/organizer/cubit/organizer_cubit.dart';
import 'package:evently/features/organizer/cubit/organizer_state.dart';
import 'package:evently/features/organizer/organizer_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockOrganizerCubit extends MockCubit<OrganizerState>
    implements OrganizerCubit {}

void main() {
  late _MockOrganizerCubit cubit;

  final ready = OrganizerState(
    status: OrganizerStatus.ready,
    organizer: organizer().copyWith(
      name: 'Flutter London',
      followers: 2400,
      eventsCount: 5,
      bio: 'Monthly meetups.',
    ),
    upcoming: [card(event(title: 'State of Flutter'))],
    past: [card(event(id: 'ev_old', title: 'Old talk'))],
    now: saturdayEvening.start.subtract(const Duration(days: 1)),
  );

  setUp(() {
    cubit = _MockOrganizerCubit();
    when(() => cubit.toggleFollowing()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, OrganizerState state) {
    when(() => cubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      BlocProvider<OrganizerCubit>.value(
        value: cubit,
        child: const OrganizerView(),
      ),
    );
  }

  testWidgets('who they are, their counts, their events', (tester) async {
    await pump(tester, ready);

    expect(find.text('Flutter London'), findsOneWidget);
    expect(find.text('FL'), findsOneWidget);
    expect(find.text('2.4k followers · 5 events'), findsOneWidget);
    expect(find.text('Monthly meetups.'), findsOneWidget);
    expect(find.text('State of Flutter'), findsOneWidget);
    expect(find.text('Past'), findsOneWidget);
    expect(find.text('Old talk'), findsOneWidget);
  });

  testWidgets('Follow, as an action', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.text('Follow'));

    verify(() => cubit.toggleFollowing()).called(1);
  });

  testWidgets('Following, as a state with a check', (tester) async {
    await pump(tester, ready.copyWith(isFollowing: true));

    expect(find.text('Following'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('nothing coming up says so', (tester) async {
    await pump(tester, ready.copyWith(upcoming: []));

    expect(find.text('Nothing planned right now.'), findsOneWidget);
  });

  testWidgets('not found', (tester) async {
    await pump(tester, const OrganizerState(status: OrganizerStatus.notFound));

    expect(find.text("This organizer isn't available"), findsOneWidget);
  });
}
