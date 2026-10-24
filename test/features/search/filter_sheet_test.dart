import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/event_filter.dart';
import 'package:evently/features/search/widgets/filter_sheet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  final today = CalendarDate(2026, 10, 21);

  /// Opens the sheet from a button, and returns what it gave back.
  Future<List<EventFilter?>> openSheet(
    WidgetTester tester, {
    EventFilter current = const EventFilter(query: 'jazz'),
  }) async {
    final results = <EventFilter?>[];
    tester.view
      ..physicalSize = const Size(1170, 3600)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpThemed(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async => results.add(
            await showFilterSheet(context, current: current, today: today),
          ),
          child: const Text('Open'),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('choices are a draft until Apply, which returns them', (
    tester,
  ) async {
    final results = await openSheet(tester);

    await tester.tap(find.widgetWithText(FilterChip, 'Music'));
    await tester.tap(find.widgetWithText(FilterChip, 'Design'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'This weekend'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Paid'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Online'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Going'));
    await tester.pump();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(
      results.single,
      const EventFilter(
        query: 'jazz',
        categories: {EventCategory.music, EventCategory.design},
        dates: DatePreset.thisWeekend,
        price: PriceFilter.paid,
        format: FormatFilter.online,
        rsvp: RsvpFilter.going,
      ),
    );
  });

  testWidgets('a chip tapped again is off again', (tester) async {
    final results = await openSheet(
      tester,
      current: const EventFilter(categories: {EventCategory.music}),
    );

    await tester.tap(find.widgetWithText(FilterChip, 'Music'));
    await tester.pump();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(results.single, const EventFilter());
  });

  testWidgets('Reset clears the filters, keeping the text', (tester) async {
    final results = await openSheet(
      tester,
      current: const EventFilter(
        query: 'jazz',
        price: PriceFilter.free,
        rsvp: RsvpFilter.going,
      ),
    );

    await tester.tap(find.text('Reset'));
    await tester.pump();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(results.single, const EventFilter(query: 'jazz'));
  });

  testWidgets('a custom range shows its days, and can be picked again', (
    tester,
  ) async {
    await openSheet(
      tester,
      current: EventFilter(
        dates: DatePreset.custom,
        from: CalendarDate(2026, 10, 24),
        to: CalendarDate(2026, 10, 31),
      ),
    );

    expect(find.text('24 Oct – 31 Oct'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Custom…'));
    await tester.pumpAndSettle();
    expect(find.byType(DateRangePickerDialog), findsOneWidget);
  });

  testWidgets('closed without Apply: nothing comes back', (tester) async {
    final results = await openSheet(tester);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(results, [null]);
  });
}
