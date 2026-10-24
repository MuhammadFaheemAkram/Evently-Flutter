import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/result_matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// A stack whose server answers the catalog with [reply], its cache
  /// already holding one event, "Before".
  Future<DataStack> cachedThenServing(Object reply) async {
    final stack = DataStack(
      api: (real) => ScriptedEventlyApi(real, catalog: [reply]),
    );
    addTearDown(stack.close);
    await stack.db.catalogDao.upsertCatalog(
      catalogOf([event(title: 'Before')]).toRows(),
    );
    return stack;
  }

  Future<List<(String, String)>> cached(DataStack stack) async => [
    for (final row in (await stack.db.catalogDao.readAll()).events)
      (row.id, row.title),
  ];

  test(
    'fetches the catalog into the cache, and says how many events',
    () async {
      final stack = DataStack();
      addTearDown(stack.close);

      expect(await stack.catalog.refresh(), isOk(25));
      expect(await cached(stack), hasLength(25));
      expect(await stack.catalog.cities(), [
        'Berlin',
        'Lahore',
        'London',
        'New York',
      ]);
    },
  );

  group('a failed refresh leaves the cache as it was', () {
    test('offline: the network error, as is', () async {
      final stack = await cachedThenServing(const NetworkException());

      expect(await stack.catalog.refresh(), isErr<NetworkException>());
      expect(await cached(stack), [('ev_1', 'Before')]);
    });

    test('malformed JSON: damaged data', () async {
      final stack = await cachedThenServing(_checkedFromJsonError());

      expect(await stack.catalog.refresh(), isErr<DataFormatException>());
      expect(await cached(stack), [('ev_1', 'Before')]);
    });

    test('a broken rule (an event that ends as it starts): damaged data, '
        'and none of the catalog written', () async {
      final broken = eventJson(id: 'ev_2')
        ..['endsAt'] = eventJson()['startsAt'];
      final stack = await cachedThenServing(
        CatalogDto.fromJson(catalogJson(events: [eventJson(), broken])),
      );

      expect(await stack.catalog.refresh(), isErr<DataFormatException>());
      expect(await cached(stack), [('ev_1', 'Before')]);
    });

    test('a database failure: something went wrong', () async {
      final stack = DataStack();
      addTearDown(stack.close);
      // Not closing it: drift would just open it again.
      await stack.db.customStatement('DROP TABLE ticket_offers');

      expect(await stack.catalog.refresh(), isErr<UnknownException>());
    });
  });

  test('a later refresh succeeds after a failed one', () async {
    final stack = await cachedThenServing(const NetworkException());
    await stack.catalog.refresh();
    (stack.api as ScriptedEventlyApi).recover();

    expect(await stack.catalog.refresh(), isOk(25));
  });
}

/// What the DTO throws for a field of the wrong type.
CheckedFromJsonException _checkedFromJsonError() {
  try {
    CatalogDto.fromJson({'organizers': 'none', 'events': <Object>[]});
  } on CheckedFromJsonException catch (error) {
    return error;
  }
  throw StateError('expected the DTO to refuse it');
}
