import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../../../core/utils/app_toasts.dart';

class LocalBackupSection extends ConsumerWidget {
  const LocalBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}
