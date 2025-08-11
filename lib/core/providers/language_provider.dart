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
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);

      if (savedLanguage != null) {
        _currentLocale = Locale(savedLanguage);
      } else {
        // Default to English for new installations
        _currentLocale = const Locale('en');
        // Save the default language preference
        await prefs.setString(_languageKey, 'en');
      }
    } catch (e) {
      // Fallback to English if there's an error
      _currentLocale = const Locale('en');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      _currentLocale = Locale(languageCode);
    } catch (e) {
      // Handle error if needed
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
}
