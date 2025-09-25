import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english,
  arabic,
}

class LanguageProvider extends ChangeNotifier {
  AppLanguage _selectedLanguage = AppLanguage.arabic; // Default to Arabic

  // Key for shared preferences
  static const String _keySelectedLanguage = 'selected_language';

  // Constructor to force Arabic language
  LanguageProvider() {
    // Force Arabic on startup
    _selectedLanguage = AppLanguage.arabic;
  }

  // Getter for selected language
  AppLanguage get selectedLanguage => _selectedLanguage;

  // Initialize language from shared preferences
  Future<void> initializeLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_keySelectedLanguage);

      if (savedLanguage != null) {
        switch (savedLanguage) {
          case 'english':
            _selectedLanguage = AppLanguage.english;
            break;
          case 'arabic':
            _selectedLanguage = AppLanguage.arabic;
            break;
          default:
            _selectedLanguage = AppLanguage.arabic; // Default fallback
        }
      } else {
        // First time user - set Arabic as default and save it
        _selectedLanguage = AppLanguage.arabic;
        await _saveLanguageToPrefs(_selectedLanguage);
      }

      notifyListeners();
    } catch (e) {
      // If there's an error, use Arabic as default
      _selectedLanguage = AppLanguage.arabic;
      notifyListeners();
    }
  }

  // Save language to shared preferences
  Future<void> _saveLanguageToPrefs(AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String languageString;
      switch (language) {
        case AppLanguage.english:
          languageString = 'english';
          break;
        case AppLanguage.arabic:
          languageString = 'arabic';
          break;
      }
      await prefs.setString(_keySelectedLanguage, languageString);
    } catch (e) {
      // Handle error silently
      debugPrint('Error saving language to preferences: $e');
    }
  }

  // Get display name for the selected language
  String get selectedLanguageDisplayName {
    switch (_selectedLanguage) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.arabic:
        return 'العربية';
    }
  }

  // Get locale for the selected language
  Locale get selectedLocale {
    switch (_selectedLanguage) {
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.arabic:
        return const Locale('ar', 'SA');
    }
  }

  // Check if current language is RTL
  bool get isRTL => _selectedLanguage == AppLanguage.arabic;

  // Set language
  Future<void> setLanguage(AppLanguage language) async {
    if (_selectedLanguage != language) {
      _selectedLanguage = language;
      await _saveLanguageToPrefs(language);
      notifyListeners();
    }
  }

  // Toggle between languages
  Future<void> toggleLanguage() async {
    await setLanguage(_selectedLanguage == AppLanguage.english
        ? AppLanguage.arabic
        : AppLanguage.english);
  }

  // Get all available languages with their display names
  Map<AppLanguage, String> get availableLanguages => {
        AppLanguage.english: 'English',
        AppLanguage.arabic: 'العربية',
      };
}
