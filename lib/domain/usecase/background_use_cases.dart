import 'package:evently/core/common/result.dart';
import 'package:evently/domain/model/planned_notification.dart';
import 'package:evently/domain/repository/catalog_repository.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:injectable/injectable.dart';

/// What one background sync did.
final class BackgroundSyncReport {
  const BackgroundSyncReport({
    required this.refresh,
    required this.alerted,
    required this.notifications,
  });

  /// The catalog's size, or why it couldn't be fetched.
  final Result<int> refresh;

  /// Change alerts shown.
  final int alerted;
  final Result<NotificationSyncReport> notifications;
}

/// The periodic sync, run by the OS in a background isolate (and by
/// Settings → Developer → Run background sync now):
/// 1. **refresh** the catalog, which records the moves and cancellations
///    of events you hold tickets for, in the same transaction;
/// 2. **alert** the recorded changes not alerted yet, once each;
/// 3. **re-plan** the notifications, so a moved event's reminder moves with
///    it and the seven-day window keeps rolling even if the app isn't
///    opened for days.
///
/// Each step runs whatever the others did: offline, the refresh fails, but
/// changes recorded earlier are still alerted and the plan still rolls on.
/// Nothing is retried in a loop: the next run tries again.
///
/// When this runs isn't guaranteed: Android's WorkManager defers work in
/// Doze and to batch it with other apps; iOS's BGTaskScheduler runs it when
/// it judges best, or rarely for an app the user seldom opens. So nothing
/// here is time-critical: the reminders themselves are already scheduled
/// with the OS, days ahead.
@injectable
class RunBackgroundSyncUseCase {
  const RunBackgroundSyncUseCase(
    this._catalog,
    this._alertChanges,
    this._syncNotifications,
  );

  final CatalogRepository _catalog;
  final AlertCatalogChangesUseCase _alertChanges;
  final SyncNotificationsUseCase _syncNotifications;

  Future<BackgroundSyncReport> call() async {
    final refresh = await _catalog.refresh();
    final alerted = await _alertChanges();
    final notifications = await _syncNotifications();
    return BackgroundSyncReport(
      refresh: refresh,
      alerted: alerted,
      notifications: notifications,
    );
  }
}
