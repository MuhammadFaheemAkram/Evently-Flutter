// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'user_data_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDataDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $SavedEventsTable get savedEvents => attachedDatabase.savedEvents;
  $TicketsTable get tickets => attachedDatabase.tickets;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $SessionBookmarksTable get sessionBookmarks =>
      attachedDatabase.sessionBookmarks;
  $FollowedOrganizersTable get followedOrganizers =>
      attachedDatabase.followedOrganizers;
  $EventRemindersTable get eventReminders => attachedDatabase.eventReminders;
  $EventChangesTable get eventChanges => attachedDatabase.eventChanges;
  $RecentSearchesTable get recentSearches => attachedDatabase.recentSearches;
  $ProfilesTable get profiles => attachedDatabase.profiles;
  UserDataDaoManager get managers => UserDataDaoManager(this);
}

class UserDataDaoManager {
  final _$UserDataDaoMixin _db;
  UserDataDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$SavedEventsTableTableManager get savedEvents =>
      $$SavedEventsTableTableManager(_db.attachedDatabase, _db.savedEvents);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db.attachedDatabase, _db.tickets);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$SessionBookmarksTableTableManager get sessionBookmarks =>
      $$SessionBookmarksTableTableManager(
        _db.attachedDatabase,
        _db.sessionBookmarks,
      );
  $$FollowedOrganizersTableTableManager get followedOrganizers =>
      $$FollowedOrganizersTableTableManager(
        _db.attachedDatabase,
        _db.followedOrganizers,
      );
  $$EventRemindersTableTableManager get eventReminders =>
      $$EventRemindersTableTableManager(
        _db.attachedDatabase,
        _db.eventReminders,
      );
  $$EventChangesTableTableManager get eventChanges =>
      $$EventChangesTableTableManager(_db.attachedDatabase, _db.eventChanges);
  $$RecentSearchesTableTableManager get recentSearches =>
      $$RecentSearchesTableTableManager(
        _db.attachedDatabase,
        _db.recentSearches,
      );
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db.attachedDatabase, _db.profiles);
}
