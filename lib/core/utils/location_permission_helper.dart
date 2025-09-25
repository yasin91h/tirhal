import 'package:geolocator/geolocator.dart';

class LocationPermissionHelper {
  static Future<LocationPermissionResult> checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionResult(
        success: false,
        error:
            'Location services are disabled. Please enable location services.',
        canOpenSettings: true,
      );
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionResult(
          success: false,
          error:
              'Location permissions are denied. Please grant location access.',
          canOpenSettings: true,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult(
        success: false,
        error:
            'Location permissions are permanently denied. Please enable them in device settings.',
        canOpenSettings: true,
      );
    }

    return LocationPermissionResult(success: true);
  }

  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

class LocationPermissionResult {
  final bool success;
  final String? error;
  final bool canOpenSettings;

  LocationPermissionResult({
    required this.success,
    this.error,
    this.canOpenSettings = false,
  });
}
