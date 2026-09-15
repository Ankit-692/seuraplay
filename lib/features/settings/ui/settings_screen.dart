import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../../core/utils/app_toasts.dart';
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokenAsync = ref.watch(tmdbTokenProvider);
    final settingsState = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);

    // Initialize the text field once the token is loaded
    tokenAsync.whenData((token) {
      if (_tokenController.text.isEmpty && token.isNotEmpty) {
        _tokenController.text = token;
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- TMDB API KEY SECTION ---
          const Text(
            'TMDB API Key',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seuraplay requires a free TMDB Read Access Token to fetch show data. We never store this key on any server.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tokenController,
            obscureText: true, // Hides the token like a password
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Paste your API Read Access Token (v4) here',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: settingsState.isSavingToken
                ? null
                : () async {
                    await settingsController.saveToken(_tokenController.text);
                    if (context.mounted) {
                      // Refresh the Riverpod provider that holds the Dio client
                      // so it immediately uses the new token!
                      ref.invalidate(tmdbTokenProvider);
                      AppToasts.showSuccess(context, 'API Key saved successfully!');
                    }
                  },
            child: settingsState.isSavingToken
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Text(
                    'Save API Key',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),

          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 24),

          // --- LOCAL BACKUP SECTION ---
          const Text(
            'Local Backup',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save your data locally to your device or restore from a previously saved file.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),

          ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.save_alt_rounded,
              color: Colors.white,
            ),
            title: const Text('Create Local Backup'),
            subtitle: const Text(
              'Save current library to your device',
              style: TextStyle(fontSize: 12),
            ),
            trailing: settingsState.isLocalBackingUp
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
            onTap: settingsState.isLocalBackingUp
                ? null
                : () async {
                    try {
                      await settingsController.manualLocalBackup();
                      if (context.mounted) {
                        AppToasts.showSuccess(context, 'Local backup complete!');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppToasts.showError(context, e.toString());
                      }
                    }
                  },
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.restore_page_rounded,
              color: Colors.white,
            ),
            title: const Text('Restore from Local Backup'),
            subtitle: const Text(
              'Overwrite local library with a local backup file',
              style: TextStyle(fontSize: 12),
            ),
            trailing: settingsState.isLocalRestoring
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
            onTap: settingsState.isLocalRestoring
                ? null
                : () async {
                    try {
                      await settingsController.manualLocalRestore();
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Theme.of(context).cardColor,
                            title: const Text('Restore Complete'),
                            content: const Text(
                              'Please completely close and restart Seuraplay to load your restored data.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppToasts.showError(context, e.toString());
                      }
                    }
                  },
          ),

          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 24),

          // --- GOOGLE DRIVE BACKUP SECTION ---
          const Text(
            'Cloud Backup',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your data is automatically synced to a hidden folder in your Google Drive every 24 hours. You can also force a sync manually below.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),

          ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.cloud_upload_rounded,
              color: Colors.white,
            ),
            title: const Text('Backup Now'),
            subtitle: const Text(
              'Upload current library to Drive',
              style: TextStyle(fontSize: 12),
            ),
            trailing: settingsState.isBackingUp
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
            onTap: settingsState.isBackingUp
                ? null
                : () async {
                    try {
                      await settingsController.manualBackup();
                      if (context.mounted) {
                        AppToasts.showSuccess(context, 'Backup complete!');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppToasts.showError(context, e.toString());
                      }
                    }
                  },
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.cloud_download_rounded,
              color: Colors.white,
            ),
            title: const Text('Restore from Backup'),
            subtitle: const Text(
              'Overwrite local library with Drive data',
              style: TextStyle(fontSize: 12),
            ),
            trailing: settingsState.isRestoring
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
            onTap: settingsState.isRestoring
                ? null
                : () async {
                    try {
                      await settingsController.manualRestore();
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Theme.of(context).cardColor,
                            title: const Text('Restore Complete'),
                            content: const Text(
                              'Please completely close and restart Seuraplay to load your restored data.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppToasts.showError(context, e.toString());
                      }
                    }
                  },
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            title: const Text('Sign out of Google Drive'),
            subtitle: const Text(
              'Disconnect current account to choose another',
              style: TextStyle(fontSize: 12),
            ),
            trailing: settingsState.isSigningOutCloud
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
            onTap: settingsState.isSigningOutCloud
                ? null
                : () async {
                    try {
                      await settingsController.signOutCloud();
                      if (context.mounted) {
                        AppToasts.showSuccess(context, 'Signed out successfully.');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppToasts.showError(context, e.toString());
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}
