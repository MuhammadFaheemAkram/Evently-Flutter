import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/daos/recent_searches_dao.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/database.dart';

void main() {
  late AppDatabase db;
  late RecentSearchesDao dao;
  final start = DateTime.utc(2026, 10, 21, 9);

  DateTime minute(int n) => start.add(Duration(minutes: n));

  setUp(() {
    db = newTestDatabase();
    dao = db.recentSearchesDao;
  });

  tearDown(() => db.close());

  test('newest first', () async {
    await dao.save('jazz', minute(0));
    await dao.save('design', minute(1));

    expect(await dao.watch().first, ['design', 'jazz']);
  });

  test('the same search in another case is one entry, moved first, with '
      'the newer spelling', () async {
    await dao.save('jazz', minute(0));
    await dao.save('design', minute(1));
    await dao.save('Jazz', minute(2));

    expect(await dao.watch().first, ['Jazz', 'design']);
  });

  test('keeps the last ten', () async {
    for (var i = 0; i < 12; i++) {
      await dao.save('search $i', minute(i));
    }

    final kept = await dao.watch().first;
    expect(kept, hasLength(RecentSearchesDao.limit));
    expect(kept.first, 'search 11');
    expect(kept.last, 'search 2');
    expect(await db.select(db.recentSearches).get(), hasLength(10));
  });

  test('clear empties them', () async {
    await dao.save('jazz', minute(0));

    await dao.clear();

    expect(await dao.watch().first, isEmpty);
  });
}
