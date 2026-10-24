import 'package:evently/core/common/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/result_matchers.dart';
import '../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  setUp(() async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.catalog.refresh();
  });

  Future<bool> isSaved(String eventId) async =>
      (await stack.catalog.watchEventCards().first)
          .singleWhere((card) => card.event.id == eventId)
          .isSaved;

  test('saves and unsaves, stamped with the clock', () async {
    expect(await stack.savedEvents.save('ev_jazz_vaults'), isOk());
    expect(await isSaved('ev_jazz_vaults'), isTrue);
    final row = await stack.db.select(stack.db.savedEvents).getSingle();
    expect(row.savedAt, demoNow);

    expect(await stack.savedEvents.unsave('ev_jazz_vaults'), isOk());
    expect(await isSaved('ev_jazz_vaults'), isFalse);
  });

  test('works offline: no server is asked', () async {
    final offline = DataStack(
      api: (real) =>
          ScriptedEventlyApi(real, catalog: [const NetworkException()]),
    );
    addTearDown(offline.close);
    await offline.db.catalogDao.upsertCatalog(
      (await stack.db.catalogDao.readAll()),
    );

    expect(await offline.savedEvents.save('ev_jazz_vaults'), isOk());
    expect((offline.api as ScriptedEventlyApi).catalogCalls, 0);
  });

  test(
    'an event the cache lacks: something went wrong, nothing saved',
    () async {
      expect(
        await stack.savedEvents.save('ev_nowhere'),
        isErr<UnknownException>(),
      );
      expect(await stack.db.select(stack.db.savedEvents).get(), isEmpty);
    },
  );
}
