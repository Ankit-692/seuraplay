import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppToasts {
  static void showSuccess(BuildContext context, String message) {
    _showToast(context, message, Icons.check_circle_rounded, Colors.greenAccent);
  }

  static void showError(BuildContext context, String message) {
    _showToast(context, message, Icons.error_rounded, Colors.redAccent);
  }

  static void showInfo(BuildContext context, String message) {
    _showToast(context, message, Icons.info_rounded, AppTheme.primaryYellow);
  }

  static void _showToast(BuildContext context, String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
