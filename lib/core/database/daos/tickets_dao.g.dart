// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'tickets_dao.dart';

// ignore_for_file: type=lint
mixin _$TicketsDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $TicketsTable get tickets => attachedDatabase.tickets;
  $TicketOffersTable get ticketOffers => attachedDatabase.ticketOffers;
  TicketsDaoManager get managers => TicketsDaoManager(this);
}

class TicketsDaoManager {
  final _$TicketsDaoMixin _db;
  TicketsDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db.attachedDatabase, _db.tickets);
  $$TicketOffersTableTableManager get ticketOffers =>
      $$TicketOffersTableTableManager(_db.attachedDatabase, _db.ticketOffers);
}
