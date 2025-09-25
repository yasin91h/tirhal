import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeProvider with ChangeNotifier {
  Position? _currentPosition;
  bool _loading = false;
  String? _error;

  Position? get currentPosition => _currentPosition;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> determinePosition() async {
    // If location already fetched, do not fetch again
    if (_currentPosition != null) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'Location services are disabled.';
        _loading = false;
        notifyListeners();
        return;
      }

      // Check for permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permissions are denied';
          _loading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error =
            'Location permissions are permanently denied, we cannot request permissions.';
        _loading = false;
        notifyListeners();
        return;
      }

      // Get the current position
      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
