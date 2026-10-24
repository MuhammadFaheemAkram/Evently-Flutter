import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';

/// [event] as a list shows it, by "Organizer org_1".
EventCardItem card(
  Event event, {
  bool isSaved = false,
  bool isGoing = false,
  String organizerName = 'Organizer org_1',
}) => EventCardItem(
  event: event,
  organizerName: organizerName,
  isSaved: isSaved,
  isGoing: isGoing,
);
