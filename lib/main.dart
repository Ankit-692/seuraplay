import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seuraplay/core/services/sync_service.dart';
import 'package:seuraplay/features/intro/ui/intro_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/home/main_screen.dart';

void main() async {
  // Ensure bindings are initialized before calling async code
  WidgetsFlutterBinding.ensureInitialized();

  // Fire and forget auto-sync check
  SyncService.checkAndRunAutoSync();

  // Check if first launch
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

  runApp(ProviderScope(child: TvTrackerApp(isFirstLaunch: isFirstLaunch)));
}

class TvTrackerApp extends StatelessWidget {
  final bool isFirstLaunch;
  const TvTrackerApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seuraplay',
      debugShowCheckedModeBanner: false,

      // Force the custom dark theme
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Ignores device light mode

      home: isFirstLaunch ? const IntroScreen() : const MainScreen(),
    );
  }
}
