import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/drive_backup_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

// Provides a single instance of secure storage
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

// Fetches the auto backup status so the UI can display it
final autoBackupProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_auto_backup_enabled') ?? false;
});

class SettingsState {
  final bool isBackingUp;
  final bool isRestoring;
  final bool isLocalBackingUp;
  final bool isLocalRestoring;
  final bool isSigningOutCloud;
  final bool isTogglingAutoBackup;

  SettingsState({
    this.isBackingUp = false,
    this.isRestoring = false,
    this.isLocalBackingUp = false,
    this.isLocalRestoring = false,
    this.isSigningOutCloud = false,
    this.isTogglingAutoBackup = false,
  });

  SettingsState copyWith({
    bool? isBackingUp,
    bool? isRestoring,
    bool? isLocalBackingUp,
    bool? isLocalRestoring,
    bool? isSigningOutCloud,
    bool? isTogglingAutoBackup,
  }) {
    return SettingsState(
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      isLocalBackingUp: isLocalBackingUp ?? this.isLocalBackingUp,
      isLocalRestoring: isLocalRestoring ?? this.isLocalRestoring,
      isSigningOutCloud: isSigningOutCloud ?? this.isSigningOutCloud,
      isTogglingAutoBackup: isTogglingAutoBackup ?? this.isTogglingAutoBackup,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(SettingsState());



  Future<void> toggleAutoBackup(bool enable) async {
    state = state.copyWith(isTogglingAutoBackup: true);
    try {
      if (enable) {
        // Authenticate first before enabling auto backup
        final driveService = DriveBackupService();
        await driveService.authenticate();
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_auto_backup_enabled', enable);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isTogglingAutoBackup: false);
    }
  }

  Future<void> signOutCloud() async {
    state = state.copyWith(isSigningOutCloud: true);
    try {
      final driveService = DriveBackupService();
      await driveService.signOut();
      
      // Also disable auto backup on sign out
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_auto_backup_enabled', false);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isSigningOutCloud: false);
    }
  }

  Future<void> manualBackup() async {
    state = state.copyWith(isBackingUp: true);
    try {
      final driveService = DriveBackupService();
      await driveService.backupDatabaseToDrive();
    } catch (e) {
      // Re-throw so the UI can catch it
      rethrow; 
    } finally {
      state = state.copyWith(isBackingUp: false);
    }
  }

  Future<void> manualRestore() async {
    state = state.copyWith(isRestoring: true);
    try {
      final driveService = DriveBackupService();
      await driveService.restoreDatabaseFromDrive();
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isRestoring: false);
    }
  }

  Future<void> manualLocalBackup() async {
    state = state.copyWith(isLocalBackingUp: true);
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dbFolder.path, 'db.sqlite'));

      if (!await dbFile.exists()) {
        throw Exception('No local database found to backup.');
      }

      final dbBytes = await dbFile.readAsBytes();
      
      final savedUri = await FilePicker.saveFile(
        dialogTitle: 'Save Backup',
        fileName: 'seuraplay_backup.sqlite',
        bytes: dbBytes,
      );

      if (savedUri == null) {
        return; // User canceled
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLocalBackingUp: false);
    }
  }

  Future<void> manualLocalRestore() async {
    state = state.copyWith(isLocalRestoring: true);
    try {
      PlatformFile? result = await FilePicker.pickFile();
      if (result != null && result.path != null) {
        final backupFile = File(result.path!);
        final dbFolder = await getApplicationDocumentsDirectory();
        final saveFile = File(p.join(dbFolder.path, 'db.sqlite'));

        await backupFile.copy(saveFile.path);
      } else {
        return; // User canceled
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLocalRestoring: false);
    }
  }
}

final settingsControllerProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});