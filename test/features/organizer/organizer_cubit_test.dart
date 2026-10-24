import 'package:evently/features/organizer/cubit/organizer_cubit.dart';
import 'package:evently/features/organizer/cubit/organizer_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<OrganizerCubit> opened(String organizerId) async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
    final cubit = OrganizerCubit(
      stack.watchOrganizer,
      stack.setFollowing,
      stack.setEventSaved,
      stack.eventClock,
    )..load(organizerId);
    addTearDown(cubit.close);
    await waitFor(cubit, (s) => s.status != OrganizerStatus.loading);
    return cubit;
  }

  test('their events: upcoming soonest first, past apart', () async {
    final cubit = await opened('org_flutter_london');

    expect(cubit.state.organizer?.name, 'Flutter London');
    expect(cubit.state.isFollowing, isTrue);
    expect(cubit.state.upcoming.first.event.id, 'ev_flutter_london_meetup');
    expect(
      cubit.state.past.map((e) => e.event.id),
      contains('ev_accessibility_talk'),
    );
  });

  test('follow, then unfollow', () async {
    final cubit = await opened('org_soundwaves');
    expect(cubit.state.isFollowing, isFalse);

    await cubit.toggleFollowing();
    await waitFor(cubit, (s) => s.isFollowing);
    await cubit.toggleFollowing();
    await waitFor(cubit, (s) => !s.isFollowing);
  });

  test('saving one of their events', () async {
    final cubit = await opened('org_soundwaves');
    final first = cubit.state.upcoming.first;

    await cubit.toggleSaved(first);

    await waitFor(
      cubit,
      (s) => s.upcoming.firstWhere((e) => e.event.id == first.event.id).isSaved,
    );
  });

  test('unknown: not found', () async {
    final cubit = await opened('org_nowhere');

    expect(cubit.state.status, OrganizerStatus.notFound);
  });
}
