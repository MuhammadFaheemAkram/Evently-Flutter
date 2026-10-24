import 'package:clock/clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/data/repository/catalog_repository_impl.dart';
import 'package:evently/data/repository/demo_repository_impl.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/start_use_cases.dart';
import 'package:flutter/services.dart';

import 'database.dart';
import 'fakes/fake_settings_repository.dart';
import 'test_dependencies.dart';

/// The real repositories and use cases on an in-memory database, with a
/// fixed clock and the real fake API (zero latency, reading the bundled
/// JSON): what Cubit and repository tests run against instead of mocks.
///
/// Pass [api] to script the server's answers (it can wrap [realApi]).
/// Tests that read the bundled assets need
/// `TestWidgetsFlutterBinding.ensureInitialized()`.
class DataStack {
  DataStack({DateTime? now, EventlyApi Function(EventlyApi real)? api})
    : clock = Clock.fixed(now ?? demoNow),
      network = NetworkSimulator(latency: Duration.zero) {
    realApi = FakeEventlyApi(AssetJsonLoader(rootBundle), network, clock);
    this.api = api?.call(realApi) ?? realApi;
  }

  final Clock clock;
  final NetworkSimulator network;
  late final EventlyApi realApi;
  late final EventlyApi api;
  final AppDatabase db = newTestDatabase();
  final settings = FakeSettingsRepository();

  late final catalog = CatalogRepositoryImpl(api, db.catalogDao);
  late final demo = DemoRepositoryImpl(api, db.userDataDao);

  late final refreshCatalog = RefreshCatalogUseCase(catalog);
  late final listCities = ListCitiesUseCase(catalog);
  late final startWithDemo = StartWithDemoUseCase(demo, settings);
  late final startFresh = StartFreshUseCase(settings);

  Future<void> close() => db.close();
}
