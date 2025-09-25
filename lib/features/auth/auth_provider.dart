import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _otpCode = "";
  bool _isVerified = false;
  bool _isLoggedIn = false;
  String _userPhone = "";

  String get otpCode => _otpCode;
  bool get isVerified => _isVerified;
  bool get isLoggedIn => _isLoggedIn;
  String get userPhone => _userPhone;

  // Keys for shared preferences
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserPhone = 'userPhone';

  /// Initialize auth state from shared preferences
  Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _userPhone = prefs.getString(_keyUserPhone) ?? "";
    notifyListeners();
  }

  /// Update OTP code as user types
  void updateOtp(String code) {
    _otpCode = code;
    notifyListeners();
  }

  /// Verify OTP code and save login state
  Future<bool> verifyOtp(String phoneNumber) async {
    if (_otpCode == "123456") {
      _isVerified = true;
      _isLoggedIn = true;
      _userPhone = phoneNumber;

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserPhone, phoneNumber);

      notifyListeners();
      return true;
    } else {
      _isVerified = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user and clear shared preferences
  Future<void> logout() async {
    _isLoggedIn = false;
    _isVerified = false;
    _userPhone = "";
    _otpCode = "";

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserPhone);

    notifyListeners();
  }

  /// Reset OTP state (optional if you want to resend OTP)
  void resetOtp() {
    _otpCode = "";
    _isVerified = false;
    notifyListeners();
  }
}
