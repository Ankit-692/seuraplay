import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:seuraplay/features/home/main_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  Future<void> _completeIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo or App Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.tv_rounded, size: 60, color: primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Welcome Text
              Text(
                'Welcome to Seuraplay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your personal TV and Movie tracker.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 48),

              // Information Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _InfoCard(
                      icon: Icons.movie_filter_rounded,
                      title: 'Powered by TMDB',
                      description: 'To fetch all the latest movie and TV show data, Seuraplay uses the TMDB database. Just create a free account to get your personal API Read Access Token (the much longer "v4 auth" one) and paste it in the Settings page!',
                      iconColor: Colors.blueAccent,
                      linkText: 'Create a free TMDB account',
                      onLinkTap: () => launchUrl(Uri.parse('https://www.themoviedb.org/signup')),
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      icon: Icons.cloud_done_rounded,
                      title: 'Cloud & Local Backups',
                      description: 'Data is backed up every 24hrs to Google Drive automatically. You can also manually backup and restore locally or to the cloud via the settings page.',
                      iconColor: Colors.greenAccent,
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      icon: Icons.privacy_tip_rounded,
                      title: 'Your Data, Your Control',
                      description: 'All your tracking data is stored locally on your device unless you choose to sync it to Google Drive.',
                      iconColor: Colors.purpleAccent,
                    ),
                  ],
                ),
              ),

              // Get Started Button
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _completeIntro(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    this.linkText,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                if (linkText != null && onLinkTap != null) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onLinkTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        linkText!,
                        style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: iconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
