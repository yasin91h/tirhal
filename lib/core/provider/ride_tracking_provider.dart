import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import '../models/location_search_model.dart';
import '../models/payment_method_model.dart';
import '../models/ride_history_model.dart';
import '../services/ride_history_service.dart';
import '../services/routing_service.dart';
import '../localization/localization_extension.dart';

import '../../features/booking/ride_booking_page.dart';

class RideTrackingProvider extends ChangeNotifier {
  // Services
  final RideHistoryService _rideHistoryService = RideHistoryService();
  final RoutingService _routingService = RoutingService();

  // Controllers and timers
  GoogleMapController? _mapController;
  Timer? _locationUpdateTimer;
  bool _disposed = false; // Track disposal state

  // Current locations
  LatLng _userLocation = const LatLng(24.7136, 46.6753); // Riyadh center
  LatLng _driverLocation =
      const LatLng(24.7250, 46.6850); // Driver starting location
  LatLng _destinationLocation = const LatLng(24.7000, 46.6900);

  // Ride status and tracking
  RideStatus _rideStatus = RideStatus.driverEnRoute;
  RideHistoryModel? _currentRide;
  bool _isLoading = false;
  String _statusMessage =
      "Driver is on the way"; // Will be localized when context is available
  String _estimatedTime = "5 min";

  // Route polylines
  List<LatLng> _routeToPickup = [];
  List<LatLng> _routeToDestination = [];
  List<LatLng> _currentRoute = [];

  // Map markers
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Driver movement simulation
  List<LatLng> _driverPath = [];
  int _currentPathIndex = 0;
  bool _isMovingToPickup = true;

  // Getters
  LatLng get userLocation => _userLocation;
  LatLng get driverLocation => _driverLocation;
  LatLng get destinationLocation => _destinationLocation;
  RideStatus get rideStatus => _rideStatus;
  RideHistoryModel? get currentRide => _currentRide;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  String get estimatedTime => _estimatedTime;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  GoogleMapController? get mapController => _mapController;

  // Safe notify listeners method
  @override
  void notifyListeners() {
    if (!_disposed) {
      try {
        super.notifyListeners();
      } catch (e) {
        // Ignore notification errors if widget tree is unstable
        print('Warning: Could not notify listeners: $e');
      }
    }
  }

  // Custom car icon creation
  BitmapDescriptor? _carIcon;

  Future<void> _createCarIcon() async {
    if (_carIcon == null) {
      // Use the same resizing method as DriversProvider for consistency
      final ByteData data = await rootBundle.load('assets/images/car.png');
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 180, // Same size as home page drivers
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final byteData =
          await fi.image.toByteData(format: ui.ImageByteFormat.png);
      final resizedBytes = byteData!.buffer.asUint8List();
      _carIcon = BitmapDescriptor.fromBytes(resizedBytes);
    }
  }

  // Setters
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void setDestination(LatLng destination) {
    _destinationLocation = destination;
    notifyListeners();
  }

  void setUserLocation(LatLng location) {
    _userLocation = location;
    notifyListeners();
  }

  // Reset ride state for new ride
  void _resetRideState() {
    // Reset disposed state for provider reuse
    _disposed = false;

    // Cancel any existing timers
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;

    // Reset ride status to initial state
    _rideStatus = RideStatus.driverEnRoute;
    _currentRide = null;
    _isLoading = false;
    _statusMessage = "Driver is on the way"; // Will be localized by UI
    _estimatedTime = "5 min";

    // Clear routes and paths
    _routeToPickup.clear();
    _routeToDestination.clear();
    _currentRoute.clear();
    _driverPath.clear();

    // Clear markers and polylines
    _markers.clear();
    _polylines.clear();

    // Reset driver movement state
    _currentPathIndex = 0;
    _isMovingToPickup = true;

    // Reset locations to default
    _userLocation = const LatLng(24.7136, 46.6753); // Riyadh center
    _driverLocation =
        const LatLng(24.7250, 46.6850); // Driver starting location
    _destinationLocation = const LatLng(24.7000, 46.6900);
  }

  // Initialize ride tracking
  Future<void> initializeRide({
    required LocationSearchModel destination,
    LocationSearchModel? pickup,
    required CarType carType,
    required PaymentMethod paymentMethod,
  }) async {
    // Prevent multiple simultaneous initialization calls
    if (_isLoading) {
      print('Ride initialization already in progress, skipping...');
      return;
    }

    // Reset/clear previous ride state
    _resetRideState();

    _isLoading = true;
    notifyListeners();

    try {
      // Set destination coordinates
      if (destination.coordinates != null) {
        _destinationLocation = destination.coordinates!;
      }

      // Set pickup coordinates if provided
      if (pickup?.coordinates != null) {
        _userLocation = pickup!.coordinates!;
      }

      // Create ride history entry
      _currentRide = RideHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: "user123",
        pickup: pickup ??
            LocationSearchModel(
              name: "Current Location", // This will be localized in UI
              address: "Current Location", // This will be localized in UI
              coordinates: _userLocation,
              placeId: "current_location",
              type: LocationType.general,
            ),
        destination: destination,
        carType: _getCarTypeString(carType),
        driverName: "Ahmed Mohamed", // This will use localized name in UI
        driverPhone: "+966501234567",
        carPlate: "ABC 1234",
        driverRating: 4.8,
        fare: _calculateFare(carType),
        paymentMethod: paymentMethod.name,
        startTime: DateTime.now(),
        status: RideStatus.driverEnRoute,
        routePoints: [],
        distance: _calculateDistance(),
        duration: const Duration(minutes: 15),
      );

      // Add to ride history
      await _rideHistoryService.addRideToHistory(_currentRide!);

      // Load routes
      await _loadRoutes();

      // Start driver simulation
      _startDriverMovement();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Load routes from routing service
  Future<void> _loadRoutes() async {
    try {
      print(
          'Loading routes from $_driverLocation to $_userLocation to $_destinationLocation');

      // Get full route data with timeout protection
      final routeData = await _routingService.getMultiStopRoute(
        _driverLocation,
        _userLocation,
        _destinationLocation,
      );

      // Extract route points
      _routeToPickup = routeData.driverToPickupRoute.points;
      _routeToDestination = routeData.pickupToDestinationRoute.points;

      print(
          'Routes loaded successfully: ${_routeToPickup.length} pickup points, ${_routeToDestination.length} destination points');

      // Set initial route (driver to pickup)
      _currentRoute = _routeToPickup;
      _driverPath = List.from(_routeToPickup);

      await _updateMarkersAndPolylines();
    } catch (e) {
      print('Error loading routes: $e');
      // Use fallback direct routes
      _routeToPickup = [_driverLocation, _userLocation];
      _routeToDestination = [_userLocation, _destinationLocation];
      _currentRoute = _routeToPickup;
      _driverPath = List.from(_routeToPickup);
      await _updateMarkersAndPolylines();
    }
  }

  // Update markers and polylines
  Future<void> _updateMarkersAndPolylines() async {
    try {
      // Create car icon if not already created
      await _createCarIcon();

      _markers = {
        Marker(
          markerId: const MarkerId('user'),
          position: _userLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLocation,
          icon: _carIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Driver'),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      };

      _polylines = {
        if (_currentRoute.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('route'),
            points: _currentRoute,
            color: const Color(0xFF00CFC7),
            width: 4,
            patterns: [],
          ),
      };

      notifyListeners();
    } catch (e) {
      print('Error updating markers and polylines: $e');
      // Continue without throwing to prevent app freezing
    }
  }

  // Start driver movement simulation
  void _startDriverMovement() {
    // Ensure any previous timer is cancelled
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;

    // Start new timer only if we have a valid path
    if (_driverPath.isNotEmpty) {
      _locationUpdateTimer =
          Timer.periodic(const Duration(seconds: 2), (timer) {
        _simulateDriverMovement();
      });
    }
  }

  // Simulate driver movement
  void _simulateDriverMovement() {
    if (_driverPath.isEmpty || _currentPathIndex >= _driverPath.length) {
      _handlePhaseCompletion();
      return;
    }

    // Move driver to next point
    _driverLocation = _driverPath[_currentPathIndex];
    _currentPathIndex++;

    // Update estimated time
    final remainingPoints = _driverPath.length - _currentPathIndex;
    final estimatedMinutes = (remainingPoints * 0.5).ceil();
    _estimatedTime = "$estimatedMinutes min";

    // Update markers asynchronously without waiting
    _updateMarkersAndPolylines();

    // Auto-center camera on driver
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_driverLocation),
    );
  }

  // Handle phase completion (pickup reached, destination reached)
  void _handlePhaseCompletion() {
    if (_isMovingToPickup && _rideStatus == RideStatus.driverEnRoute) {
      // Driver reached pickup location
      _rideStatus = RideStatus.driverArrived;
      _statusMessage = "Driver has arrived"; // Will be localized by UI
      _estimatedTime = "Arrived";

      // Wait 3 seconds then start trip
      Timer(const Duration(seconds: 3), () async {
        await _startTrip();
      });
    } else if (_rideStatus == RideStatus.inProgress) {
      // Trip completed - run in background to avoid blocking UI
      _completeRide().catchError((error) {
        print('Error completing ride: $error');
      });
    }

    notifyListeners();
  }

  // Start the trip (driver picked up passenger)
  Future<void> _startTrip() async {
    _rideStatus = RideStatus.inProgress;
    _statusMessage = "Trip in progress"; // Will be localized by UI
    _isMovingToPickup = false;

    // Switch to destination route
    _currentRoute = _routeToDestination;
    _driverPath = List.from(_routeToDestination);
    _currentPathIndex = 0;

    // Update current ride status
    if (_currentRide != null) {
      final updatedRide = _currentRide!.copyWith(
        status: RideStatus.inProgress,
        routePoints: _currentRoute,
      );
      _currentRide = updatedRide;
      await _rideHistoryService.updateRideStatus(
          _currentRide!.id, RideStatus.inProgress);
    }

    // Update markers asynchronously without waiting
    _updateMarkersAndPolylines();
    notifyListeners();
  }

  // Complete the ride
  Future<void> _completeRide() async {
    _rideStatus = RideStatus.completed;
    _statusMessage = "Trip completed"; // Will be localized by UI
    _estimatedTime = "Completed";

    // Update ride history
    if (_currentRide != null) {
      final completedRide = _currentRide!.copyWith(
        status: RideStatus.completed,
        endTime: DateTime.now(),
        routePoints: [..._routeToPickup, ..._routeToDestination],
      );
      _currentRide = completedRide;
      await _rideHistoryService.updateRideStatus(
          _currentRide!.id, RideStatus.completed);
    }

    // Stop location updates
    _locationUpdateTimer?.cancel();

    notifyListeners();
  }

  // Cancel the ride
  Future<void> cancelRide() async {
    try {
      _rideStatus = RideStatus.cancelled;
      _statusMessage = "Ride cancelled"; // Will be localized by UI

      // Stop any ongoing timers first
      _locationUpdateTimer?.cancel();
      _locationUpdateTimer = null;

      // Update ride history if exists
      if (_currentRide != null) {
        await _rideHistoryService.updateRideStatus(
            _currentRide!.id, RideStatus.cancelled);
      }

      // Clear current ride data
      _currentRide = null;
      _isLoading = false;

      // Reset driver path and movement
      _driverPath.clear();
      _currentPathIndex = 0;
      _isMovingToPickup = true;

      // Clear routes
      _routeToPickup.clear();
      _routeToDestination.clear();
      _currentRoute.clear();

      // Update UI
      // Update markers asynchronously without waiting
      _updateMarkersAndPolylines();
      notifyListeners();
    } catch (e) {
      print('Error cancelling ride: $e');
      rethrow;
    }
  }

  // Helper methods
  String _getCarTypeString(CarType carType) {
    return carType.name;
  }

  double _calculateFare(CarType carType) {
    return carType.estimatedPrice;
  }

  double _calculateDistance() {
    const double earthRadius = 6371; // kilometers

    double lat1Rad = _userLocation.latitude * pi / 180;
    double lon1Rad = _userLocation.longitude * pi / 180;
    double lat2Rad = _destinationLocation.latitude * pi / 180;
    double lon2Rad = _destinationLocation.longitude * pi / 180;

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Helper methods for localized strings - these should be called from UI with valid context
  String getLocalizedStatusMessage(BuildContext? context) {
    if (context == null) {
      return _statusMessage; // Return fallback message
    }

    try {
      switch (_rideStatus) {
        case RideStatus.requested:
          return context.l10n.rideStatusSearching;
        case RideStatus.driverAssigned:
          return context.l10n.rideStatusConfirmed;
        case RideStatus.driverEnRoute:
          return context.l10n.rideStatusOnWay;
        case RideStatus.driverArrived:
          return context.l10n.rideStatusArrived;
        case RideStatus.pickupCompleted:
        case RideStatus.inProgress:
          return context.l10n.rideStatusInProgress;
        case RideStatus.completed:
          return context.l10n.rideStatusCompleted;
        case RideStatus.cancelled:
          return context.l10n.rideStatusCancelled;
      }
    } catch (e) {
      // Return fallback if context is invalid
      return _statusMessage;
    }
  }

  String getLocalizedDriverName(BuildContext? context) {
    if (context == null) return "Ahmed Mohamed"; // Fallback

    try {
      return context.l10n.driverAhmed; // Default to Ahmed for now
    } catch (e) {
      return "Ahmed Mohamed"; // Fallback
    }
  }

  String getLocalizedCurrentLocationLabel(BuildContext? context) {
    if (context == null) return "Current Location"; // Fallback

    try {
      return context.l10n.currentLocation;
    } catch (e) {
      return "Current Location"; // Fallback
    }
  }

  String getLocalizedEstimatedTime(BuildContext? context) {
    if (context == null || _estimatedTime != "Completed") {
      return _estimatedTime; // Return time as-is for most cases
    }

    try {
      return context.l10n.estimatedTimeCompleted;
    } catch (e) {
      return "Completed"; // Fallback
    }
  }

  // Update status message with localized string - should be called from UI with valid context
  void updateStatusMessage(BuildContext? context) {
    if (context != null) {
      try {
        _statusMessage = getLocalizedStatusMessage(context);
        notifyListeners();
      } catch (e) {
        // Ignore context errors - status message will remain in fallback language
        print('Warning: Could not update localized status message: $e');
      }
    }
  }

  @override
  void dispose() {
    _disposed = true; // Mark as disposed to prevent notifications

    // Cancel any running timers
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;

    // Dispose map controller
    _mapController?.dispose();
    _mapController = null;

    // Clear collections
    _markers.clear();
    _polylines.clear();
    _driverPath.clear();
    _routeToPickup.clear();
    _routeToDestination.clear();
    _currentRoute.clear();

    super.dispose();
  }
}
