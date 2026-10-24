// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'session_bookmarks_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionBookmarksDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $EventsTable get events => attachedDatabase.events;
  $SessionsTable get sessions => attachedDatabase.sessions;
  $SessionBookmarksTable get sessionBookmarks =>
      attachedDatabase.sessionBookmarks;
  SessionBookmarksDaoManager get managers => SessionBookmarksDaoManager(this);
}

class SessionBookmarksDaoManager {
  final _$SessionBookmarksDaoMixin _db;
  SessionBookmarksDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$SessionBookmarksTableTableManager get sessionBookmarks =>
      $$SessionBookmarksTableTableManager(
        _db.attachedDatabase,
        _db.sessionBookmarks,
      );
}
