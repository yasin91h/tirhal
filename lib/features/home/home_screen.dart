import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/core/models/ride.dart';
import 'package:tirhal/core/provider/DriversProvider.dart';
import 'package:tirhal/core/provider/RideRequestProvider.dart';
import 'package:tirhal/core/provider/UserLocationProvider.dart';
import 'package:tirhal/widgets/location_permission_widget.dart';
import 'package:tirhal/widgets/location_loading_widget.dart';
import 'package:tirhal/widgets/ride_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only fetch drivers, location is now handled at app startup
      Provider.of<DriversProvider>(context, listen: false).fetchDrivers();
    });
  }

  // add the drivers from the provider to the map as markers

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<UserLocationProvider>(context);
    final driversProvider = Provider.of<DriversProvider>(context);
    final rideProvider = Provider.of<RideRequestProvider>(context);

    // Show error message if there's a location error
    if (locationProvider.error != null) {
      return LocationPermissionWidget(
        customMessage: locationProvider.error!,
        onRetry: () {
          locationProvider.clearError();
          locationProvider.refreshLocation();
        },
      );
    }

    // Show loading spinner while getting location
    if (locationProvider.loading || locationProvider.currentLocation == null) {
      return const LocationLoadingWidget();
    }

    // Camera animation to driver location if a ride is accepted
    if (rideProvider.currentRide != null &&
        rideProvider.currentRide!.status == RideStatus.accepted) {
      final driver = driversProvider.drivers.firstWhere(
        (d) => d.id == rideProvider.currentRide!.driverId,
        orElse: () => driversProvider.drivers.first,
      );

      _controller.future.then((mapController) {
        mapController.animateCamera(
          CameraUpdate.newLatLng(driver.location),
        );
      });
    }

    return Scaffold(
      body: Container(
        // add primary color background to avoid white flashes
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Stack(
            children: [
              Consumer<DriversProvider>(
                  builder: (context, driversProvider, child) {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      24.7136,
                      46.6753,
                    ),
                    zoom: 15,
                  ),
                  markers: driversProvider.markers,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted)
                      _controller.complete(controller);
                  },
                );
              }),

              // Search bar and notifications button
            ],
          ),
        ),
      ),
      // Add the bottom sheet here
      bottomSheet: const RideBottomSheet(),
    );
  }
}
