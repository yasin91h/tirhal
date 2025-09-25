import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  late SharedPreferences _prefs;

  AppThemeMode get themeMode => _themeMode;

  Map<AppThemeMode, String> get themeModeLabels => {
        AppThemeMode.light: 'Light',
        AppThemeMode.dark: 'Dark',
        AppThemeMode.system: 'System',
      };

  String get selectedThemeLabel => themeModeLabels[_themeMode] ?? 'System';

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final themeModeString = _prefs.getString('theme_mode') ?? 'system';

      switch (themeModeString) {
        case 'light':
          _themeMode = AppThemeMode.light;
          break;
        case 'dark':
          _themeMode = AppThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = AppThemeMode.system;
          break;
      }

      notifyListeners();
    } catch (e) {
      // Handle error, fallback to system theme
      _themeMode = AppThemeMode.system;
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;

    try {
      await _prefs.setString('theme_mode', mode.toString().split('.').last);
    } catch (e) {
      // Handle error
    }

    notifyListeners();
  }

  /// Get the actual theme mode that Flutter should use
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Helper to determine if current theme should be dark
  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}
