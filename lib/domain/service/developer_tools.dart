/// The developer switches, for showing what the app does when the server
/// misbehaves or changes. They talk to the fake server, so they only exist
/// because the backend is a fake.
abstract interface class DeveloperTools {
  /// Every request fails as if offline.
  bool get failingRequests;

  set failingRequests(bool fail);

  /// Makes the server's next catalogs change: an event you're going to
  /// moves, another is cancelled, one is edited and new ones appear.
  /// Returns a summary of what changed.
  Future<String> publishCatalogUpdate();

  /// Starts the server's calendar again from now: the demo's events are
  /// "in 3 days" from today again (Reset demo data).
  Future<void> restartDemoCalendar();
}
