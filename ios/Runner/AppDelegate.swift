import Flutter
import UIKit
import flutter_local_notifications
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Notifications reach the app (taps, and showing while in the
    // foreground) through the notification center's delegate: the
    // plugin's, through FlutterAppDelegate.
    UNUserNotificationCenter.current().delegate = self

    // BGTaskScheduler delivers a task only to a handler registered before
    // launching finishes. With UIScene, plugins register later (when the
    // scene connects), so the sync task's handler is registered here. Its
    // identifier is permitted in Info.plist and matches the Dart side
    // (`syncTask`).
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "co.bitfuse.flutter.evently.sync",
      earliestBeginInSeconds: NSNumber(value: 6 * 60 * 60)
    )
    WorkmanagerPlugin.registerLaunchHandlers()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Background isolates run in engines of their own, which need the
    // plugins too (the database, preferences, notifications, time zone).
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
  }
}
