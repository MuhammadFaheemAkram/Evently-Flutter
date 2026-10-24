// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'catalog_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $TicketOffersTable get ticketOffers => attachedDatabase.ticketOffers;
  $SessionsTable get sessions => attachedDatabase.sessions;
  CatalogDaoManager get managers => CatalogDaoManager(this);
}

class CatalogDaoManager {
  final _$CatalogDaoMixin _db;
  CatalogDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$TicketOffersTableTableManager get ticketOffers =>
      $$TicketOffersTableTableManager(_db.attachedDatabase, _db.ticketOffers);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
}
