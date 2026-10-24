import 'dart:async';

import 'package:clock/clock.dart';
import 'package:evently/core/storage/settings_local_data_source.dart';
import 'package:injectable/injectable.dart';

/// The day the fake server's calendar starts from.
///
/// The seed says when events happen relative to a day ("in 3 days at
/// 18:30"). Rendered from *today*, every event would move a day each day,
/// and change detection would rightly report every ticket's event as
/// moved. A real server's events stay put; so the fake renders from a
/// fixed **anchor**: the moment of its first fetch, kept on the device.
/// The demo then ages like real data (events pass), until Reset demo data
/// starts the calendar again from now.
abstract interface class DemoCalendar {
  /// The instant the seed counts from (UTC).
  DateTime anchor();

  /// Starts the calendar again from now.
  Future<void> restart();
}

/// The anchor in the device's preferences, so the background isolate's
/// fake server counts from the same day as the app's.
@LazySingleton(as: DemoCalendar)
class StoredDemoCalendar implements DemoCalendar {
  StoredDemoCalendar(this._local, this._clock);

  final SettingsLocalDataSource _local;
  final Clock _clock;

  @override
  DateTime anchor() {
    final stored = DateTime.tryParse(
      _local.getString(SettingsLocalDataSource.demoAnchorKey) ?? '',
    );
    if (stored != null) return stored.toUtc();
    final now = _clock.now().toUtc();
    // The cache has it at once; the disk follows.
    unawaited(_save(now));
    return now;
  }

  @override
  Future<void> restart() => _save(_clock.now().toUtc());

  Future<void> _save(DateTime anchor) => _local.setString(
    SettingsLocalDataSource.demoAnchorKey,
    anchor.toIso8601String(),
  );
}
