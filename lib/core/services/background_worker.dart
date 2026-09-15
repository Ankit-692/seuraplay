import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'sync_service.dart';

// The exact string identifier for our task
const String dailySyncTaskName = 'seuraplay_daily_sync';

// This MUST be a top-level function outside of any class
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case dailySyncTaskName:
        await SyncService.performDailySync();
        break;
    }
    // Return true to tell the OS the task was successful
    return Future.value(true);
  });
}

class BackgroundWorker {
  /// Initializes the workmanager. Call this in main.dart.
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode, // Only show notifications in debug mode
    );
  }

  /// Schedules the background task to run once a day.
  /// Android/iOS will decide the exact minute based on battery optimization,
  /// but it will aim for a 24-hour frequency.
  static void scheduleDailySync() {
    Workmanager().registerPeriodicTask(
      'daily_sync_1', // A unique ID for this job
      dailySyncTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected, // Only run if they have internet
        requiresBatteryNotLow: true, // Don't kill their battery
      ),
    );
  }
}
