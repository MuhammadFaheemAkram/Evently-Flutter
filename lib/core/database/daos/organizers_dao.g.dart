// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'organizers_dao.dart';

// ignore_for_file: type=lint
mixin _$OrganizersDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrganizersTable get organizers => attachedDatabase.organizers;
  $FollowedOrganizersTable get followedOrganizers =>
      attachedDatabase.followedOrganizers;
  OrganizersDaoManager get managers => OrganizersDaoManager(this);
}

class OrganizersDaoManager {
  final _$OrganizersDaoMixin _db;
  OrganizersDaoManager(this._db);
  $$OrganizersTableTableManager get organizers =>
      $$OrganizersTableTableManager(_db.attachedDatabase, _db.organizers);
  $$FollowedOrganizersTableTableManager get followedOrganizers =>
      $$FollowedOrganizersTableTableManager(
        _db.attachedDatabase,
        _db.followedOrganizers,
      );
}
