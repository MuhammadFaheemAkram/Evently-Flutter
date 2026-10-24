import 'package:evently/core/database/daos/tickets_dao.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/calculation/ticket_codes.dart';
import 'package:evently/domain/model/ticket.dart';
import 'package:evently/domain/model/ticket_item.dart';

extension TicketDtoToDomain on TicketDto {
  /// The ticket the server issued, after checking its code. Throws a
  /// [FormatException]; nothing is written.
  Ticket toTicket() {
    if (!TicketCodes.isValid(code)) {
      throw FormatException('Ticket: $id has an invalid code, $code');
    }
    return Ticket(
      id: id,
      eventId: eventId,
      code: code,
      type: type,
      note: note,
      bookedAt: bookedAt.toUtc(),
    );
  }
}

extension TicketWithEventRowToDomain on TicketWithEventRow {
  TicketItem toDomain() => TicketItem(
    ticket: ticket.toDomain(),
    event: event.toDomain(offers),
    organizerName: organizerName,
  );
}
