import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/domain/model/event_card_item.dart';

extension EventCardRowToDomain on EventCardRow {
  EventCardItem toDomain() => EventCardItem(
    event: event.toDomain(offers),
    organizerName: organizerName,
    isSaved: isSaved,
    isGoing: activeTicketId != null,
    reminderChoice: reminderChoice,
  );
}
