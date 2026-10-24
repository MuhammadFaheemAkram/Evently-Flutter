import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/features/saved/cubit/saved_cubit.dart';
import 'package:evently/features/saved/cubit/saved_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/data_stack.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<SavedCubit> loaded() async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
    final cubit = SavedCubit(
      stack.watchSaved,
      stack.setEventSaved,
      stack.eventClock,
    )..load();
    addTearDown(cubit.close);
    await waitFor(cubit, (s) => s.status == SavedStatus.ready);
    return cubit;
  }

  List<String> ids(Iterable<EventCardItem> items) => [
    for (final item in items) item.event.id,
  ];

  test("the demo's saved events, upcoming soonest first", () async {
    final cubit = await loaded();

    expect(ids(cubit.state.upcoming), [
      'ev_jazz_vaults',
      'ev_design_conf',
      'ev_burnout_proof',
      'ev_ai_summit',
    ]);
    expect(cubit.state.past, isEmpty);
  });

  test('a saved event that is over goes under Past', () async {
    final cubit = await loaded();

    await stack.savedEvents.save('ev_accessibility_talk');

    final state = await waitFor(cubit, (s) => s.past.isNotEmpty);
    expect(ids(state.past), ['ev_accessibility_talk']);
  });

  test('remove: gone from the list, offered for Undo; Undo brings it '
      'back', () async {
    final cubit = await loaded();
    final jazz = cubit.state.upcoming.first;

    await cubit.remove(jazz);
    final removed = await waitFor(cubit, (s) => s.upcoming.length == 3);
    expect(removed.removed, jazz);
    expect(removed.removedSerial, 1);

    await cubit.undo(jazz);
    await waitFor(cubit, (s) => s.upcoming.length == 4);
  });

  test('nothing saved: an empty, ready list', () async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.catalog.refresh();
    final cubit = SavedCubit(
      stack.watchSaved,
      stack.setEventSaved,
      stack.eventClock,
    )..load();
    addTearDown(cubit.close);

    final state = await waitFor(cubit, (s) => s.status == SavedStatus.ready);

    expect(state.isEmpty, isTrue);
  });

  test('a failed undo says why', () async {
    final cubit = await loaded();

    await cubit.undo(card(event(id: 'ev_nowhere')));

    expect(cubit.state.message, isNotEmpty);
    expect(cubit.state.messageSerial, 1);
  });
}
