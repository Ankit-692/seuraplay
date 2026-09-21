import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../../../core/utils/app_toasts.dart';
import 'warning_banner.dart';

class CloudBackupSection extends ConsumerWidget {
  const CloudBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cloud Backup',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'When you open the app, we automatically sync your library to a hidden Google Drive folder once a day. Need to force a backup right now? Just hit the manual sync below.',
          style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 16),
        const WarningBanner(
          title: 'Multi-Device Warning',
          message:
              'If you use the same Google account on multiple devices with Auto-Backup enabled, the device that syncs last will overwrite the other. To prevent data loss, only enable Auto-Backup on your primary device.',
          color: Colors.orange,
          icon: Icons.warning_amber_rounded,
        ),
        const SizedBox(height: 24),
        ref.watch(autoBackupProvider).when(
              data: (isAutoBackupEnabled) => SwitchListTile(
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                secondary: const Icon(
                  Icons.sync_rounded,
                  color: Colors.white,
                ),
                title: const Text('Enable Automatic Cloud Backup'),
                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Auto-sync once a day',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
                activeThumbColor: Theme.of(context).primaryColor,
                value: isAutoBackupEnabled,
                onChanged: settingsState.isTogglingAutoBackup
                    ? null
                    : (value) async {
                        try {
                          await settingsController.toggleAutoBackup(value);
                          ref.invalidate(autoBackupProvider);
                          if (context.mounted) {
                            if (value) {
                              AppToasts.showSuccess(
                                  context, 'Auto backup enabled!');
                            } else {
                              AppToasts.showSuccess(
                                  context, 'Auto backup disabled.');
                            }
                          }
                        } catch (e) {
                          ref.invalidate(autoBackupProvider); // Re-fetch on error to revert toggle
                          if (context.mounted) {
                            AppToasts.showError(
                                context, 'Setup cancelled or failed.');
                          }
                        }
                      },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading setting: $err'),
            ),
        const SizedBox(height: 12),
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
                    ref.invalidate(autoBackupProvider);
                    if (context.mounted) {
                      AppToasts.showSuccess(
                          context, 'Signed out successfully.');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      AppToasts.showError(context, e.toString());
                    }
                  }
                },
        ),
      ],
    );
  }
}
