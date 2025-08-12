import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('en');
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
        _currentLocale = Locale(savedLanguage);
        debugPrint(
          'LanguageProvider: Loaded saved language: ${_currentLocale.languageCode}',
        );
      } else {
        // Default to English for new installations
        _currentLocale = const Locale('en');
        // Save the default language preference
        await prefs.setString(_languageKey, 'en');
        debugPrint(
          'LanguageProvider: Set default language: ${_currentLocale.languageCode}',
        );
      }
    } catch (e) {
      // Fallback to English if there's an error
      _currentLocale = const Locale('en');
      debugPrint(
        'LanguageProvider: Error loading language, using fallback: $e',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;

    debugPrint(
      'LanguageProvider: Changing language from ${_currentLocale.languageCode} to $languageCode',
    );

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      _currentLocale = Locale(languageCode);
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

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isTurkish => _currentLocale.languageCode == 'tr';

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
}
