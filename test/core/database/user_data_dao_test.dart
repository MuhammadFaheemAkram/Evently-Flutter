import 'package:drift/native.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/user_data_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/user_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';
import '../../helpers/user_data_fixtures.dart';

void main() {
  late AppDatabase db;
  late UserDataDao dao;
  final at = DateTime.utc(2026, 10, 20, 9);

  setUp(() async {
    db = newTestDatabase();
    dao = db.userDataDao;
    await db.catalogDao.upsertCatalog(
      catalogOf([event(), event(id: 'ev_2')], sessions: [session()]).toRows(),
    );
  });

  tearDown(() => db.close());

  Future<UserData> stored() async => (await dao.readAll()).toUserData();

  test('what goes in comes back out, the same', () async {
    await dao.replaceAll(userData().toRows());

    expect(await stored(), userData());
  });

  test('replaces everything the user had, the search history and alerts '
      'too', () async {
    await dao.replaceAll(userData().toRows());
    await db
        .into(db.recentSearches)
        .insert(RecentSearchRow(query: 'jazz', searchedAt: at));
    await db
        .into(db.eventReminders)
        .insert(const EventReminderRow(eventId: 'ev_1', enabled: true));

    await dao.replaceAll(userData(eventId: 'ev_2').toRows());

    final data = await stored();
    expect(data.saved.single.eventId, 'ev_2');
    expect(data.tickets.single.eventId, 'ev_2');
    expect(await db.select(db.recentSearches).get(), isEmpty);
    expect(await db.select(db.eventReminders).get(), isEmpty);
  });

  test('twice gives the same result', () async {
    await dao.replaceAll(userData().toRows());
    await dao.replaceAll(userData().toRows());

    expect(await stored(), userData());
  });

  test('nothing replaces with nothing: a fresh start', () async {
    await dao.replaceAll(userData().toRows());

    await dao.replaceAll(const UserRows());

    expect(await stored(), const UserData());
  });

  test('an event the cache lacks refuses the whole write, and the old data '
      'stays', () async {
    await dao.replaceAll(userData().toRows());

    await expectLater(
      dao.replaceAll(userData(eventId: 'ev_unknown').toRows()),
      throwsA(isA<SqliteException>()),
    );

    expect(await stored(), userData());
  });

  test('never touches the catalog', () async {
    await dao.replaceAll(userData().toRows());
    await dao.replaceAll(const UserRows());

    expect(await db.select(db.events).get(), hasLength(2));
    expect(await db.select(db.sessions).get(), hasLength(1));
  });
}
