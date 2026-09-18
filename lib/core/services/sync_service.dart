import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../database/database.dart';
import '../network/tmdb_repository.dart';
import '../../features/library/repositories/library_repository.dart';
import 'drive_backup_service.dart';

class SyncService {
  /// This function runs the entire update process.
  /// It is designed to be safe to call from a background isolate.
  static Future<void> performDailySync() async {
    print('Starting daily background sync...');

    // 1. Manually initialize dependencies for the background isolate
    final db = AppDatabase();
    const secureStorage = FlutterSecureStorage();

    // NOTE: Update this URL if you are using the Cloudflare proxy!
    final userTmdbToken =
        await secureStorage.read(key: 'user_tmdb_token') ?? '';
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.tmdb.org/3',
        headers: {
          'Authorization': 'Bearer $userTmdbToken',
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
        print('Updating TMDB data for: ${show.title}');
        await libraryRepo.addTvShow(show.id);
      }

      // 3. Google Drive Backup
      final prefs = await SharedPreferences.getInstance();
      final isAutoBackupEnabled = prefs.getBool('is_auto_backup_enabled') ?? false;

      if (isAutoBackupEnabled) {
        print('Starting Google Drive backup...');
        final driveService = DriveBackupService();
        await driveService.backupDatabaseToDrive();
      } else {
        print('Skipping Google Drive backup (auto-backup disabled).');
      }

      print('Daily sync completed successfully!');
    } catch (e) {
      print('Daily sync failed: $e');
    } finally {
      // Close the DB connection so the background isolate doesn't hold it hostage
      await db.close();
    }
  }
}
