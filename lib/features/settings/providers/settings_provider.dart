import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/services/drive_backup_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

// Provides a single instance of secure storage
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

// Fetches the saved token so the UI can display it
final tmdbTokenProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  return await storage.read(key: 'user_tmdb_token') ?? '';
});

class SettingsState {
  final bool isSavingToken;
  final bool isBackingUp;
  final bool isRestoring;
  final bool isLocalBackingUp;
  final bool isLocalRestoring;
  final bool isSigningOutCloud;

  SettingsState({
    this.isSavingToken = false,
    this.isBackingUp = false,
    this.isRestoring = false,
    this.isLocalBackingUp = false,
    this.isLocalRestoring = false,
    this.isSigningOutCloud = false,
  });

  SettingsState copyWith({
    bool? isSavingToken,
    bool? isBackingUp,
    bool? isRestoring,
    bool? isLocalBackingUp,
    bool? isLocalRestoring,
    bool? isSigningOutCloud,
  }) {
    return SettingsState(
      isSavingToken: isSavingToken ?? this.isSavingToken,
      isBackingUp: isBackingUp ?? this.isBackingUp,
      isRestoring: isRestoring ?? this.isRestoring,
      isLocalBackingUp: isLocalBackingUp ?? this.isLocalBackingUp,
      isLocalRestoring: isLocalRestoring ?? this.isLocalRestoring,
      isSigningOutCloud: isSigningOutCloud ?? this.isSigningOutCloud,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  final FlutterSecureStorage _storage;
  
  SettingsController(this._storage) : super(SettingsState());

  Future<void> saveToken(String token) async {
    state = state.copyWith(isSavingToken: true);
    await _storage.write(key: 'user_tmdb_token', value: token.trim());
    state = state.copyWith(isSavingToken: false);
  }

  Future<void> signOutCloud() async {
    state = state.copyWith(isSigningOutCloud: true);
    try {
      final driveService = DriveBackupService();
      await driveService.signOut();
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
  return SettingsController(ref.watch(secureStorageProvider));
});