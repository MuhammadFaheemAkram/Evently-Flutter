import 'package:evently/background/background_entry.dart';
import 'package:evently/domain/service/background_work.dart';
import 'package:injectable/injectable.dart';
import 'package:workmanager/workmanager.dart';

/// The periodic sync, with `workmanager`: Android's WorkManager and iOS's
/// BGTaskScheduler behind one API.
///
/// - **Android:** a periodic WorkManager job, about every 6 hours (the
///   system decides exactly: Doze and App Standby defer it), only with a
///   network (a sync without one can't fetch) and while the battery isn't
///   low. It survives reboots and app updates.
/// - **iOS:** a `BGAppRefreshTask` with the identifier [syncTask], which
///   `Info.plist` must permit (`BGTaskSchedulerPermittedIdentifiers`) and
///   `AppDelegate` registers at launch. iOS runs it when it sees fit, and
///   less often for an app the user rarely opens; 6 hours is only the
///   earliest.
@LazySingleton(as: BackgroundWork)
class WorkmanagerBackgroundWork implements BackgroundWork {
  const WorkmanagerBackgroundWork();

  static const frequency = Duration(hours: 6);

  @override
  Future<void> registerSync() async {
    final workmanager = Workmanager();
    await workmanager.initialize(callbackDispatcher);
    // The same name for the unique work and the task, so both platforms
    // hand the dispatcher the same string.
    await workmanager.registerPeriodicTask(
      syncTask,
      syncTask,
      frequency: frequency,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }
}
