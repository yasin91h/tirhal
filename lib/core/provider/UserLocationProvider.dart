import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tirhal/core/utils/location_permission_helper.dart';

class UserLocationProvider extends ChangeNotifier {
  LatLng? _currentLocation;
  bool _loading = false;
  String? _error;
  bool _locationFetched = false; // Track if location has been fetched

  LatLng? get currentLocation => _currentLocation;
  bool get loading => _loading;
  String? get error => _error;
  bool get locationFetched => _locationFetched;

  Future<void> updateLocation() async {
    // If location is already fetched and successful, don't fetch again
    if (_locationFetched && _currentLocation != null && _error == null) {
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Check and request permissions using the helper
      final permissionResult =
          await LocationPermissionHelper.checkAndRequestPermission();

      if (!permissionResult.success) {
        _error = permissionResult.error;
        _loading = false;
        _locationFetched = true; // Mark as attempted
        notifyListeners();
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _currentLocation = LatLng(position.latitude, position.longitude);
      _locationFetched = true; // Mark as successfully fetched
    } catch (e) {
      _error = 'Failed to get location: ${e.toString()}';
      _locationFetched = true; // Mark as attempted
    }

    _loading = false;
    notifyListeners();
  }

  // Method to force refresh location if needed
  Future<void> refreshLocation() async {
    _locationFetched = false;
    await updateLocation();
  }

  void clearError() {
    _error = null;
    _locationFetched = false; // Allow retry
    notifyListeners();
  }
}
