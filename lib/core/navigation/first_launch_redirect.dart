/// The router's only gate: Welcome until the user has started.
///
/// - Not onboarded: every location goes to `/welcome`. A deep link on the
///   very first launch (a notification can't exist yet, but a shared link
///   can) is dropped: the event it points to isn't cached yet.
/// - Onboarded: `/welcome` goes to Discover, so Back or a stale link can't show
///   it again.
///
/// A pure function of its inputs, so every rule is a one-line unit test.
/// The router re-runs it whenever the onboarding state changes
/// (`refreshListenable`), and no screen navigates after Welcome's choice.
String? firstLaunchRedirect({required bool onboarded, required Uri location}) {
  final onWelcome = location.path == welcomePath;
  if (!onboarded) return onWelcome ? null : welcomePath;
  return onWelcome ? discoverPath : null;
}

/// The two locations the gate sends people to. Typed routes produce the same
/// strings; plain constants keep this file free of widgets.
const welcomePath = '/welcome';
const discoverPath = '/discover';
