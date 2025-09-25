import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static const String _apiKey = 'AIzaSyAxV1byeoH9ZIp-cHGZg-5KaqfjypRI7ag';
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';

  /// Convert coordinates to address (Reverse Geocoding)
  static Future<String?> getAddressFromCoordinates(
      double latitude, double longitude,
      {String language = 'en'}) async {
    try {
      final url =
          '$_baseUrl?latlng=$latitude,$longitude&key=$_apiKey&language=$language';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
      return null;
    } catch (e) {
      print('Error in reverse geocoding: $e');
      return null;
    }
  }

  /// Convert address to coordinates (Forward Geocoding)
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final url = '$_baseUrl?address=$encodedAddress&key=$_apiKey&language=en';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
      return null;
    } catch (e) {
      print('Error in forward geocoding: $e');
      return null;
    }
  }

  /// Get place predictions for autocomplete
  static Future<List<PlacePrediction>> getPlacePredictions(String query,
      {String language = 'en'}) async {
    try {
      const autocompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      final url =
          '$autocompleteUrl?input=${Uri.encodeComponent(query)}&key=$_apiKey&language=$language';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions
              .map((prediction) => PlacePrediction.fromJson(prediction))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error in place predictions: $e');
      return [];
    }
  }

  /// Get detailed place information
  static Future<PlaceDetails?> getPlaceDetails(String placeId,
      {String language = 'en'}) async {
    try {
      const detailsUrl =
          'https://maps.googleapis.com/maps/api/place/details/json';
      final url =
          '$detailsUrl?place_id=$placeId&key=$_apiKey&language=$language';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          return PlaceDetails.fromJson(data['result']);
        }
      }
      return null;
    } catch (e) {
      print('Error in place details: $e');
      return null;
    }
  }

  /// Calculate distance between two points using Google Distance Matrix API
  static Future<DistanceInfo?> getDistance(
      LatLng origin, LatLng destination) async {
    try {
      const distanceUrl =
          'https://maps.googleapis.com/maps/api/distancematrix/json';
      final url =
          '$distanceUrl?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['rows'].isNotEmpty &&
            data['rows'][0]['elements'].isNotEmpty &&
            data['rows'][0]['elements'][0]['status'] == 'OK') {
          final element = data['rows'][0]['elements'][0];
          return DistanceInfo(
            distance: element['distance']['text'],
            duration: element['duration']['text'],
            distanceValue: element['distance']['value'],
            durationValue: element['duration']['value'],
          );
        }
      }
      return null;
    } catch (e) {
      print('Error in distance calculation: $e');
      return null;
    }
  }
}

class PlacePrediction {
  final String placeId;
  final String description;
  final List<String> types;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.types,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'],
      description: json['description'],
      types: List<String>.from(json['types']),
    );
  }
}

class PlaceDetails {
  final String placeId;
  final String name;
  final String formattedAddress;
  final LatLng location;
  final String? phoneNumber;
  final double? rating;

  PlaceDetails({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.location,
    this.phoneNumber,
    this.rating,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry']['location'];
    return PlaceDetails(
      placeId: json['place_id'],
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'],
      location: LatLng(geometry['lat'], geometry['lng']),
      phoneNumber: json['formatted_phone_number'],
      rating: json['rating']?.toDouble(),
    );
  }
}

class DistanceInfo {
  final String distance;
  final String duration;
  final int distanceValue; // in meters
  final int durationValue; // in seconds

  DistanceInfo({
    required this.distance,
    required this.duration,
    required this.distanceValue,
    required this.durationValue,
  });
}
