import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/tickets/cubit/tickets_cubit.dart';
import 'package:evently/features/tickets/cubit/tickets_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("the demo's tickets: upcoming soonest first, past apart; a new "
      'booking joins', () async {
    final stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
    final cubit = TicketsCubit(stack.watchTickets, stack.eventClock)..load();
    addTearDown(cubit.close);

    final state = await waitFor(cubit, (s) => s.status == TicketsStatus.ready);
    expect(
      [for (final t in state.upcoming) t.event.id],
      ['ev_flutter_london_meetup', 'ev_dart_patterns_live', 'ev_design_conf'],
    );
    expect([for (final t in state.past) t.event.id], ['ev_accessibility_talk']);

    await stack.booking.rsvp('ev_jazz_vaults', type: TicketType.vip);
    final after = await waitFor(cubit, (s) => s.upcoming.length == 4);
    expect(after.upcoming[2].event.id, 'ev_jazz_vaults');
  });
}
