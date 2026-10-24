import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/ticket_item.dart';

import 'catalog_fixtures.dart';
import 'user_data_fixtures.dart';

/// A ticket for [shown] (an event by default), as Tickets shows it.
TicketItem ticketItem({
  Event? shown,
  DateTime? cancelledAt,
  String code = 'EVT-7KQ2-M9XH',
}) => TicketItem(
  ticket: ticket(cancelledAt: cancelledAt, code: code),
  event: shown ?? event(title: 'Late Jazz'),
  organizerName: 'Organizer org_1',
);
