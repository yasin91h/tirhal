import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/models/ride.dart';
import '../../core/localization/localization_extension.dart';

class RideHistoryProvider extends ChangeNotifier {
  final CollectionReference _rideCollection =
      FirebaseFirestore.instance.collection('rideRequests');

  List<RideModel> _rideHistory = [];
  List<RideModel> _filteredHistory = [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _error;
  String _selectedStatus = 'all';
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  List<RideModel> get rideHistory => _filteredHistory;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  String? get error => _error;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Get ride history for a specific user
  Stream<List<RideModel>> getRideHistoryStream(String userId) {
    return _rideCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(100) // Limit to last 100 rides for performance
        .snapshots()
        .map((snapshot) {
      final rides = snapshot.docs
          .map((doc) => RideModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();

      _rideHistory = rides;
      _applyFilters();
      return _filteredHistory;
    });
  }

  // Load ride history (for one-time fetch)
  Future<void> loadRideHistory(String userId,
      {bool forceRefresh = false}) async {
    // Skip loading if already loaded and not forcing refresh
    if (_hasLoaded && !forceRefresh) {
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // For testing purposes, let's add some dummy data
      // Remove this when you have actual Firestore data
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      _rideHistory = [
        RideModel(
          id: 'ride1',
          userId: userId,
          driverId: 'driver1',
          pickup: const LatLng(37.7749, -122.4194),
          destination: const LatLng(37.7849, -122.4094),
          status: RideStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        RideModel(
          id: 'ride2',
          userId: userId,
          driverId: 'driver2',
          pickup: const LatLng(37.7649, -122.4294),
          destination: const LatLng(37.7949, -122.3994),
          status: RideStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        RideModel(
          id: 'ride3',
          userId: userId,
          driverId: 'driver3',
          pickup: const LatLng(37.7549, -122.4394),
          destination: const LatLng(37.8049, -122.3894),
          status: RideStatus.canceled,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      /* 
      // Real Firestore code - uncomment when ready to use Firestore
      final snapshot = await _rideCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      _rideHistory = snapshot.docs
          .map((doc) => RideModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
      */

      _applyFilters();
      _hasLoaded = true;
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load ride history: $e'); // Will be localized in UI
      _setLoading(false);
    }
  }

  // Filter by status
  void filterByStatus(String status) {
    _selectedStatus = status;
    _applyFilters();
    notifyListeners();
  }

  // Search rides
  void searchRides(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Filter by date range
  void filterByDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _selectedStatus = 'all';
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _applyFilters();
    notifyListeners();
  }

  // Apply current filters
  void _applyFilters() {
    _filteredHistory = _rideHistory.where((ride) {
      // Status filter
      if (_selectedStatus != 'all' &&
          ride.status.toString().split('.').last != _selectedStatus) {
        return false;
      }

      // Search filter (search in driver ID for now, can be expanded)
      if (_searchQuery.isNotEmpty) {
        final searchText = ride.driverId.toLowerCase();
        if (!searchText.contains(_searchQuery)) {
          return false;
        }
      }

      // Date range filter
      if (_startDate != null && ride.createdAt != null) {
        if (ride.createdAt!.isBefore(_startDate!)) {
          return false;
        }
      }
      if (_endDate != null && ride.createdAt != null) {
        final endOfDay = DateTime(
            _endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        if (ride.createdAt!.isAfter(endOfDay)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Get statistics
  Map<String, int> getStatistics() {
    final stats = <String, int>{
      'total': _rideHistory.length,
      'completed': 0,
      'canceled': 0,
      'pending': 0,
      'accepted': 0,
    };

    for (final ride in _rideHistory) {
      final status = ride.status.toString().split('.').last;
      stats[status] = (stats[status] ?? 0) + 1;
    }

    return stats;
  }

  // Get rides for specific month
  List<RideModel> getRidesForMonth(DateTime month) {
    return _rideHistory.where((ride) {
      if (ride.createdAt == null) return false;
      return ride.createdAt!.year == month.year &&
          ride.createdAt!.month == month.month;
    }).toList();
  }

  // Get total distance (dummy calculation for demo)
  double getTotalDistance() {
    // In a real app, you'd calculate actual distance from pickup to destination
    return _rideHistory.length * 5.2; // Demo: assume average 5.2 km per ride
  }

  // Get total ride time (dummy calculation for demo)
  Duration getTotalRideTime() {
    // In a real app, you'd track actual ride duration
    return Duration(
        minutes:
            _rideHistory.length * 18); // Demo: assume average 18 min per ride
  }

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

  // Clear cache and reset loaded state
  void clearCache() {
    _hasLoaded = false;
    _rideHistory.clear();
    _filteredHistory.clear();
    _clearError();
    notifyListeners();
  }

  // Helper methods for localized strings
  String getLocalizedError(BuildContext context) {
    if (_error != null && _error!.contains('Failed to load ride history')) {
      return context.l10n.failedLoadRideHistory;
    }
    return _error ?? context.l10n.errorOccurred;
  }

  String getLocalizedFilterName(BuildContext context, String filter) {
    return context.l10n.getFilterStatusName(filter);
  }

  Map<String, String> getLocalizedStatistics(BuildContext context) {
    final stats = getStatistics();
    return {
      context.l10n.totalRides: stats['total'].toString(),
      context.l10n.completedRides: stats['completed'].toString(),
      context.l10n.canceledRides: stats['canceled'].toString(),
      context.l10n.pendingRides: stats['pending'].toString(),
      context.l10n.acceptedRides: stats['accepted'].toString(),
    };
  }

  String getLocalizedTotalDistance(BuildContext context) {
    final distance = getTotalDistance();
    return '${distance.toStringAsFixed(1)} ${context.l10n.totalDistance}';
  }

  String getLocalizedTotalTime(BuildContext context) {
    final duration = getTotalRideTime();
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')} ${context.l10n.totalTime}';
  }
}
