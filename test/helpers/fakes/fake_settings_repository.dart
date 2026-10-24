import 'dart:async';

import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/repository/settings_repository.dart';

/// Settings in memory, with the real repository's watch behaviour, and a
/// count of the writes. [stored] plays what another isolate saved: [reload]
/// publishes it.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([this._current = const AppSettings()]);

  AppSettings _current;
  final _changes = StreamController<AppSettings>.broadcast(sync: true);

  /// How many times [update] ran.
  var writes = 0;

  /// What [reload] reads, when set.
  AppSettings? stored;

  @override
  AppSettings get current => _current;

  @override
  Stream<AppSettings> watch() => Stream.multi((watcher) {
    final subscription = _changes.stream.listen(watcher.add);
    watcher
      ..onCancel = subscription.cancel
      ..add(_current);
  });

  @override
  Future<void> update(AppSettings Function(AppSettings settings) change) async {
    writes++;
    _current = change(_current);
    _changes.add(_current);
  }

  @override
  Future<void> reload() async {
    final settings = stored;
    if (settings == null || settings == _current) return;
    _current = settings;
    _changes.add(settings);
  }
}
