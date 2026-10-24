// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'reminders_dao.dart';

// ignore_for_file: type=lint
mixin _$RemindersDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $EventRemindersTable get eventReminders => attachedDatabase.eventReminders;
  $EventChangesTable get eventChanges => attachedDatabase.eventChanges;
  $TicketsTable get tickets => attachedDatabase.tickets;
  RemindersDaoManager get managers => RemindersDaoManager(this);
}

class RemindersDaoManager {
  final _$RemindersDaoMixin _db;
  RemindersDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$EventRemindersTableTableManager get eventReminders =>
      $$EventRemindersTableTableManager(
        _db.attachedDatabase,
        _db.eventReminders,
      );
  $$EventChangesTableTableManager get eventChanges =>
      $$EventChangesTableTableManager(_db.attachedDatabase, _db.eventChanges);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db.attachedDatabase, _db.tickets);
}
