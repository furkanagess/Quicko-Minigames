import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/supported_locales.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = SupportedLocales.defaultLocale;
  bool _isLoading = false;

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  String get languageCode => _currentLocale.languageCode;

  LanguageProvider() {
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);

      debugPrint('LanguageProvider: Loading saved language: $savedLanguage');

      if (savedLanguage != null) {
        // Handle country-specific locales
        if (savedLanguage == 'pt_BR') {
          _currentLocale = const Locale('pt', 'BR');
        } else {
          _currentLocale = Locale(savedLanguage);
        }
        debugPrint(
          'LanguageProvider: Loaded saved language: ${_currentLocale.languageCode}',
        );
      } else {
        // Default to English for new installations
        _currentLocale = SupportedLocales.defaultLocale;
        // Save the default language preference
        await prefs.setString(
          _languageKey,
          SupportedLocales.defaultLocale.languageCode,
        );
        debugPrint(
          'LanguageProvider: Set default language: ${_currentLocale.languageCode}',
        );
      }
    } catch (e) {
      // Fallback to English if there's an error
      _currentLocale = SupportedLocales.fallbackLocale;
      debugPrint(
        'LanguageProvider: Error loading language, using fallback: $e',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    Locale? newLocale = SupportedLocales.getLocaleByLanguageCode(languageCode);

    // Handle country-specific locales
    if (languageCode == 'pt_BR') {
      newLocale = const Locale('pt', 'BR');
    } else if (newLocale == null) {
      // Fallback to default locale if not supported
      newLocale = SupportedLocales.defaultLocale;
    }

    if (_currentLocale.languageCode == newLocale.languageCode &&
        _currentLocale.countryCode == newLocale.countryCode)
      return;

    debugPrint(
      'LanguageProvider: Changing language from ${_currentLocale.languageCode} to ${newLocale.languageCode}',
    );

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      _currentLocale = newLocale;
      debugPrint(
        'LanguageProvider: Language saved successfully: $languageCode',
      );
    } catch (e) {
      // Handle error if needed
      debugPrint('LanguageProvider: Error saving language preference: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeLanguageToEnglish() async {
    await changeLanguage('en');
  }

  Future<void> changeLanguageToTurkish() async {
    await changeLanguage('tr');
  }

  Future<void> changeLanguageToSpanish() async {
    await changeLanguage('es');
  }

  Future<void> changeLanguageToPortuguese() async {
    await changeLanguage('pt_BR');
  }

  Future<void> changeLanguageToArabic() async {
    await changeLanguage('ar');
  }

  Future<void> changeLanguageToGerman() async {
    await changeLanguage('de');
  }

  Future<void> changeLanguageToFrench() async {
    await changeLanguage('fr');
  }

  Future<void> changeLanguageToIndonesian() async {
    await changeLanguage('id');
  }

  Future<void> changeLanguageToHindi() async {
    await changeLanguage('hi');
  }

  Future<void> changeLanguageToAzerbaijani() async {
    await changeLanguage('az');
  }

  Future<void> changeLanguageToItalian() async {
    await changeLanguage('it');
  }

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isTurkish => _currentLocale.languageCode == 'tr';
  bool get isSpanish => _currentLocale.languageCode == 'es';
  bool get isPortuguese =>
      _currentLocale.languageCode == 'pt' && _currentLocale.countryCode == 'BR';
  bool get isArabic => _currentLocale.languageCode == 'ar';
  bool get isGerman => _currentLocale.languageCode == 'de';
  bool get isFrench => _currentLocale.languageCode == 'fr';
  bool get isIndonesian => _currentLocale.languageCode == 'id';
  bool get isHindi => _currentLocale.languageCode == 'hi';
  bool get isAzerbaijani => _currentLocale.languageCode == 'az';
  bool get isItalian => _currentLocale.languageCode == 'it';

  // Debug method to check saved language value
  Future<void> debugCheckSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      debugPrint('LanguageProvider: Debug - Saved language: $savedLanguage');
      debugPrint(
        'LanguageProvider: Debug - Current language: ${_currentLocale.languageCode}',
      );
    } catch (e) {
      debugPrint('LanguageProvider: Debug - Error checking saved language: $e');
    }
  }

  /// Get all supported locales
  List<Locale> get supportedLocales => SupportedLocales.locales;

  /// Check if current locale is supported
  bool get isCurrentLocaleSupported =>
      SupportedLocales.isSupported(_currentLocale);

  /// Get locale by index
  Locale? getLocaleByIndex(int index) {
    if (index >= 0 && index < SupportedLocales.locales.length) {
      return SupportedLocales.locales[index];
    }
    return null;
  }

  /// Get index of current locale
  int get currentLocaleIndex {
    return SupportedLocales.locales.indexWhere(
      (locale) =>
          locale.languageCode == _currentLocale.languageCode &&
          locale.countryCode == _currentLocale.countryCode,
    );
  }
}
