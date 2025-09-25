# Geocoding Implementation Guide

This guide shows how to use the geocoding functionality that has been added to your Tirhal app with the API key: `AIzaSyAxV1byeoH9ZIp-cHGZg-5KaqfjypRI7ag`

## 🚀 What's Been Added

### 1. Dependencies

- ✅ Added `geocoding: ^3.0.0` to pubspec.yaml
- ✅ Installed with `flutter pub get`

### 2. Core Services

- ✅ `GeocodingService` - Core service for all geocoding operations
- ✅ `GeocodingProvider` - State management for geocoding data
- ✅ Added provider to main.dart

### 3. UI Components

- ✅ `PlaceSearchWidget` - Autocomplete search for places
- ✅ `AddressDisplayWidget` - Display addresses from coordinates
- ✅ `GeocodingDemoScreen` - Complete example implementation

## 📋 Available Features

### Reverse Geocoding (Coordinates → Address)

```dart
// Get address from coordinates
final geocodingProvider = context.read<GeocodingProvider>();
await geocodingProvider.getAddressFromLocation(24.7136, 46.6753);
String? address = geocodingProvider.currentAddress;
```

### Forward Geocoding (Address → Coordinates)

```dart
// Get coordinates from address
final geocodingProvider = context.read<GeocodingProvider>();
LatLng? location = await geocodingProvider.getLocationFromAddress("Riyadh, Saudi Arabia");
```

### Place Autocomplete

```dart
// Search for places with autocomplete
final geocodingProvider = context.read<GeocodingProvider>();
await geocodingProvider.searchPlaces("King Fahd Road");
List<PlacePrediction> predictions = geocodingProvider.placePredictions;
```

### Distance Calculation

```dart
// Calculate distance between two points
final geocodingProvider = context.read<GeocodingProvider>();
DistanceInfo? distance = await geocodingProvider.calculateDistance(
  LatLng(24.7136, 46.6753), // Origin
  LatLng(24.7240, 46.6850), // Destination
);
print('Distance: ${distance?.distance}'); // e.g., "2.3 km"
print('Duration: ${distance?.duration}'); // e.g., "5 mins"
```

## 🛠 How to Use in Your App

### 1. Simple Address Display

```dart
import 'package:provider/provider.dart';
import '../core/provider/geocoding_provider.dart';

class MyWidget extends StatelessWidget {
  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return Consumer<GeocodingProvider>(
      builder: (context, provider, child) {
        // Get address when widget builds
        if (provider.currentAddress == null) {
          provider.getAddressFromLocation(location.latitude, location.longitude);
        }

        return Text(
          provider.currentAddress ?? 'Getting address...',
          style: TextStyle(fontSize: 14),
        );
      },
    );
  }
}
```

### 2. Place Search with Autocomplete

```dart
import '../widgets/place_search_widget.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PlaceSearchWidget(
            onPlaceSelected: (LatLng location, String address) {
              print('Selected: $address at $location');
              // Handle the selected place
            },
            hintText: 'Search destination...',
          ),
          // Your other widgets
        ],
      ),
    );
  }
}
```

### 3. Integration with Google Maps

```dart
class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Place search
          PlaceSearchWidget(
            onPlaceSelected: (LatLng location, String address) {
              setState(() {
                _markers = {
                  Marker(
                    markerId: MarkerId('selected'),
                    position: location,
                    infoWindow: InfoWindow(title: address),
                  ),
                };
              });

              // Move camera to selected location
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(location, 15),
              );
            },
          ),

          // Google Map
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              onTap: (LatLng location) async {
                // Get address for tapped location
                final provider = context.read<GeocodingProvider>();
                await provider.getAddressFromLocation(
                  location.latitude,
                  location.longitude,
                );

                // Show address in a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.currentAddress ?? 'Address not found'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🎯 Quick Integration Examples

### For Ride Booking (Origin/Destination)

```dart
class RideBookingForm extends StatefulWidget {
  @override
  State<RideBookingForm> createState() => _RideBookingFormState();
}

class _RideBookingFormState extends State<RideBookingForm> {
  LatLng? _origin;
  LatLng? _destination;
  String? _originAddress;
  String? _destinationAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Origin selection
        PlaceSearchWidget(
          hintText: 'Pick-up location',
          onPlaceSelected: (location, address) {
            setState(() {
              _origin = location;
              _originAddress = address;
            });
          },
        ),

        SizedBox(height: 16),

        // Destination selection
        PlaceSearchWidget(
          hintText: 'Drop-off location',
          onPlaceSelected: (location, address) {
            setState(() {
              _destination = location;
              _destinationAddress = address;
            });
          },
        ),

        if (_origin != null && _destination != null)
          ElevatedButton(
            onPressed: () async {
              // Calculate distance and duration
              final provider = context.read<GeocodingProvider>();
              final distance = await provider.calculateDistance(_origin!, _destination!);

              print('Trip distance: ${distance?.distance}');
              print('Trip duration: ${distance?.duration}');

              // Proceed with ride booking
            },
            child: Text('Book Ride'),
          ),
      ],
    );
  }
}
```

## 🎉 Test the Implementation

To see the geocoding in action, you can:

1. **Navigate to the demo screen**: Use the `GeocodingDemoScreen` widget
2. **Try place search**: Type in the search box to see autocomplete suggestions
3. **Tap on map**: Tap anywhere on the map to get the address for that location
4. **Test distance**: Select two different locations to see distance calculation

## 🔑 API Key Security Note

The API key is currently hardcoded in `GeocodingService`. For production:

1. Move the API key to environment variables
2. Consider using Firebase Remote Config
3. Implement proper API key restrictions in Google Cloud Console

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows (limited)

The geocoding functionality is now fully integrated and ready to use throughout your Tirhal app!
