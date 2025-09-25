import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/provider/geocoding_provider.dart';
import '../../widgets/place_search_widget.dart';

class GeocodingDemoScreen extends StatefulWidget {
  const GeocodingDemoScreen({super.key});

  @override
  State<GeocodingDemoScreen> createState() => _GeocodingDemoScreenState();
}

class _GeocodingDemoScreenState extends State<GeocodingDemoScreen> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = const LatLng(24.7136, 46.6753); // Riyadh default
  String? _selectedAddress;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onPlaceSelected(LatLng location, String address) {
    setState(() {
      _currentLocation = location;
      _selectedAddress = address;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_place'),
          position: location,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: address,
          ),
        ),
      };
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 15),
    );
  }

  void _showCurrentLocationAddress() async {
    final geocodingProvider = context.read<GeocodingProvider>();
    await geocodingProvider.getAddressFromLocation(
      _currentLocation.latitude,
      _currentLocation.longitude,
    );

    if (geocodingProvider.currentAddress != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Current address: ${geocodingProvider.currentAddress}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geocoding Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Widget
          Padding(
            padding: const EdgeInsets.all(16),
            child: PlaceSearchWidget(
              onPlaceSelected: _onPlaceSelected,
              hintText: 'Search for a location...',
            ),
          ),

          // Map
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 12,
              ),
              markers: _markers,
              onTap: (LatLng location) async {
                // Get address for tapped location
                final geocodingProvider = context.read<GeocodingProvider>();
                await geocodingProvider.getAddressFromLocation(
                  location.latitude,
                  location.longitude,
                );

                setState(() {
                  _currentLocation = location;
                  _selectedAddress = geocodingProvider.currentAddress;
                  _markers = {
                    Marker(
                      markerId: const MarkerId('tapped_location'),
                      position: location,
                      infoWindow: InfoWindow(
                        title: 'Tapped Location',
                        snippet: geocodingProvider.currentAddress ??
                            'Getting address...',
                      ),
                    ),
                  };
                });
              },
            ),
          ),

          // Address Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'Selected Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _showCurrentLocationAddress,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Get Address'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Consumer<GeocodingProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoadingAddress) {
                      return const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Getting address...'),
                        ],
                      );
                    }

                    return Text(
                      _selectedAddress ??
                          provider.currentAddress ??
                          'Tap on map or search for a location',
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Coordinates: ${_currentLocation.latitude.toStringAsFixed(6)}, ${_currentLocation.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
