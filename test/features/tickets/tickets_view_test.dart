import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/tickets/cubit/tickets_cubit.dart';
import 'package:evently/features/tickets/cubit/tickets_state.dart';
import 'package:evently/features/tickets/tickets_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/ticket_fixtures.dart';

class _MockTicketsCubit extends MockCubit<TicketsState>
    implements TicketsCubit {}

void main() {
  late _MockTicketsCubit cubit;

  setUp(() => cubit = _MockTicketsCubit());

  Future<void> pump(WidgetTester tester, TicketsState state) {
    when(() => cubit.state).thenReturn(state);
    tester.usePhoneSurface();
    return tester.pumpThemed(
      BlocProvider<TicketsCubit>.value(
        value: cubit,
        child: const TicketsView(),
      ),
    );
  }

  testWidgets('upcoming: each ticket with its type and state in words', (
    tester,
  ) async {
    await pump(
      tester,
      TicketsState(
        status: TicketsStatus.ready,
        upcoming: [
          ticketItem(),
          ticketItem(
            shown: event(
              id: 'ev_2',
              title: 'Moved talk',
              status: EventStatus.moved,
              previousStart: DateTime.utc(2026, 10, 23, 17, 30),
            ),
          ),
          ticketItem(
            shown: event(
              id: 'ev_3',
              title: 'Called off',
              status: EventStatus.cancelled,
            ),
          ),
          ticketItem(
            shown: event(id: 'ev_4', title: 'Changed my mind'),
            cancelledAt: DateTime.utc(2026, 10, 20),
          ),
        ],
      ),
    );

    expect(find.text('Late Jazz'), findsOneWidget);
    expect(find.text('Free'), findsNWidgets(4));
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('Moved'), findsOneWidget);
    expect(find.text('Cancelled by the organizer'), findsOneWidget);
    expect(find.text('Cancelled by you'), findsOneWidget);
  });

  testWidgets('no upcoming tickets: how to get one', (tester) async {
    await pump(tester, const TicketsState(status: TicketsStatus.ready));

    expect(find.text('No upcoming tickets'), findsOneWidget);
    expect(find.text('Discover events'), findsOneWidget);
  });

  testWidgets('the Past tab', (tester) async {
    await pump(
      tester,
      TicketsState(
        status: TicketsStatus.ready,
        past: [ticketItem(shown: event(title: 'Old talk'))],
      ),
    );

    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();

    expect(find.text('Old talk'), findsOneWidget);
  });
}
