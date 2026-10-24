import 'package:clock/clock.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/core/network/seed_renderer.dart';
import 'package:injectable/injectable.dart';

/// Plays the server: renders its seed files as of now ([SeedRenderer])
/// after a simulated network delay (700 ms) that can also fail on request.
///
/// In memory, reset on every launch: a fake backend only shows how the app
/// talks to one. Phase 5 adds the server's own state (places left after a
/// booking, the tickets it issued).
@LazySingleton(as: EventlyApi)
class FakeEventlyApi implements EventlyApi {
  const FakeEventlyApi(this._json, this._network, this._clock);

  static const catalogPath = 'assets/json/catalog_seed.json';
  static const demoUserPath = 'assets/json/demo_user.json';

  final AssetJsonLoader _json;
  final NetworkSimulator _network;
  final Clock _clock;

  @override
  Future<CatalogDto> fetchCatalog() async {
    await _network();
    final seed = await _json.loadObject(catalogPath);
    return CatalogDto.fromJson(SeedRenderer.catalog(seed, _clock.now()));
  }

  @override
  Future<DemoUserDto> fetchDemoUser() async {
    await _network();
    final seed = await _json.loadObject(demoUserPath);
    return DemoUserDto.fromJson(SeedRenderer.demoUser(seed, _clock.now()));
  }
}
