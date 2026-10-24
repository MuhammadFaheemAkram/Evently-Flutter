import 'package:clock/clock.dart';
import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FakeEventlyApi api(NetworkSimulator network) => FakeEventlyApi(
    AssetJsonLoader(rootBundle),
    network,
    Clock.fixed(demoNow),
  );

  test('serves the bundled catalog, as of its clock', () async {
    final catalog = await api(NetworkSimulator(latency: Duration.zero))
        .fetchCatalog();

    expect(catalog.events, hasLength(25));
    final meetup = catalog.events.firstWhere(
      (e) => e.id == 'ev_flutter_london_meetup',
    );
    expect(meetup.startsAt, DateTime.utc(2026, 10, 21, 17, 30));
  });

  test('serves the demo user', () async {
    final user = await api(NetworkSimulator(latency: Duration.zero))
        .fetchDemoUser();

    expect(user.profile?.name, 'Sara Ahmed');
    expect(user.tickets, hasLength(4));
  });

  test('takes 700 ms, like a real request', () {
    fakeAsync((async) {
      final network = NetworkSimulator();
      var done = false;
      network().then((_) => done = true);

      async.elapse(const Duration(milliseconds: 699));
      expect(done, isFalse);
      async.elapse(const Duration(milliseconds: 1));
      expect(done, isTrue);
    });
  });

  test("fails on request, with the app's network error", () async {
    final network = NetworkSimulator(latency: Duration.zero)
      ..failRequests = true;

    await expectLater(
      api(network).fetchCatalog(),
      throwsA(isA<NetworkException>()),
    );
    await expectLater(
      api(network).fetchDemoUser(),
      throwsA(isA<NetworkException>()),
    );
  });
}
