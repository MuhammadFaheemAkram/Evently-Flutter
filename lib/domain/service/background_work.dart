/// The OS's scheduler for work while the app is closed (`workmanager`).
abstract interface class BackgroundWork {
  /// Registers the periodic sync. Safe at every launch: an existing
  /// registration is updated in place and keeps its timing.
  Future<void> registerSync();
}
