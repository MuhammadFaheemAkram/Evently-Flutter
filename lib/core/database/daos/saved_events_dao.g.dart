// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'saved_events_dao.dart';

// ignore_for_file: type=lint
mixin _$SavedEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $SavedEventsTable get savedEvents => attachedDatabase.savedEvents;
  SavedEventsDaoManager get managers => SavedEventsDaoManager(this);
}

class SavedEventsDaoManager {
  final _$SavedEventsDaoMixin _db;
  SavedEventsDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$SavedEventsTableTableManager get savedEvents =>
      $$SavedEventsTableTableManager(_db.attachedDatabase, _db.savedEvents);
}
