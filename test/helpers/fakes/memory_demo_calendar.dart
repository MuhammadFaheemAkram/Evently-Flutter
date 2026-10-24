import 'package:clock/clock.dart';
import 'package:evently/core/network/demo_calendar.dart';

/// The server's calendar in memory: anchored at the first read, or at
/// [anchoredAt] when given.
class MemoryDemoCalendar implements DemoCalendar {
  MemoryDemoCalendar(this.clock, {this.anchoredAt});

  final Clock clock;
  DateTime? anchoredAt;

  @override
  DateTime anchor() => anchoredAt ??= clock.now().toUtc();

  @override
  Future<void> restart() async => anchoredAt = clock.now().toUtc();
}
