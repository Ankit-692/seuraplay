import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../database/database.dart';
import '../network/tmdb_repository.dart';
import '../../features/library/repositories/library_repository.dart';
import 'drive_backup_service.dart';
import '../config/api_keys.dart';

class SyncService {
  /// This function runs the entire update process.
  /// It is designed to be safe to call from a background isolate.
  static Future<void> performDailySync() async {
    if (kDebugMode) print('Starting daily background sync...');

    // 1. Manually initialize dependencies for the background isolate
    final db = AppDatabase();

    // NOTE: Update this URL if you are using the Cloudflare proxy!
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.tmdb.org/3',
        headers: {
          'Authorization': 'Bearer $tmdbApiKey',
          'accept': 'application/json',
        },
      ),
    );

    final tmdbRepo = TmdbRepository(dio);
    final libraryRepo = LibraryRepository(db, tmdbRepo);

    try {
      // 2. TMDB Update: Find all shows the user is currently watching
      final watchingShows = await (db.select(
        db.tvShows,
      )..where((tbl) => tbl.status.equals('watching'))).get();

      // Loop through and update them to fetch new seasons/episodes
      for (var show in watchingShows) {
        if (kDebugMode) print('Updating TMDB data for: ${show.title}');
        try {
          await libraryRepo.addTvShow(show.id);
        } catch (e) {
          if (kDebugMode) print('TMDB Update failed for ${show.title}: $e');
          // We continue to the next show instead of failing the whole sync
        }
      }
    } catch (e) {
      if (kDebugMode) print('Failed to fetch watching shows for TMDB update: $e');
    }

    try {
      // 3. Google Drive Backup
      final prefs = await SharedPreferences.getInstance();
      final isAutoBackupEnabled =
          prefs.getBool('is_auto_backup_enabled') ?? false;

      if (isAutoBackupEnabled) {
        if (kDebugMode) print('Starting Google Drive backup...');
        final driveService = DriveBackupService();
        await driveService.backupDatabaseToDrive(isSilent: true);
      } else {
        if (kDebugMode) print('Skipping Google Drive backup (auto-backup disabled).');
      }

      if (kDebugMode) print('Daily sync completed successfully!');
    } catch (e) {
      if (kDebugMode) print('Daily sync backup failed: $e');
    } finally {
      // Close the DB connection so the background isolate doesn't hold it hostage
      await db.close();
    }
  }

  /// Checks if auto-backup is enabled and if 24 hours have passed since the last backup.
  /// If so, runs performDailySync in the background.
  static Future<void> checkAndRunAutoSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAutoBackupEnabled =
          prefs.getBool('is_auto_backup_enabled') ?? false;

      if (!isAutoBackupEnabled) return;

      final lastSyncString = prefs.getString('last_auto_backup_time');
      if (lastSyncString != null) {
        final lastSyncTime = DateTime.tryParse(lastSyncString);
        if (lastSyncTime != null) {
          final difference = DateTime.now().difference(lastSyncTime);
          if (difference.inHours < 24) {
            // Less than 24 hours have passed, skip sync
            if (kDebugMode) {
              print(
                'Auto-sync skipped: Last sync was ${difference.inHours} hours ago.',
              );
            }
            return;
          }
        }
      }

      if (kDebugMode) print('Triggering on-launch auto-sync...');
      await performDailySync();

      // Update the last sync time
      await prefs.setString(
        'last_auto_backup_time',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      if (kDebugMode) print('Auto-sync check failed: $e');
    }
  }
}
