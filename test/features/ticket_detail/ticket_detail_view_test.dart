import 'package:bloc_test/bloc_test.dart';
import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_cubit.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_state.dart';
import 'package:evently/features/ticket_detail/ticket_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/ticket_fixtures.dart';

class _MockTicketDetailCubit extends MockCubit<TicketDetailState>
    implements TicketDetailCubit {}

void main() {
  late _MockTicketDetailCubit cubit;

  final before = saturdayEvening.start.subtract(const Duration(days: 1));
  final ready = TicketDetailState(
    status: TicketDetailStatus.ready,
    item: ticketItem(),
    now: before,
  );

  setUp(() {
    cubit = _MockTicketDetailCubit();
    when(() => cubit.cancel()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, TicketDetailState state) {
    when(() => cubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      BlocProvider<TicketDetailCubit>.value(
        value: cubit,
        child: const TicketDetailView(),
      ),
    );
  }

  testWidgets('a confirmed ticket: its QR, labelled with the code', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester, ready);

    expect(find.byType(QrImageView), findsOneWidget);
    expect(
      find.bySemanticsLabel('QR code for ticket EVT-7KQ2-M9XH'),
      findsOneWidget,
    );
    expect(find.text('EVT-7KQ2-M9XH'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('Aisle seat'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the QR is black on white in the dark theme too', (tester) async {
    when(() => cubit.state).thenReturn(ready);
    await tester.pumpThemed(
      BlocProvider<TicketDetailCubit>.value(
        value: cubit,
        child: const TicketDetailView(),
      ),
      theme: AppTheme.dark(),
    );

    final qr = tester.widget<QrImageView>(find.byType(QrImageView));
    expect(qr.backgroundColor, Colors.white);
  });

  testWidgets('Cancel RSVP asks first; Keep it does nothing', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.text('Cancel RSVP'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel your RSVP?'), findsOneWidget);
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();

    verifyNever(() => cubit.cancel());
  });

  testWidgets('confirmed in the dialog: the Cubit cancels', (tester) async {
    await pump(tester, ready);

    await tester.tap(find.text('Cancel RSVP'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel RSVP').last);
    await tester.pumpAndSettle();

    verify(() => cubit.cancel()).called(1);
  });

  testWidgets('cancelled by you: no QR, no Cancel', (tester) async {
    await pump(
      tester,
      ready.copyWith(item: ticketItem(cancelledAt: DateTime.utc(2026, 10, 20))),
    );

    expect(find.byType(QrImageView), findsNothing);
    expect(
      find.text('This ticket no longer works at the door.'),
      findsOneWidget,
    );
    expect(find.text('Cancelled by you'), findsOneWidget);
    expect(find.text('Cancel RSVP'), findsNothing);
  });

  testWidgets('cancelled by the organizer: no QR', (tester) async {
    await pump(
      tester,
      ready.copyWith(
        item: ticketItem(shown: event(status: EventStatus.cancelled)),
      ),
    );

    expect(find.byType(QrImageView), findsNothing);
    expect(find.text('Cancelled by the organizer'), findsOneWidget);
  });

  testWidgets('after the start: no Cancel, and why', (tester) async {
    await pump(tester, ready.copyWith(now: saturdayEvening.start));

    expect(find.text('Cancel RSVP'), findsNothing);
    expect(
      find.text('The event has started: the RSVP can no longer be cancelled.'),
      findsOneWidget,
    );
  });

  testWidgets('cancelling: the button waits', (tester) async {
    await pump(tester, ready.copyWith(cancelling: true));

    expect(find.text('Cancelling…'), findsOneWidget);
  });

  testWidgets('no such ticket', (tester) async {
    await pump(
      tester,
      const TicketDetailState(status: TicketDetailStatus.notFound),
    );

    expect(find.text("This ticket isn't here"), findsOneWidget);
  });
}
