import 'package:flutter/material.dart';

class AppTheme {
  // TV Time inspired color palette
  static const Color primaryYellow = Color(0xFFFFC107); // Amber/Yellow accent
  static const Color backgroundDark = Color(0xFF121212); // Deep dark grey (almost black)
  static const Color surfaceDark = Color(0xFF1E1E1E); // Slightly lighter grey for cards/bottom bar
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryYellow,
      
      // Forces standard material components to use our colors
      colorScheme: const ColorScheme.dark(
        primary: primaryYellow,
        secondary: primaryYellow,
        surface: surfaceDark,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryYellow,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      
      cardTheme: CardThemeData(
        color: surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}