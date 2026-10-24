// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'events_dao.dart';

// ignore_for_file: type=lint
mixin _$EventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $TicketOffersTable get ticketOffers => attachedDatabase.ticketOffers;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $SavedEventsTable get savedEvents => attachedDatabase.savedEvents;
  $TicketsTable get tickets => attachedDatabase.tickets;
  $EventRemindersTable get eventReminders => attachedDatabase.eventReminders;
  EventsDaoManager get managers => EventsDaoManager(this);
}

class EventsDaoManager {
  final _$EventsDaoMixin _db;
  EventsDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$TicketOffersTableTableManager get ticketOffers =>
      $$TicketOffersTableTableManager(_db.attachedDatabase, _db.ticketOffers);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$SavedEventsTableTableManager get savedEvents =>
      $$SavedEventsTableTableManager(_db.attachedDatabase, _db.savedEvents);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db.attachedDatabase, _db.tickets);
  $$EventRemindersTableTableManager get eventReminders =>
      $$EventRemindersTableTableManager(
        _db.attachedDatabase,
        _db.eventReminders,
      );
}
