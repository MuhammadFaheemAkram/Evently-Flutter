// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'profile_dao.dart';

// ignore_for_file: type=lint
mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProfilesTable get profiles => attachedDatabase.profiles;
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $TicketsTable get tickets => attachedDatabase.tickets;
  $SavedEventsTable get savedEvents => attachedDatabase.savedEvents;
  $FollowedOrganizersTable get followedOrganizers =>
      attachedDatabase.followedOrganizers;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $SessionBookmarksTable get sessionBookmarks =>
      attachedDatabase.sessionBookmarks;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db.attachedDatabase, _db.profiles);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db.attachedDatabase, _db.tickets);
  $$SavedEventsTableTableManager get savedEvents =>
      $$SavedEventsTableTableManager(_db.attachedDatabase, _db.savedEvents);
  $$FollowedOrganizersTableTableManager get followedOrganizers =>
      $$FollowedOrganizersTableTableManager(
        _db.attachedDatabase,
        _db.followedOrganizers,
      );
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$SessionBookmarksTableTableManager get sessionBookmarks =>
      $$SessionBookmarksTableTableManager(
        _db.attachedDatabase,
        _db.sessionBookmarks,
      );
}
