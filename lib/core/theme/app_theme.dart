import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6B46C1);
  static const Color lightSecondary = Color(0xFF9F7AEA);
  static const Color lightBackground = Color(0xFFF7FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A202C);
  static const Color lightOnSurface = Color(0xFF1A202C);
  static const Color lightError = Color(0xFFE53E3E);
  static const Color lightSuccess = Color(0xFF38A169);
  static const Color lightWarning = Color(0xFFD69E2E);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF8E44AD); // purpleAccent #8E44AD
  static const Color darkSecondary = Color(0xFFB794F4);
  static const Color darkBackground = Color(
    0xFF21232D,
  ); // Requested dark background
  static const Color darkSurface = Color(0xFF2D3748);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSecondary = Color(0xFF1A202C);
  static const Color darkOnBackground = Color(0xFFF7FAFC);
  static const Color darkOnSurface = Color(0xFFF7FAFC);
  static const Color darkError = Color(0xFFFC8181);
  static const Color darkSuccess = Color(0xFF68D391);
  static const Color darkWarning = Color(0xFFF6E05E);

  // Extended Named Colors (centralized usage across app)
  static const Color vividGreen = Color(0xFF64DD17);
  static const Color vividGreenAlt = Color(0xFF5AC715);
  static const Color goldYellow = Color(0xFFFFD700);
  static const Color overlayDark = Color(0xFF2B2E3A);

  // Game Specific Colors
  static const Color slotBorder = Color(0xFF9F7AEA);
  static const Color slotBackground = Color(0xFF2D3748);
  static const Color questionMark = Color(0xFF4A5568);
  static const Color darkSlotBorder = Color(0xFFB794F4);
  static const Color darkSlotBackground = Color(0xFF1A202C);
  static const Color darkQuestionMark = Color(0xFF718096);

  // Light theme specific slot colors for better contrast
  static const Color lightSlotBorder = Color(0xFF8B5CF6);
  static const Color lightSlotBackground = Color(0xFFF8FAFC);
  static const Color lightSlotText = Color(0xFF4C1D95);

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        onPrimary: lightOnPrimary,
        onSecondary: lightOnSecondary,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnBackground,
        error: lightError,
      ),
      scaffoldBackgroundColor: lightSurface,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimary,
        foregroundColor: lightOnPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightOnPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largeSpacing,
            vertical: AppConstants.mediumSpacing,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
      ),
      textTheme: ThemeData.light().textTheme,
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        onPrimary: darkOnPrimary,
        onSecondary: darkOnSecondary,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnBackground,
        error: darkError,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPrimary,
        foregroundColor: darkOnPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkOnPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largeSpacing,
            vertical: AppConstants.mediumSpacing,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
      ),
      textTheme: ThemeData.dark().textTheme,
    );
  }
}
