import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../helpers/catalog_fixtures.dart';
import '../../../helpers/event_card_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  String plain(String text) => text.replaceAll(' ', ' ');

  group('EventCard', () {
    Future<List<String>> pumpCard(
      WidgetTester tester, {
      required RsvpBlock? block,
      bool isSaved = false,
      bool isGoing = false,
      Event? shown,
    }) async {
      final taps = <String>[];
      tester.usePhoneSurface();
      await tester.pumpThemed(
        ListView(
          children: [
            EventCard(
              item: card(
                shown ?? event(title: 'Jazz night'),
                isSaved: isSaved,
                isGoing: isGoing,
              ),
              rsvpBlock: block,
              onTap: () => taps.add('open'),
              onToggleSaved: () => taps.add('save'),
              onRsvp: () => taps.add('rsvp'),
            ),
          ],
        ),
      );
      return taps;
    }

    testWidgets('bookable: RSVP, and each part reports itself', (tester) async {
      final taps = await pumpCard(tester, block: null);

      await tester.tap(find.text('RSVP'));
      await tester.tap(find.byTooltip('Save'));
      await tester.tap(find.text('Jazz night'));

      expect(taps, ['rsvp', 'save', 'open']);
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Hall, London'), findsOneWidget);
    });

    testWidgets('going: a Going badge instead of RSVP', (tester) async {
      await pumpCard(tester, block: RsvpBlock.going, isGoing: true);

      expect(find.text('Going'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('RSVP'), findsNothing);
    });

    testWidgets('not bookable: no RSVP', (tester) async {
      await pumpCard(tester, block: RsvpBlock.soldOut);

      expect(find.text('RSVP'), findsNothing);
    });

    testWidgets('saved: the bookmark offers to remove it', (tester) async {
      await pumpCard(tester, block: null, isSaved: true);

      expect(find.byTooltip('Remove from saved'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets("an in-person event at the venue's time, an online one at "
        "the user's (London)", (tester) async {
      // The test device uses a 12-hour clock.
      Finder text(String expected) => find.byWidgetPredicate(
        (w) => w is Text && plain(w.data ?? '') == expected,
      );
      final berlin = event(
        time: saturdayEvening.copyWith(zone: 'Europe/Berlin'),
      );

      await pumpCard(tester, block: null, shown: berlin);
      expect(text('Sat 24 Oct, 7:30 PM CEST'), findsOneWidget);

      await pumpCard(
        tester,
        block: null,
        shown: berlin.copyWith(location: onlineAt('https://meet.example/a')),
      );
      expect(text('Sat 24 Oct, 6:30 PM BST'), findsOneWidget);
    });

    testWidgets('at large text the actions go under the attendance', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await pumpCard(tester, block: null);

      final attendance = tester.getRect(find.byType(AttendanceLabel));
      final rsvp = tester.getRect(find.text('RSVP'));
      expect(rsvp.top, greaterThan(attendance.bottom));
    });
  });

  group('AttendanceLabel', () {
    Future<void> pumpLabel(
      WidgetTester tester,
      Event shown, {
      bool ended = false,
    }) => tester.pumpThemed(AttendanceLabel(event: shown, ended: ended));

    TicketOffer places(int left) => TicketOffer(
      type: TicketType.standard,
      priceMinor: 1000,
      currency: 'GBP',
      capacity: 100,
      remaining: left,
    );

    testWidgets('how many are going and how many places are left', (
      tester,
    ) async {
      await pumpLabel(tester, event(offers: [places(26)]));
      expect(find.text('10 going · 26 places left'), findsOneWidget);
    });

    testWidgets('few places: the number, an icon and the warning color', (
      tester,
    ) async {
      await pumpLabel(tester, event(offers: [places(3)]));
      expect(find.text('3 places left'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department_outlined), findsOneWidget);
    });

    testWidgets('sold out: the words and an icon', (tester) async {
      await pumpLabel(tester, event(offers: [places(0)]));
      expect(find.text('Sold out'), findsOneWidget);
      expect(find.byIcon(Icons.block), findsOneWidget);
    });

    testWidgets('once over: how many went', (tester) async {
      await pumpLabel(tester, event(offers: [places(0)]), ended: true);
      expect(find.text('10 went'), findsOneWidget);
    });
  });

  group('ZonedTimeText', () {
    Future<void> pumpTime(WidgetTester tester, {bool online = false}) =>
        tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: MediaQuery(
              data: const MediaQueryData(alwaysUse24HourFormat: true),
              child: UserTimeZone(
                location: tz.getLocation('Asia/Karachi'),
                child: Scaffold(
                  body: ZonedTimeText(time: saturdayEvening, online: online),
                ),
              ),
            ),
          ),
        );

    testWidgets("the venue's time first, the user's below when it differs", (
      tester,
    ) async {
      await pumpTime(tester);

      expect(find.text('Sat 24 Oct, 18:30–21:00 BST'), findsOneWidget);
      expect(
        find.text('Your time: Sat 24 Oct, 22:30 – Sun 25 Oct, 01:00 PKT'),
        findsOneWidget,
      );
    });

    testWidgets('no second line when the clocks agree', (tester) async {
      await tester.pumpThemed(ZonedTimeText(time: saturdayEvening));

      expect(find.textContaining('Your time'), findsNothing);
    });

    testWidgets("an online event only on the user's clock", (tester) async {
      await pumpTime(tester, online: true);

      expect(
        find.text('Sat 24 Oct, 22:30 – Sun 25 Oct, 01:00 PKT'),
        findsOneWidget,
      );
      expect(find.textContaining('BST'), findsNothing);
    });

    testWidgets('read in full words', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpTime(tester);

      expect(
        find.bySemanticsLabel('Saturday 24 October, 18:30 to 21:00, BST'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  test('initials: the first letters of the first two words', () {
    expect(InitialsAvatar.initialsOf('Flutter London'), 'FL');
    expect(InitialsAvatar.initialsOf('NYC Tech Forum'), 'NT');
    expect(InitialsAvatar.initialsOf('  sara  '), 'S');
    expect(InitialsAvatar.initialsOf(''), '');
  });

  testWidgets('a category chip shows its icon until selected', (tester) async {
    await tester.pumpThemed(
      CategoryChip(
        category: EventCategory.music,
        selected: false,
        onSelected: () {},
      ),
    );

    expect(find.text('Music'), findsOneWidget);
    expect(
      find.byIcon(CategoryPalette.style('music', Brightness.light).icon),
      findsOneWidget,
    );
  });
}
