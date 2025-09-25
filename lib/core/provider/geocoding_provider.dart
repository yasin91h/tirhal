import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/geocoding_service.dart';

class GeocodingProvider extends ChangeNotifier {
  String? _currentAddress;
  bool _isLoadingAddress = false;
  List<PlacePrediction> _placePredictions = [];
  bool _isLoadingPredictions = false;
  String? _error;

  // Getters
  String? get currentAddress => _currentAddress;
  bool get isLoadingAddress => _isLoadingAddress;
  List<PlacePrediction> get placePredictions => _placePredictions;
  bool get isLoadingPredictions => _isLoadingPredictions;
  String? get error => _error;

  /// Get address from coordinates (Reverse Geocoding)
  Future<void> getAddressFromLocation(double latitude, double longitude) async {
    _isLoadingAddress = true;
    _error = null;
    notifyListeners();

    try {
      final address =
          await GeocodingService.getAddressFromCoordinates(latitude, longitude);
      _currentAddress = address ?? 'Address not found';
    } catch (e) {
      _error = 'Failed to get address: $e';
      _currentAddress = null;
    }

    _isLoadingAddress = false;
    notifyListeners();
  }

  /// Get coordinates from address (Forward Geocoding)
  Future<LatLng?> getLocationFromAddress(String address) async {
    _error = null;
    notifyListeners();

    try {
      return await GeocodingService.getCoordinatesFromAddress(address);
    } catch (e) {
      _error = 'Failed to get location: $e';
      notifyListeners();
      return null;
    }
  }

  /// Get place predictions for autocomplete
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      _placePredictions = [];
      notifyListeners();
      return;
    }

    _isLoadingPredictions = true;
    _error = null;
    notifyListeners();

    try {
      _placePredictions = await GeocodingService.getPlacePredictions(query);
    } catch (e) {
      _error = 'Failed to search places: $e';
      _placePredictions = [];
    }

    _isLoadingPredictions = false;
    notifyListeners();
  }

  /// Get place details
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    _error = null;
    notifyListeners();

    try {
      return await GeocodingService.getPlaceDetails(placeId);
    } catch (e) {
      _error = 'Failed to get place details: $e';
      notifyListeners();
      return null;
    }
  }

  /// Calculate distance between two points
  Future<DistanceInfo?> calculateDistance(
      LatLng origin, LatLng destination) async {
    _error = null;
    notifyListeners();

    try {
      return await GeocodingService.getDistance(origin, destination);
    } catch (e) {
      _error = 'Failed to calculate distance: $e';
      notifyListeners();
      return null;
    }
  }

  /// Clear predictions
  void clearPredictions() {
    _placePredictions = [];
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set current address manually
  void setCurrentAddress(String address) {
    _currentAddress = address;
    notifyListeners();
  }
}
