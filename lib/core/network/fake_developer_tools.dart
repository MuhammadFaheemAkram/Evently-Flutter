import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/domain/service/developer_tools.dart';
import 'package:injectable/injectable.dart';

/// The developer switches, wired to the fake network and server.
@LazySingleton(as: DeveloperTools)
class FakeDeveloperTools implements DeveloperTools {
  const FakeDeveloperTools(this._network, this._server);

  final NetworkSimulator _network;
  final FakeEventlyApi _server;

  @override
  bool get failingRequests => _network.failRequests;

  @override
  set failingRequests(bool fail) => _network.failRequests = fail;

  @override
  Future<String> publishCatalogUpdate() => _server.publishUpdate();
}
