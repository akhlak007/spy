import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF1E1E2E); // Dark slate
  static const Color secondaryColor = Color(0xFF89B4FA); // Soft blue
  static const Color accentColor = Color(0xFFF5C2E7); // Soft pink
  static const Color highlightColor = Color(0xFFABE9B3); // Mint green

  // Text colors
  static const Color textColor = Color(0xFFCDD6F4); // Light lavender
  static const Color textSecondaryColor = Color(0xFFBAC2DE); // Muted lavender
  static const Color cardColor = Color(0xFF313244); // Darker slate

  // Functional colors
  static const Color successColor = Color(0xFFABE9B3); // Mint green
  static const Color warningColor = Color(0xFFF5C2E7); // Soft pink
  static const Color errorColor = Color(0xFFF28FAD); // Rose red

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
    height: 1.2,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
    height: 1.2,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textColor,
    height: 1.5,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: highlightColor,
    foregroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    minimumSize: const Size(double.infinity, 56),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    foregroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    minimumSize: const Size(double.infinity, 56),
  );

  // Card styles
  static final cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Theme data
  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingStyle,
    ),
    textTheme: const TextTheme(
      displayLarge: headingStyle,
      headlineMedium: subheadingStyle,
      bodyLarge: bodyStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    colorScheme: ColorScheme.dark(
      primary: highlightColor,
      secondary: accentColor,
      surface: cardColor,
      background: primaryColor,
      error: errorColor,
    ),
  );
}
