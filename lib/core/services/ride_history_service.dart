import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ride_history_model.dart';

class RideHistoryService {
  static const String _rideHistoryKey = 'ride_history';
  static const String _currentRideKey = 'current_ride';

  // Add a ride to history
  Future<void> addRideToHistory(RideHistoryModel ride) async {
    final prefs = await SharedPreferences.getInstance();
    final existingRides = await getRideHistory();

    existingRides.insert(0, ride); // Add to beginning (most recent first)

    // Keep only the last 50 rides
    if (existingRides.length > 50) {
      existingRides.removeRange(50, existingRides.length);
    }

    final ridesJson = existingRides.map((ride) => ride.toJson()).toList();
    await prefs.setString(_rideHistoryKey, jsonEncode(ridesJson));
  }

  // Get all ride history
  Future<List<RideHistoryModel>> getRideHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final ridesString = prefs.getString(_rideHistoryKey);

    if (ridesString == null) return [];

    try {
      final ridesJson = jsonDecode(ridesString) as List<dynamic>;
      return ridesJson.map((json) => RideHistoryModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Save current active ride
  Future<void> saveCurrentRide(RideHistoryModel ride) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentRideKey, jsonEncode(ride.toJson()));
  }

  // Get current active ride
  Future<RideHistoryModel?> getCurrentRide() async {
    final prefs = await SharedPreferences.getInstance();
    final rideString = prefs.getString(_currentRideKey);

    if (rideString == null) return null;

    try {
      final rideJson = jsonDecode(rideString);
      return RideHistoryModel.fromJson(rideJson);
    } catch (e) {
      return null;
    }
  }

  // Update current ride
  Future<void> updateCurrentRide(RideHistoryModel ride) async {
    await saveCurrentRide(ride);
  }

  // Complete current ride and move to history
  Future<void> completeCurrentRide(RideHistoryModel ride) async {
    await addRideToHistory(ride);
    await clearCurrentRide();
  }

  // Clear current ride
  Future<void> clearCurrentRide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentRideKey);
  }

  // Get rides by date range
  Future<List<RideHistoryModel>> getRidesByDateRange(
      DateTime start, DateTime end) async {
    final allRides = await getRideHistory();
    return allRides.where((ride) {
      return ride.startTime.isAfter(start) && ride.startTime.isBefore(end);
    }).toList();
  }

  // Get total distance traveled
  Future<double> getTotalDistance() async {
    final rides = await getRideHistory();
    return rides.fold<double>(0.0, (sum, ride) => sum + ride.distance);
  }

  // Get total amount spent
  Future<double> getTotalAmountSpent() async {
    final rides = await getRideHistory();
    return rides.fold<double>(0.0, (sum, ride) => sum + ride.fare);
  }

  // Get ride count
  Future<int> getRideCount() async {
    final rides = await getRideHistory();
    return rides.length;
  }

  // Get favorite destinations (most visited)
  Future<List<String>> getFavoriteDestinations({int limit = 5}) async {
    final rides = await getRideHistory();
    final Map<String, int> destinationCounts = {};

    for (final ride in rides) {
      final destination = ride.destination.name;
      destinationCounts[destination] =
          (destinationCounts[destination] ?? 0) + 1;
    }

    final sorted = destinationCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }

  // Update ride status
  Future<void> updateRideStatus(String rideId, RideStatus status) async {
    final rides = await getRideHistory();
    final rideIndex = rides.indexWhere((ride) => ride.id == rideId);

    if (rideIndex != -1) {
      final updatedRide = rides[rideIndex].copyWith(
        status: status,
        endTime:
            (status == RideStatus.completed || status == RideStatus.cancelled)
                ? DateTime.now()
                : rides[rideIndex].endTime,
      );

      rides[rideIndex] = updatedRide;

      // Save updated list
      final prefs = await SharedPreferences.getInstance();
      final ridesJson = rides.map((ride) => ride.toJson()).toList();
      await prefs.setString(_rideHistoryKey, jsonEncode(ridesJson));

      // Update current ride if it's the active one
      final currentRide = await getCurrentRide();
      if (currentRide?.id == rideId) {
        await prefs.setString(
            _currentRideKey, jsonEncode(updatedRide.toJson()));
      }
    }
  }

  // Clear all history (for testing or user request)
  Future<void> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rideHistoryKey);
    await prefs.remove(_currentRideKey);
  }
}
