import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/result_matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  DataStack stackServing({List<Object> demoUser = const []}) {
    final stack = DataStack(
      api: (real) => ScriptedEventlyApi(real, demoUser: demoUser),
    );
    addTearDown(stack.close);
    return stack;
  }

  test("writes the demo user over the catalog's events", () async {
    final stack = stackServing();
    await stack.catalog.refresh();

    expect(await stack.demo.loadDemoUser(), isOk());

    final user = (await stack.db.userDataDao.readAll()).toUserData();
    expect(user.profile?.name, 'Sara Ahmed');
    expect(user.saved, hasLength(4));
    expect(user.tickets, hasLength(4));
    expect(user.bookmarks, hasLength(3));
    expect(user.follows, hasLength(2));
  });

  test('without the catalog cached, nothing is written: a foreign key '
      'refuses the whole demo', () async {
    final stack = stackServing();

    expect(await stack.demo.loadDemoUser(), isErr<UnknownException>());
    expect((await stack.db.userDataDao.readAll()).tickets, isEmpty);
    expect((await stack.db.userDataDao.readAll()).profile, isNull);
  });

  test('offline: the network error, nothing written', () async {
    final stack = stackServing(demoUser: [const NetworkException()]);
    await stack.catalog.refresh();

    expect(await stack.demo.loadDemoUser(), isErr<NetworkException>());
    expect((await stack.db.userDataDao.readAll()).profile, isNull);
  });

  test('a broken rule: damaged data, nothing written', () async {
    final stack = stackServing(
      demoUser: [
        DemoUserDto.fromJson({
          'saved': [
            {'eventId': 'ev_jazz_vaults', 'savedAt': '2026-10-20T09:00:00Z'},
            {'eventId': 'ev_jazz_vaults', 'savedAt': '2026-10-20T09:00:00Z'},
          ],
        }),
      ],
    );
    await stack.catalog.refresh();

    expect(await stack.demo.loadDemoUser(), isErr<DataFormatException>());
    expect((await stack.db.userDataDao.readAll()).saved, isEmpty);
  });
}
