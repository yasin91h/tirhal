import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tirhal/core/models/authmodel.dart';

class LoginProvider extends ChangeNotifier {
  AuthModel? _authModel;
  bool _isLoading = false;

  AuthModel? get authModel => _authModel;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _authModel != null;

  // Keys for shared preferences
  static const String _keyPhoneNumber = 'login_phone_number';
  static const String _keyIsUserLoggedIn = 'is_user_logged_in';

  /// Initialize login state from shared preferences
  Future<void> initializeLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsUserLoggedIn) ?? false;
      final phoneNumber = prefs.getString(_keyPhoneNumber) ?? '';

      if (isLoggedIn && phoneNumber.isNotEmpty) {
        _authModel = AuthModel(phoneNumber: phoneNumber);
      }
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error initializing login: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save phone number and persist to shared preferences
  Future<bool> loginWithPhone(String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Save to shared preferences
      await prefs.setString(_keyPhoneNumber, phoneNumber);
      await prefs.setBool(_keyIsUserLoggedIn, true);

      // Update local state
      _authModel = AuthModel(phoneNumber: phoneNumber);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving login: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout and clear shared preferences
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear shared preferences
      await prefs.remove(_keyPhoneNumber);
      await prefs.remove(_keyIsUserLoggedIn);

      // Clear local state
      _authModel = null;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error during logout: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get saved phone number without changing state
  Future<String?> getSavedPhoneNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyPhoneNumber);
    } catch (e) {
      debugPrint('Error getting saved phone number: $e');
      return null;
    }
  }

  /// Check if user data is saved
  Future<bool> hasUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsUserLoggedIn) ?? false;
    } catch (e) {
      debugPrint('Error checking user data: $e');
      return false;
    }
  }

  /// Clear all saved data (for debugging or reset purposes)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _authModel = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }
}
