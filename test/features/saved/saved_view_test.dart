import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/event_time.dart';
import 'package:evently/features/saved/cubit/saved_cubit.dart';
import 'package:evently/features/saved/cubit/saved_state.dart';
import 'package:evently/features/saved/saved_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockSavedCubit extends MockCubit<SavedState> implements SavedCubit {}

void main() {
  late _MockSavedCubit cubit;

  final jazz = card(event(id: 'ev_jazz', title: 'Late Jazz'), isSaved: true);
  final old = card(
    event(
      id: 'ev_old',
      title: 'Old talk',
      time: EventTime(
        start: DateTime.utc(2026, 10, 1, 18),
        end: DateTime.utc(2026, 10, 1, 20),
        zone: 'Europe/London',
      ),
    ),
    isSaved: true,
  );
  final ready = SavedState(
    status: SavedStatus.ready,
    upcoming: [jazz],
    past: [old],
    now: DateTime.utc(2026, 10, 21, 14),
  );

  setUpAll(() => registerFallbackValue(jazz));

  setUp(() {
    cubit = _MockSavedCubit();
    when(() => cubit.remove(any())).thenAnswer((_) async {});
    when(() => cubit.undo(any())).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, SavedState state) {
    when(() => cubit.state).thenReturn(state);
    tester.usePhoneSurface();
    return tester.pumpThemed(
      BlocProvider<SavedCubit>.value(value: cubit, child: const SavedView()),
    );
  }

  testWidgets('nothing saved: says how, with a way to Discover', (
    tester,
  ) async {
    await pump(tester, const SavedState(status: SavedStatus.ready));

    expect(find.text('Nothing saved yet'), findsOneWidget);
    expect(find.text('Discover events'), findsOneWidget);
  });

  testWidgets('coming up, then past', (tester) async {
    await pump(tester, ready);

    expect(find.text('Coming up'), findsOneWidget);
    expect(find.text('Past'), findsOneWidget);
    final jazzTop = tester.getTopLeft(find.text('Late Jazz')).dy;
    final oldTop = tester.getTopLeft(find.text('Old talk')).dy;
    expect(jazzTop, lessThan(oldTop));
    expect(find.text('10 went'), findsOneWidget);
  });

  testWidgets('swiping a row away removes it', (tester) async {
    await pump(tester, ready);

    await tester.drag(find.text('Late Jazz'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    verify(() => cubit.remove(jazz)).called(1);
  });

  testWidgets('the bookmark removes it too', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.byTooltip('Remove from saved').first);

    verify(() => cubit.remove(jazz)).called(1);
  });

  testWidgets('a removal offers Undo', (tester) async {
    whenListen(
      cubit,
      Stream.value(ready.copyWith(removed: jazz, removedSerial: 1)),
      initialState: ready,
    );
    tester.usePhoneSurface();
    await tester.pumpThemed(
      BlocProvider<SavedCubit>.value(value: cubit, child: const SavedView()),
    );
    await tester.pump();

    expect(find.text('Removed “Late Jazz”'), findsOneWidget);
    // Let the SnackBar finish sliding in before tapping its action.
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo'));
    verify(() => cubit.undo(jazz)).called(1);
  });
}
