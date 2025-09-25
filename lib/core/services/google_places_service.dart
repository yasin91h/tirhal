import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_search_model.dart';

class GooglePlacesService {
  static const String _apiKey = 'AIzaSyAxV1byeoH9ZIp-cHGZg-5KaqfjypRI7ag';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  // Search for places using Text Search API
  Future<List<LocationSearchModel>> searchPlaces(String query,
      {LatLng? location, String language = 'en'}) async {
    try {
      final String url;

      if (location != null) {
        // Use Nearby Search if location is provided
        url = '$_baseUrl/nearbysearch/json?'
            'location=${location.latitude},${location.longitude}'
            '&radius=50000'
            '&keyword=${Uri.encodeComponent(query)}'
            '&language=$language'
            '&key=$_apiKey';
      } else {
        // Use Text Search for general queries
        url = '$_baseUrl/textsearch/json?'
            'query=${Uri.encodeComponent(query)}'
            '&language=$language'
            '&key=$_apiKey';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final List results = data['results'] ?? [];
          return results
              .map((place) => LocationSearchModel.fromGooglePlaces(place))
              .toList();
        } else {
          throw Exception(
              'Places API Error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }

  // Get place autocomplete predictions
  Future<List<LocationSearchModel>> getPlacePredictions(String query,
      {LatLng? location, String language = 'en'}) async {
    try {
      String url = '$_baseUrl/autocomplete/json?'
          'input=${Uri.encodeComponent(query)}'
          '&language=$language'
          '&key=$_apiKey';

      if (location != null) {
        url +=
            '&location=${location.latitude},${location.longitude}&radius=50000';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final List predictions = data['predictions'] ?? [];
          return predictions
              .map((prediction) =>
                  LocationSearchModel.fromGooglePrediction(prediction))
              .toList();
        } else {
          throw Exception(
              'Autocomplete API Error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get predictions: $e');
    }
  }

  // Get place details by place_id
  Future<LocationSearchModel> getPlaceDetails(String placeId,
      {String language = 'en'}) async {
    try {
      final url = '$_baseUrl/details/json?'
          'place_id=$placeId'
          '&fields=name,formatted_address,geometry,rating,types,photos'
          '&language=$language'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final place = data['result'];
          return LocationSearchModel.fromGooglePlaceDetails(place, placeId);
        } else {
          throw Exception(
              'Place Details API Error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get place details: $e');
    }
  }

  // Get nearby places by type
  Future<List<LocationSearchModel>> getNearbyPlacesByType(
    LatLng location,
    String type, {
    int radius = 5000,
    String language = 'en',
  }) async {
    try {
      final url = '$_baseUrl/nearbysearch/json?'
          'location=${location.latitude},${location.longitude}'
          '&radius=$radius'
          '&type=$type'
          '&language=$language'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final List results = data['results'] ?? [];
          return results
              .map((place) => LocationSearchModel.fromGooglePlaces(place))
              .toList();
        } else {
          throw Exception(
              'Nearby Search API Error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get nearby places: $e');
    }
  }
}
