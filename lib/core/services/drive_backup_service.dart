import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'google_auth_client.dart';

class DriveBackupService {
  // 1. The scopes we need
  final _scopes = [drive.DriveApi.driveAppdataScope];

  // 2. Setup the Google Sign In instance with your new Web Client ID
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  /// Authenticates the user and returns the Drive API ready to use
  Future<drive.DriveApi?> _getDriveApi() async {
    GoogleSignInAccount? user;

    try {
      if (!_isInitialized) {
        await _googleSignIn.initialize(
          // Pass the client ID securely via build command:
          // flutter build apk --dart-define=WEB_CLIENT_ID=your_id.apps.googleusercontent.com
          serverClientId: const String.fromEnvironment(
            'WEB_CLIENT_ID',
            defaultValue: 'YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com',
          ),
        );
        _isInitialized = true;  
      }

      // Try to sign in silently (if they've logged in before)
      user = await _googleSignIn.attemptLightweightAuthentication();

      // If not, trigger the actual bottom-sheet popup
      user ??= await _googleSignIn.authenticate();

      // In v7+, we request scopes explicitly via the authorizationClient
      var auth = await user.authorizationClient.authorizationForScopes(_scopes);
      auth ??= await user.authorizationClient.authorizeScopes(_scopes);

      // Get the secure headers
      final headers = await user.authorizationClient.authorizationHeaders(
        _scopes,
      );
      if (headers == null) {
        throw Exception('Failed to get authorization headers.');
      }

      final authenticateClient = GoogleAuthClient(headers);
      return drive.DriveApi(authenticateClient);
    } catch (e) {
      // Re-throw so the UI (SnackBar) can display exactly what went wrong
      throw Exception('Auth Error: $e');
    }
  }

  /// Uploads the local Drift SQLite database to Google Drive
  Future<void> backupDatabaseToDrive() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return;

    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'db.sqlite'));

    if (!await dbFile.exists()) {
      throw Exception('No local database found to backup.');
    }

    // Check if backup already exists
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'seuraplay_backup.sqlite'",
    );

    final media = drive.Media(dbFile.openRead(), dbFile.lengthSync());

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      // Overwrite the first existing backup found
      final existingFileId = fileList.files!.first.id!;
      final driveFile = drive.File(); // No need to set name/parents for update
      await driveApi.files.update(driveFile, existingFileId, uploadMedia: media);
    } else {
      // Create a new backup file if none exists
      final driveFile = drive.File()
        ..name = 'seuraplay_backup.sqlite'
        ..parents = ['appDataFolder'];
      await driveApi.files.create(driveFile, uploadMedia: media);
    }
  }

  /// Downloads the backup from Google Drive and overwrites the local database
  Future<void> restoreDatabaseFromDrive() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return;

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'seuraplay_backup.sqlite'",
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception('No backup found in your Google Drive.');
    }

    final backupFileId = fileList.files!.first.id!;

    final drive.Media response =
        await driveApi.files.get(
              backupFileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final dbFolder = await getApplicationDocumentsDirectory();
    final saveFile = File(p.join(dbFolder.path, 'db.sqlite'));

    final sink = saveFile.openWrite();
    await response.stream.pipe(sink);
    await sink.close();
  }

  /// Signs out and disconnects the Google account
  Future<void> signOut() async {
    try {
      if (!_isInitialized) {
        await _googleSignIn.initialize(
          // Pass the client ID securely via build command:
          // flutter build apk --dart-define=WEB_CLIENT_ID=your_id.apps.googleusercontent.com
          serverClientId: const String.fromEnvironment(
            'WEB_CLIENT_ID',
            defaultValue: 'YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com',
          ),
        );
        _isInitialized = true;
      }
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      throw Exception('Sign Out Error: $e');
    }
  }
}
