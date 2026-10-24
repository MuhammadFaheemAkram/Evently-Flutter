import 'package:evently/domain/calculation/ticket_rules.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/ticket_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/user_data_fixtures.dart';

void main() {
  final before = saturdayEvening.start.subtract(const Duration(hours: 1));
  final cancelledAt = DateTime.utc(2026, 10, 20);

  TicketItem item({
    EventStatus status = EventStatus.scheduled,
    bool cancelled = false,
  }) => TicketItem(
    ticket: ticket(cancelledAt: cancelled ? cancelledAt : null),
    event: event(
      status: status,
      previousStart: status == EventStatus.moved
          ? DateTime.utc(2026, 10, 23, 17, 30)
          : null,
    ),
    organizerName: 'Organizer org_1',
  );

  group('status', () {
    test('confirmed, moved, cancelled by the organizer', () {
      expect(item().status, TicketStatus.confirmed);
      expect(item(status: EventStatus.moved).status, TicketStatus.moved);
      expect(
        item(status: EventStatus.cancelled).status,
        TicketStatus.cancelledByOrganizer,
      );
    });

    test('your cancellation wins over the event\'s state', () {
      expect(
        item(status: EventStatus.cancelled, cancelled: true).status,
        TicketStatus.cancelledByYou,
      );
    });
  });

  group('cancelling', () {
    test('a confirmed or moved ticket, before the start: yes', () {
      expect(cancelBlock(item(), now: before), isNull);
      expect(cancelBlock(item(status: EventStatus.moved), now: before), isNull);
    });

    test('at the start: no longer', () {
      expect(
        cancelBlock(item(), now: saturdayEvening.start),
        CancelBlock.started,
      );
    });

    test('cancelled already, or by the organizer: nothing to give back', () {
      expect(
        cancelBlock(item(cancelled: true), now: before),
        CancelBlock.cancelled,
      );
      expect(
        cancelBlock(item(status: EventStatus.cancelled), now: before),
        CancelBlock.eventCancelled,
      );
    });
  });
}
