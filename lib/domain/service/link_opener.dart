/// Opens a link outside the app: a maps app for directions, a meeting app
/// (or the browser) for an online event's join link. An interface, so tests
/// can record what would have opened.
abstract interface class LinkOpener {
  /// `false` if the system couldn't open it.
  Future<bool> open(Uri url);
}
