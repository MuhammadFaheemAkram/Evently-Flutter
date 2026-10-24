import 'package:evently/background/background_entry.dart';
import 'package:evently/background/background_graph.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/usecase/background_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workmanager/workmanager.dart';

class _MockRunSync extends Mock implements RunBackgroundSyncUseCase {}

// The background entry point's dispatch, with a graph of fakes: the real
// graph needs the platform (the database file, the plugins).
void main() {
  late _MockRunSync runSync;
  late List<String> log;

  setUp(() {
    runSync = _MockRunSync();
    log = [];
    when(runSync.call).thenAnswer((_) async {
      log.add('run');
      return const BackgroundSyncReport(
        refresh: Ok(25),
        alerted: 0,
        notifications: Ok(NotificationSyncReport(enabled: false)),
      );
    });
  });

  Future<BackgroundGraph> openGraph() async {
    log.add('open');
    return BackgroundGraph(
      runSync: runSync,
      close: () async => log.add('close'),
    );
  }

  test('the sync task: open the graph, run the sync, close', () async {
    expect(await dispatchBackgroundTask(syncTask, openGraph), isTrue);

    expect(log, ['open', 'run', 'close']);
  });

  test("iOS's generic background fetch runs the sync too", () async {
    expect(
      await dispatchBackgroundTask(Workmanager.iOSBackgroundTask, openGraph),
      isTrue,
    );

    expect(log, ['open', 'run', 'close']);
  });

  test('an unknown task (from an older version) is done at once', () async {
    expect(await dispatchBackgroundTask('old.task', openGraph), isTrue);

    expect(log, isEmpty);
  });

  test('a failing sync still closes the graph, and reports done: the next '
      'run tries again, rather than a retry with backoff', () async {
    when(runSync.call).thenAnswer((_) async {
      log.add('run');
      throw StateError('database locked');
    });

    expect(await dispatchBackgroundTask(syncTask, openGraph), isTrue);

    expect(log, ['open', 'run', 'close']);
  });

  test('a graph that fails to open: done, nothing run', () async {
    expect(
      await dispatchBackgroundTask(
        syncTask,
        () => Future.error(StateError('no plugins')),
      ),
      isTrue,
    );
    verifyNever(runSync.call);
  });
}
