import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_search_model.dart';
import '../services/google_places_service.dart';
import '../localization/localization_extension.dart';

class LocationSearchProvider extends ChangeNotifier {
  final GooglePlacesService _placesService = GooglePlacesService();
  List<LocationSearchModel> _searchResults = [];
  List<LocationSearchModel> _recentSearches = [];
  List<LocationSearchModel> _savedPlaces = [];
  bool _isLoading = false;
  String? _error;
  String _currentQuery = '';
  LocationSearchModel? _selectedDestination;

  // Getters
  List<LocationSearchModel> get searchResults => _searchResults;
  List<LocationSearchModel> get recentSearches => _recentSearches;
  List<LocationSearchModel> get savedPlaces => _savedPlaces;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentQuery => _currentQuery;
  bool get hasResults => _searchResults.isNotEmpty;
  LocationSearchModel? get selectedDestination => _selectedDestination;

  // Search for locations using Google Places API
  Future<void> searchLocations(String query, BuildContext context) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _currentQuery = query;
    _setLoading(true);
    _clearError();

    try {
      // Get current language - 'ar' for Arabic, 'en' for English
      final currentLanguage = Localizations.localeOf(context).languageCode;

      // Use Google Places API for search with language parameter
      _searchResults = await _placesService.searchPlaces(
        query,
        language: currentLanguage,
      );

      // If no results from search, try autocomplete with language
      if (_searchResults.isEmpty) {
        _searchResults = await _placesService.getPlacePredictions(
          query,
          language: currentLanguage,
        );
      }
    } catch (e) {
      _setError('${context.l10n.failedToSearchLocations}: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add to recent searches
  void addToRecentSearches(LocationSearchModel location) {
    // Remove if already exists
    _recentSearches.removeWhere((item) => item.placeId == location.placeId);

    // Add to beginning
    _recentSearches.insert(0, location);

    // Keep only last 10 searches
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }

    notifyListeners();
  }

  // Save/unsave a place
  void toggleSavedPlace(LocationSearchModel location) {
    final index =
        _savedPlaces.indexWhere((item) => item.placeId == location.placeId);

    if (index >= 0) {
      _savedPlaces.removeAt(index);
    } else {
      _savedPlaces.add(location);
    }

    notifyListeners();
  }

  // Check if place is saved
  bool isPlaceSaved(String placeId) {
    return _savedPlaces.any((place) => place.placeId == placeId);
  }

  // Clear search results
  void clearResults() {
    _searchResults = [];
    _currentQuery = '';
    notifyListeners();
  }

  // Clear recent searches
  void clearRecentSearches() {
    _recentSearches = [];
    notifyListeners();
  }

  // Get suggestions based on location type
  List<LocationSearchModel> getSuggestionsByType(LocationType type) {
    return _savedPlaces.where((place) => place.type == type).toList();
  }

  // Get nearby locations (mock implementation)
  Future<void> getNearbyPlaces(LatLng userLocation, BuildContext context,
      {LocationType? type}) async {
    _setLoading(true);
    _clearError();

    try {
      // Get current language - 'ar' for Arabic, 'en' for English
      final currentLanguage = Localizations.localeOf(context).languageCode;

      // Use Google Places API for nearby search
      if (type != null) {
        final googleType = _getGooglePlaceType(type);
        _searchResults = await _placesService.getNearbyPlacesByType(
          userLocation,
          googleType,
          language: currentLanguage,
        );
      } else {
        // General nearby search using text search with language
        _searchResults = await _placesService.searchPlaces(
          context.l10n.placesNearMe,
          location: userLocation,
          language: currentLanguage,
        );
      }
    } catch (e) {
      _setError('${context.l10n.failedToGetNearbyPlaces}: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Initialize with default saved places
  void initializeDefaultPlaces(BuildContext context) {
    _savedPlaces = [
      LocationSearchModel(
        placeId: 'home',
        name: context.l10n.homeLocation,
        address: context.l10n.setYourHomeAddress,
        type: LocationType.general,
      ),
      LocationSearchModel(
        placeId: 'work',
        name: context.l10n.workLocation,
        address: context.l10n.setYourWorkAddress,
        type: LocationType.general,
      ),
    ];
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Helper method to convert LocationType to Google Places API type
  String _getGooglePlaceType(LocationType type) {
    switch (type) {
      case LocationType.restaurant:
        return 'restaurant';
      case LocationType.shopping:
        return 'shopping_mall';
      case LocationType.hospital:
        return 'hospital';
      case LocationType.school:
        return 'school';
      case LocationType.airport:
        return 'airport';
      case LocationType.gasStation:
        return 'gas_station';
      case LocationType.bank:
        return 'bank';
      case LocationType.hotel:
        return 'lodging';
      case LocationType.general:
        return 'establishment';
    }
  }

  // Get detailed place information by place ID
  Future<LocationSearchModel?> getPlaceDetails(
      String placeId, BuildContext context) async {
    try {
      // Get current language - 'ar' for Arabic, 'en' for English
      final currentLanguage = Localizations.localeOf(context).languageCode;

      final placeDetails = await _placesService.getPlaceDetails(
        placeId,
        language: currentLanguage,
      );
      return placeDetails;
    } catch (e) {
      print('${context.l10n.errorGettingPlaceDetails}: $e');
      return null;
    }
  }

  // Selected destination management
  void setSelectedDestination(LocationSearchModel destination) {
    _selectedDestination = destination;
    notifyListeners();
  }

  void clearSelectedDestination() {
    _selectedDestination = null;
    notifyListeners();
  }
}
