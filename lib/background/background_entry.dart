import 'dart:developer';

import 'package:evently/background/background_graph.dart';
import 'package:workmanager/workmanager.dart';

// How the OS runs Evently's code while it's closed: `workmanager` starts a
// fresh background isolate and calls [callbackDispatcher].
//
// It's a top-level function marked `@pragma('vm:entry-point')`. The OS
// starts it by name from native code, with nothing in the Dart program
// calling it; without the annotation, a release build's tree shaking would
// remove it as unused. And it can't reach the app's objects: an isolate
// shares no memory, so it builds its own `BackgroundGraph`.

/// The periodic task's name, on both platforms: the WorkManager job's and
/// the iOS BGTaskScheduler identifier (listed in `Info.plist`).
const syncTask = 'co.bitfuse.flutter.evently.sync';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, _) => dispatchBackgroundTask(task, BackgroundGraph.open),
  );
}

/// Runs [task] on a graph from [openGraph], and closes it. Always `true`:
/// a failure is logged and the next run tries again, rather than Android
/// retrying it with backoff. Unknown tasks (one from an older version) are
/// done at once.
Future<bool> dispatchBackgroundTask(
  String task,
  Future<BackgroundGraph> Function() openGraph,
) async {
  if (task != syncTask && task != Workmanager.iOSBackgroundTask) return true;
  try {
    final graph = await openGraph();
    try {
      await graph.runSync();
    } finally {
      await graph.close();
    }
  } on Object catch (error, stackTrace) {
    log('Background sync failed', error: error, stackTrace: stackTrace);
  }
  return true;
}
