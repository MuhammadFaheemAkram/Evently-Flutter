import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_details.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:evently/features/event_detail/cubit/event_detail_state.dart';
import 'package:evently/features/event_detail/event_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockEventDetailCubit extends MockCubit<EventDetailState>
    implements EventDetailCubit {}

void main() {
  late _MockEventDetailCubit cubit;

  // Before Saturday's event (17:30–20:00 UTC).
  final before = DateTime.utc(2026, 10, 21, 14);

  String plain(String text) => text.replaceAll(' ', ' ');
  Finder text(String expected) => find.byWidgetPredicate(
    (w) => w is Text && plain(w.data ?? '') == expected,
  );

  EventDetails details({
    Event? shown,
    bool isGoing = false,
    bool isSaved = false,
    int sessionCount = 0,
  }) => EventDetails(
    item: card(
      shown ?? event(title: 'Jazz night'),
      isGoing: isGoing,
      isSaved: isSaved,
    ),
    organizer: organizer(),
    agendaPreview: [if (sessionCount > 0) session(title: 'Opening keynote')],
    sessionCount: sessionCount,
    ticketId: isGoing ? 't1' : null,
  );

  EventDetailState ready(EventDetails shown, {DateTime? now}) =>
      EventDetailState(
        status: EventDetailStatus.ready,
        details: shown,
        now: now ?? before,
      );

  setUp(() {
    cubit = _MockEventDetailCubit();
    when(() => cubit.toggleSaved()).thenAnswer((_) async {});
    when(() => cubit.openDirections(appleMaps: any(named: 'appleMaps')))
        .thenAnswer((_) async {});
    when(() => cubit.openJoinLink()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, EventDetailState state) {
    when(() => cubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(1170, 6000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(
      BlocProvider<EventDetailCubit>.value(
        value: cubit,
        child: const EventDetailView(),
      ),
    );
  }

  testWidgets('a bookable event: its time, place, attendance, tickets and '
      'RSVP', (tester) async {
    await pump(tester, ready(details()));

    expect(find.text('Jazz night'), findsOneWidget);
    expect(find.text('Technology · by Organizer org_1'), findsOneWidget);
    expect(text('Sat 24 Oct, 6:30 PM–9:00 PM BST'), findsOneWidget);
    // The user is in London too: one clock.
    expect(find.textContaining('Your time'), findsNothing);
    expect(find.text('Hall'), findsOneWidget);
    expect(find.text('1 Example Road, London'), findsOneWidget);
    expect(find.text('10 going · 90 places left'), findsOneWidget);
    expect(find.text('90 places left'), findsOneWidget);
    final rsvp = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'RSVP'),
    );
    expect(rsvp.onPressed, isNotNull);
    expect(find.text('Organizer org_1'), findsOneWidget);
    expect(find.text('10 followers · 1 event'), findsOneWidget);
  });

  testWidgets("an event in another zone shows the user's time too", (
    tester,
  ) async {
    final berlin = event(time: saturdayEvening.copyWith(zone: 'Europe/Berlin'));
    await pump(tester, ready(details(shown: berlin)));

    expect(text('Sat 24 Oct, 7:30 PM–10:00 PM CEST'), findsOneWidget);
    expect(text('Your time: Sat 24 Oct, 6:30 PM–9:00 PM BST'), findsOneWidget);
  });

  testWidgets("going: You're going and View ticket, no RSVP", (tester) async {
    await pump(tester, ready(details(isGoing: true)));

    expect(find.text("You're going"), findsOneWidget);
    expect(find.text('View ticket'), findsOneWidget);
    expect(find.text('RSVP'), findsNothing);
  });

  testWidgets('sold out: RSVP off, and why', (tester) async {
    final soldOut = event(offers: [freeOffer.copyWith(remaining: 0)]);
    await pump(tester, ready(details(shown: soldOut)));

    final rsvp = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'RSVP'),
    );
    expect(rsvp.onPressed, isNull);
    // The reason, the attendance and the offer all say it.
    expect(find.text('Sold out'), findsNWidgets(3));
  });

  testWidgets('over: how many went, and bookings closed', (tester) async {
    await pump(tester, ready(details(), now: saturdayEvening.end));

    expect(find.text('10 went'), findsOneWidget);
    expect(find.text('This event has ended'), findsOneWidget);
  });

  testWidgets('started: bookings closed', (tester) async {
    await pump(
      tester,
      ready(
        details(),
        now: saturdayEvening.start.add(const Duration(minutes: 5)),
      ),
    );

    expect(find.text('Bookings closed when it started'), findsOneWidget);
  });

  testWidgets('cancelled: a banner says so, with an icon', (tester) async {
    await pump(
      tester,
      ready(details(shown: event(status: EventStatus.cancelled))),
    );

    expect(find.text('Cancelled by the organizer'), findsOneWidget);
    expect(find.byIcon(Icons.event_busy), findsOneWidget);
    expect(find.text('This event was cancelled'), findsOneWidget);
  });

  testWidgets('moved: the new time and the old one', (tester) async {
    await pump(
      tester,
      ready(
        details(
          shown: event(
            status: EventStatus.moved,
            previousStart: DateTime.utc(2026, 10, 23, 17, 30),
          ),
        ),
      ),
    );

    expect(text('Moved to Sat 24 Oct, 6:30 PM BST'), findsOneWidget);
    expect(text('It was Fri 23 Oct, 6:30 PM BST.'), findsOneWidget);
    expect(find.byIcon(Icons.update), findsOneWidget);
  });

  testWidgets('a venue: Directions, in Google Maps off iOS', (tester) async {
    await pump(tester, ready(details()));

    await tester.tap(find.text('Directions'));

    verify(() => cubit.openDirections(appleMaps: false)).called(1);
  });

  testWidgets('online, not going: no join link yet', (tester) async {
    final online = event(location: onlineAt('https://meet.example/a'));
    await pump(tester, ready(details(shown: online)));

    expect(find.text('Online'), findsOneWidget);
    expect(find.text("The join link appears once you're going."), findsOne);
    expect(find.text('Join online'), findsNothing);
    expect(find.text('Directions'), findsNothing);
  });

  testWidgets('online and going: Join online', (tester) async {
    final online = event(location: onlineAt('https://meet.example/a'));
    await pump(tester, ready(details(shown: online, isGoing: true)));

    await tester.tap(find.text('Join online'));

    verify(() => cubit.openJoinLink()).called(1);
  });

  testWidgets('an agenda: its first sessions and the way to all of them', (
    tester,
  ) async {
    await pump(tester, ready(details(sessionCount: 12)));

    expect(find.text('Agenda'), findsOneWidget);
    expect(find.text('Opening keynote'), findsOneWidget);
    expect(find.text('See full agenda (12 sessions)'), findsOneWidget);
  });

  testWidgets('no agenda: no agenda section', (tester) async {
    await pump(tester, ready(details()));

    expect(find.text('Agenda'), findsNothing);
  });

  testWidgets('the app bar saves and unsaves', (tester) async {
    await pump(tester, ready(details(isSaved: true)));

    await tester.tap(find.byTooltip('Remove from saved'));

    verify(() => cubit.toggleSaved()).called(1);
  });

  testWidgets('not cached: says so, with a way to Discover', (tester) async {
    await pump(
      tester,
      const EventDetailState(status: EventDetailStatus.notFound),
    );

    expect(find.text("This event isn't available"), findsOneWidget);
    expect(find.text('Go to Discover'), findsOneWidget);
    expect(find.byTooltip('Save'), findsNothing);
  });

  testWidgets('the title is a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, ready(details()));

    expect(
      tester.getSemantics(find.text('Jazz night')),
      isSemantics(label: 'Jazz night', isHeader: true),
    );
    handle.dispose();
  });
}
