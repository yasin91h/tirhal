import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RoutingService {
  static const String _googleMapsApiKey =
      'AIzaSyAxV1byeoH9ZIp-cHGZg-5KaqfjypRI7ag';
  static const String _directionsBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  // Get route between two points using Google Directions API
  Future<RouteData> getRoute(LatLng origin, LatLng destination) async {
    try {
      final url = '$_directionsBaseUrl?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'key=$_googleMapsApiKey';

      // Add timeout to prevent app freezing
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - using fallback route');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // Decode polyline points
          final polylinePoints =
              _decodePolyline(route['overview_polyline']['points']);

          return RouteData(
            points: polylinePoints,
            distance: _parseDistance(leg['distance']['value']),
            duration: Duration(seconds: leg['duration']['value']),
            distanceText: leg['distance']['text'],
            durationText: leg['duration']['text'],
          );
        } else {
          throw Exception('No route found: ${data['status']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to simple straight line route
      return _createStraightLineRoute(origin, destination);
    }
  }

  // Get multi-stop route (driver -> pickup -> destination)
  Future<MultiStopRouteData> getMultiStopRoute(
    LatLng driverLocation,
    LatLng pickupLocation,
    LatLng destinationLocation,
  ) async {
    try {
      // Get route from driver to pickup with timeout
      final driverToPickup = await getRoute(driverLocation, pickupLocation);

      // Get route from pickup to destination with timeout
      final pickupToDestination =
          await getRoute(pickupLocation, destinationLocation);

      return MultiStopRouteData(
        driverToPickupRoute: driverToPickup,
        pickupToDestinationRoute: pickupToDestination,
        totalDistance: driverToPickup.distance + pickupToDestination.distance,
        totalDuration: driverToPickup.duration + pickupToDestination.duration,
      );
    } catch (e) {
      print('Error in getMultiStopRoute: $e');
      // Fallback routes
      return MultiStopRouteData(
        driverToPickupRoute:
            _createStraightLineRoute(driverLocation, pickupLocation),
        pickupToDestinationRoute:
            _createStraightLineRoute(pickupLocation, destinationLocation),
        totalDistance: _calculateDistance(driverLocation, pickupLocation) +
            _calculateDistance(pickupLocation, destinationLocation),
        totalDuration: const Duration(minutes: 15), // Fallback duration
      );
    }
  }

  // Decode Google polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // Create a simple straight line route as fallback
  RouteData _createStraightLineRoute(LatLng origin, LatLng destination) {
    final distance = _calculateDistance(origin, destination);
    final duration =
        Duration(minutes: (distance * 2).round()); // Rough estimate

    return RouteData(
      points: [origin, destination],
      distance: distance,
      duration: duration,
      distanceText: '${distance.toStringAsFixed(1)} km',
      durationText: '${duration.inMinutes} min',
    );
  }

  // Calculate distance between two points (Haversine formula)
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double lat1Rad = point1.latitude * pi / 180;
    double lat2Rad = point2.latitude * pi / 180;
    double deltaLatRad = (point2.latitude - point1.latitude) * pi / 180;
    double deltaLngRad = (point2.longitude - point1.longitude) * pi / 180;

    double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLngRad / 2) *
            sin(deltaLngRad / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  // Parse distance from meters to kilometers
  double _parseDistance(int distanceInMeters) {
    return distanceInMeters / 1000.0; // Convert to kilometers
  }

  // Get estimated fare based on distance and car type
  double getEstimatedFare(double distance, String carType) {
    const Map<String, double> baseFares = {
      'Economy': 15.0,
      'Comfort': 20.0,
      'Premium': 30.0,
      'XL': 25.0,
    };

    const Map<String, double> perKmRates = {
      'Economy': 5.0,
      'Comfort': 7.0,
      'Premium': 10.0,
      'XL': 8.0,
    };

    final baseFare = baseFares[carType] ?? 15.0;
    final perKmRate = perKmRates[carType] ?? 5.0;

    return baseFare + (distance * perKmRate);
  }
}

// Route data model
class RouteData {
  final List<LatLng> points;
  final double distance;
  final Duration duration;
  final String distanceText;
  final String durationText;

  RouteData({
    required this.points,
    required this.distance,
    required this.duration,
    required this.distanceText,
    required this.durationText,
  });
}

// Multi-stop route data model
class MultiStopRouteData {
  final RouteData driverToPickupRoute;
  final RouteData pickupToDestinationRoute;
  final double totalDistance;
  final Duration totalDuration;

  MultiStopRouteData({
    required this.driverToPickupRoute,
    required this.pickupToDestinationRoute,
    required this.totalDistance,
    required this.totalDuration,
  });

  List<LatLng> get allRoutePoints {
    return [
      ...driverToPickupRoute.points,
      ...pickupToDestinationRoute.points,
    ];
  }
}
