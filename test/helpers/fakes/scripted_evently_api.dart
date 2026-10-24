import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';

/// An [EventlyApi] whose every answer is scripted: each call takes the
/// next reply of its own list (a DTO to return, or anything else to throw)
/// and, after the script, repeats the last. Without a script it delegates
/// to [real].
class ScriptedEventlyApi implements EventlyApi {
  ScriptedEventlyApi(
    this.real, {
    List<Object> catalog = const [],
    List<Object> demoUser = const [],
    List<Object> rsvp = const [],
    List<Object> cancel = const [],
  }) : _catalog = [...catalog],
       _demoUser = [...demoUser],
       _rsvp = [...rsvp],
       _cancel = [...cancel];

  final EventlyApi real;
  final List<Object> _catalog;
  final List<Object> _demoUser;
  final List<Object> _rsvp;
  final List<Object> _cancel;
  var catalogCalls = 0;
  var demoUserCalls = 0;
  var rsvpCalls = 0;
  var cancelCalls = 0;

  /// From now on, answer as [real] does.
  void recover() {
    _catalog.clear();
    _demoUser.clear();
    _rsvp.clear();
    _cancel.clear();
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

  @override
  Future<BookingDto> rsvp(RsvpRequestDto request) async {
    final reply = _next(_rsvp, rsvpCalls++);
    if (reply == null) return real.rsvp(request);
    if (reply is BookingDto) return reply;
    throw reply;
  }

  @override
  Future<EventDto> cancelRsvp(CancelRequestDto request) async {
    final reply = _next(_cancel, cancelCalls++);
    if (reply == null) return real.cancelRsvp(request);
    if (reply is EventDto) return reply;
    throw reply;
  }

  static Object? _next(List<Object> script, int call) =>
      script.isEmpty ? null : script[call.clamp(0, script.length - 1)];
}
