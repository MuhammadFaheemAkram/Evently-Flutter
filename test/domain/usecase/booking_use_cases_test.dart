import 'package:evently/core/common/app_exception.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/result_matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;
  late ScriptedEventlyApi api;

  setUp(() async {
    stack = DataStack(api: (real) => ScriptedEventlyApi(real));
    addTearDown(stack.close);
    api = stack.api as ScriptedEventlyApi;
    await stack.loadDemo();
  });

  group('RSVP: the form is checked again before the server is asked', () {
    test('no type: refused, the server never asked', () async {
      final result = await stack.rsvpEvent('ev_jazz_vaults', type: null);

      expect(result, isErr<InvalidInputException>());
      expect(result, isErrSaying('Choose a ticket type.'));
      expect(api.rsvpCalls, 0);
    });

    test('a note too long: refused', () async {
      expect(
        await stack.rsvpEvent(
          'ev_jazz_vaults',
          type: TicketType.vip,
          note: 'a' * 201,
        ),
        isErr<InvalidInputException>(),
      );
      expect(api.rsvpCalls, 0);
    });

    test('already going: refused', () async {
      expect(
        await stack.rsvpEvent(
          'ev_flutter_london_meetup',
          type: TicketType.free,
        ),
        isErr<InvalidInputException>(),
      );
      expect(api.rsvpCalls, 0);
    });

    test('an event not cached: not found', () async {
      expect(
        await stack.rsvpEvent('ev_nowhere', type: TicketType.free),
        isErr<NotFoundException>(),
      );
    });

    test('a valid form goes to the server, note trimmed', () async {
      final result = await stack.rsvpEvent(
        'ev_jazz_vaults',
        type: TicketType.vip,
        note: '  Aisle seat  ',
      );

      expect(
        result,
        isOk(isA<Ticket>().having((t) => t.note, 'note', 'Aisle seat')),
      );
      expect(api.rsvpCalls, 1);
    });
  });

  group('cancel: only before the event starts', () {
    test('a past ticket: refused, the server never asked', () async {
      final past = (await stack.watchTickets().first).singleWhere(
        (t) => t.event.id == 'ev_accessibility_talk',
      );

      expect(await stack.cancelRsvp(past), isErr<InvalidInputException>());
      expect(api.cancelCalls, 0);
    });

    test('an upcoming one: cancelled', () async {
      final upcoming = (await stack.watchTickets().first).singleWhere(
        (t) => t.event.id == 'ev_design_conf',
      );

      expect(await stack.cancelRsvp(upcoming), isOk());
      expect(api.cancelCalls, 1);
    });
  });
}
