import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/warning_banner.dart';
import 'widgets/local_backup_section.dart';
import 'widgets/cloud_backup_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          WarningBanner(
            title: 'Highly Recommended',
            message:
                'Please run a manual backup (either local or cloud) before uninstalling the app to keep your data safe and updated.',
            color: Colors.blue,
            icon: Icons.info_outline_rounded,
          ),
          SizedBox(height: 24),
          LocalBackupSection(),
          SizedBox(height: 40),
          Divider(),
          SizedBox(height: 24),
          CloudBackupSection(),
        ],
      ),
    );
  }
}
