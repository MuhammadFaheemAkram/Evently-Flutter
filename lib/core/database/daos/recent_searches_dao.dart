import 'package:drift/drift.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/database/tables/tables.dart';

part 'recent_searches_dao.g.dart';

/// The searches the user acted on, newest first. They live in the database
/// with the rest of the user's data, so Reset demo data clears them too.
@DriftAccessor(tables: [RecentSearches])
class RecentSearchesDao extends DatabaseAccessor<AppDatabase>
    with _$RecentSearchesDaoMixin {
  RecentSearchesDao(super.attachedDatabase);

  /// How many are kept.
  static const limit = 10;

  /// Newest first, at most [limit].
  Stream<List<String>> watch() =>
      (select(recentSearches)
            ..orderBy([
              (r) => OrderingTerm(
                expression: r.searchedAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(limit))
          .map((row) => row.query)
          .watch();

  /// Puts [query] first, in one transaction: an earlier search that differs
  /// only in case is replaced ("Jazz" after "jazz" is one entry), and the
  /// oldest beyond [limit] go.
  Future<void> save(String query, DateTime at) => transaction(() async {
    await (delete(
      recentSearches,
    )..where((r) => r.query.lower().equals(query.toLowerCase()))).go();
    await into(recentSearches)
        .insert(RecentSearchRow(query: query, searchedAt: at));
    final kept =
        await (selectOnly(recentSearches)
              ..addColumns([recentSearches.query])
              ..orderBy([
                OrderingTerm(
                  expression: recentSearches.searchedAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(limit))
            .map((row) => row.read(recentSearches.query)!)
            .get();
    await (delete(recentSearches)..where((r) => r.query.isNotIn(kept))).go();
  });

  Future<void> clear() => delete(recentSearches).go();
}
