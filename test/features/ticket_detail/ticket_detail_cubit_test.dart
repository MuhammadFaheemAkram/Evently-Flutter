import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/domain/calculation/ticket_rules.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_cubit.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  Future<TicketDetailCubit> opened(
    String ticketId, {
    EventlyApi Function(EventlyApi real)? api,
  }) async {
    stack = DataStack(api: api);
    addTearDown(stack.close);
    await stack.loadDemo();
    final cubit = TicketDetailCubit(
      stack.watchTicket,
      stack.cancelRsvp,
      stack.eventClock,
    )..load(ticketId);
    addTearDown(cubit.close);
    await waitFor(cubit, (s) => s.status != TicketDetailStatus.loading);
    return cubit;
  }

  test('an upcoming ticket: ready, and it can be cancelled', () async {
    final cubit = await opened('tkt_demo_design_conf');

    expect(cubit.state.item?.status, TicketStatus.confirmed);
    expect(cubit.state.cancelBlock, isNull);
  });

  test('a past ticket can no longer be cancelled', () async {
    final cubit = await opened('tkt_demo_accessibility');

    expect(cubit.state.cancelBlock, CancelBlock.started);
  });

  test(
    'cancel: the ticket is cancelled by you, and a message says so',
    () async {
      final cubit = await opened('tkt_demo_design_conf');

      await cubit.cancel();

      final state = await waitFor(
        cubit,
        (s) => s.item?.status == TicketStatus.cancelledByYou,
      );
      expect(state.cancelling, isFalse);
      expect(state.message, 'RSVP cancelled. Your place went back.');
      expect(state.cancelBlock, CancelBlock.cancelled);
    },
  );

  test('cancel offline: why, and the ticket stands', () async {
    final cubit = await opened(
      'tkt_demo_design_conf',
      api: (real) =>
          ScriptedEventlyApi(real, cancel: [const NetworkException()]),
    );

    await cubit.cancel();

    expect(cubit.state.message, const NetworkException().message);
    expect(cubit.state.item?.status, TicketStatus.confirmed);
    expect(cubit.state.cancelling, isFalse);
  });

  test('no such ticket: not found', () async {
    final cubit = await opened('tkt_nowhere');

    expect(cubit.state.status, TicketDetailStatus.notFound);
  });
}
