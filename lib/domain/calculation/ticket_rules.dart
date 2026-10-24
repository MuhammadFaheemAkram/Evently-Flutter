import 'package:evently/domain/model/ticket_item.dart';

/// Why a ticket can't be cancelled now.
enum CancelBlock {
  /// It's cancelled already.
  cancelled,

  /// The organizer called the event off: there's nothing to give back.
  eventCancelled,

  /// The event has begun: a place can only be given back before.
  started,
}

/// What stands between you and cancelling [item] at [now], or `null`.
CancelBlock? cancelBlock(TicketItem item, {required DateTime now}) {
  return switch (item.status) {
    TicketStatus.cancelledByYou => CancelBlock.cancelled,
    TicketStatus.cancelledByOrganizer => CancelBlock.eventCancelled,
    _ when item.event.time.hasStarted(now) => CancelBlock.started,
    _ => null,
  };
}
