import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/rsvp/cubit/rsvp_cubit.dart';
import 'package:evently/features/rsvp/cubit/rsvp_state.dart';
import 'package:evently/features/rsvp/rsvp_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockRsvpCubit extends MockCubit<RsvpState> implements RsvpCubit {}

void main() {
  late _MockRsvpCubit cubit;

  final before = saturdayEvening.start.subtract(const Duration(days: 1));
  const standard = TicketOffer(
    type: TicketType.standard,
    priceMinor: 1800,
    currency: 'GBP',
    capacity: 150,
    remaining: 40,
  );
  const vipSoldOut = TicketOffer(
    type: TicketType.vip,
    priceMinor: 4500,
    currency: 'GBP',
    capacity: 20,
    remaining: 0,
  );
  final editing = RsvpState(
    status: RsvpStatus.editing,
    event: card(event(title: 'Late Jazz', offers: [standard, vipSoldOut])),
    now: before,
  );

  setUp(() {
    cubit = _MockRsvpCubit();
    when(() => cubit.confirm()).thenAnswer((_) async {});
  });

  setUpAll(() => registerFallbackValue(TicketType.free));

  Future<void> pump(WidgetTester tester, RsvpState state) {
    when(() => cubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      BlocProvider<RsvpCubit>.value(
        value: cubit,
        child: const RsvpView(eventId: 'ev_1'),
      ),
    );
  }

  testWidgets('the form: the event, each type with its price and places, '
      'sold-out ones off', (tester) async {
    await pump(tester, editing);

    expect(find.text('Late Jazz'), findsOneWidget);
    expect(find.text('£18 · 40 places left'), findsOneWidget);
    expect(find.text('Sold out'), findsOneWidget);
    final vip = tester.widget<RadioListTile<TicketType>>(
      find.widgetWithText(RadioListTile<TicketType>, 'VIP'),
    );
    expect(vip.enabled, isFalse);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('choosing a type and typing a note go to the Cubit', (
    tester,
  ) async {
    await pump(tester, editing);

    await tester.tap(find.text('Standard'));
    await tester.enterText(find.byType(TextField), 'Aisle seat');

    verify(() => cubit.selectType(TicketType.standard)).called(1);
    verify(() => cubit.changeNote('Aisle seat')).called(1);
  });

  testWidgets('Confirm shows the total, and confirms', (tester) async {
    await pump(tester, editing.copyWith(type: TicketType.standard));

    await tester.tap(find.text('Confirm · £18'));

    verify(() => cubit.confirm()).called(1);
  });

  testWidgets('after a Confirm with no type: the error under the types', (
    tester,
  ) async {
    await pump(tester, editing.copyWith(showErrors: true));

    expect(find.text('Choose a ticket type.'), findsOneWidget);
  });

  testWidgets('a note over the limit: the field says so', (tester) async {
    await pump(
      tester,
      editing.copyWith(
        type: TicketType.standard,
        note: 'a' * 201,
        showErrors: true,
      ),
    );

    expect(find.text('Keep it to 200 characters.'), findsOneWidget);
  });

  testWidgets('submitting: a spinner, the form locked', (tester) async {
    await pump(
      tester,
      editing.copyWith(
        type: TicketType.standard,
        status: RsvpStatus.submitting,
      ),
    );

    expect(find.bySemanticsLabel('Booking'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('failed: why, nothing booked, and Try again', (tester) async {
    await pump(
      tester,
      editing.copyWith(
        type: TicketType.standard,
        status: RsvpStatus.failed,
        error: "Couldn't reach the server.",
      ),
    );

    expect(find.text("Not booked. Couldn't reach the server."), findsOneWidget);
    await tester.tap(find.text('Try again'));
    verify(() => cubit.confirm()).called(1);
  });

  testWidgets('already going: the reason, no form', (tester) async {
    await pump(
      tester,
      editing.copyWith(event: editing.event!.copyWith(isGoing: true)),
    );

    expect(find.text("You're going"), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Back to the event'), findsOneWidget);
  });

  testWidgets('booked: opening the ticket', (tester) async {
    await pump(
      tester,
      editing.copyWith(status: RsvpStatus.booked, ticketId: 't1'),
    );

    expect(find.text('Opening your ticket'), findsOneWidget);
  });

  testWidgets('not cached: says so', (tester) async {
    await pump(tester, const RsvpState(status: RsvpStatus.notFound));

    expect(find.text("This event isn't available"), findsOneWidget);
  });
}
