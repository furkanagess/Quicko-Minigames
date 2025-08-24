import 'package:flutter/material.dart';

/// Supported locales for the application
/// This class provides centralized management of supported locales
class SupportedLocales {
  /// List of all supported locales
  /// Ordered by popularity and market potential
  static const List<Locale> locales = [
    // Tier 1: Global Languages (Most Popular)
    Locale('en'), // English - Global lingua franca
    Locale('es'), // Spanish - 2nd most spoken language
    Locale('hi'), // Hindi - 3rd most spoken language
    Locale('ar'), // Arabic - Major regional language
    // Tier 2: Major European Markets
    Locale('de'), // German - Strong European market
    Locale('fr'), // French - Major European market
    Locale('it'), // Italian - Important European market
    Locale('ru'), // Russian - Major European and CIS market
    // Tier 3: Emerging Markets
    Locale('pt', 'BR'), // Portuguese (Brazil) - Large Latin American market
    Locale('id'), // Indonesian - Fast-growing Southeast Asian market
    // Tier 4: Regional Languages
    Locale('tr'), // Turkish - Regional market
  ];

  /// Get locale by language code
  static Locale? getLocaleByLanguageCode(String languageCode) {
    try {
      return locales.firstWhere(
        (locale) => locale.languageCode == languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if a locale is supported
  static bool isSupported(Locale locale) {
    return locales.any(
      (supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode &&
          (supportedLocale.countryCode == null ||
              supportedLocale.countryCode == locale.countryCode),
    );
  }

  /// Get default locale (English)
  static const Locale defaultLocale = Locale('en');

  /// Get fallback locale
  static const Locale fallbackLocale = Locale('en');
}
