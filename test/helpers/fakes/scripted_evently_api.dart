import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';

/// An [EventlyApi] whose every answer is scripted: each fetch takes the
/// next reply of its own list (a DTO to return, or anything else to throw)
/// and, after the script, repeats the last. Without a script it delegates
/// to [real].
class ScriptedEventlyApi implements EventlyApi {
  ScriptedEventlyApi(
    this.real, {
    List<Object> catalog = const [],
    List<Object> demoUser = const [],
  }) : _catalog = [...catalog],
       _demoUser = [...demoUser];

  final EventlyApi real;
  final List<Object> _catalog;
  final List<Object> _demoUser;
  var catalogCalls = 0;
  var demoUserCalls = 0;

  /// From now on, answer as [real] does.
  void recover() {
    _catalog.clear();
    _demoUser.clear();
  }

  @override
  Future<CatalogDto> fetchCatalog() async {
    final reply = _next(_catalog, catalogCalls++);
    if (reply == null) return real.fetchCatalog();
    if (reply is CatalogDto) return reply;
    throw reply;
  }

  @override
  Future<DemoUserDto> fetchDemoUser() async {
    final reply = _next(_demoUser, demoUserCalls++);
    if (reply == null) return real.fetchDemoUser();
    if (reply is DemoUserDto) return reply;
    throw reply;
  }

  static Object? _next(List<Object> script, int call) =>
      script.isEmpty ? null : script[call.clamp(0, script.length - 1)];
}
