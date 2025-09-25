import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/provider/geocoding_provider.dart';
import '../core/services/geocoding_service.dart';

import '../core/localization/localization_extension.dart';

class PlaceSearchWidget extends StatefulWidget {
  final Function(LatLng, String)? onPlaceSelected;
  final String? hintText;
  final bool showCurrentLocationOption;

  const PlaceSearchWidget({
    super.key,
    this.onPlaceSelected,
    this.hintText,
    this.showCurrentLocationOption = true,
  });

  @override
  State<PlaceSearchWidget> createState() => _PlaceSearchWidgetState();
}

class _PlaceSearchWidgetState extends State<PlaceSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showPredictions = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final geocodingProvider = context.read<GeocodingProvider>();

    if (query.isEmpty) {
      setState(() {
        _showPredictions = false;
      });
      geocodingProvider.clearPredictions();
    } else {
      setState(() {
        _showPredictions = true;
      });
      geocodingProvider.searchPlaces(query);
    }
  }

  Future<void> _selectPlace(PlacePrediction prediction) async {
    final geocodingProvider = context.read<GeocodingProvider>();

    // Get detailed place information
    final placeDetails =
        await geocodingProvider.getPlaceDetails(prediction.placeId);

    if (placeDetails != null) {
      _searchController.text = placeDetails.formattedAddress;
      setState(() {
        _showPredictions = false;
      });
      _focusNode.unfocus();

      // Callback with location and address
      widget.onPlaceSelected
          ?.call(placeDetails.location, placeDetails.formattedAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeocodingProvider>(
      builder: (context, geocodingProvider, child) {
        return Column(
          children: [
            // Search TextField
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? context.l10n.searchForPlace,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            // Predictions List
            if (_showPredictions) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Current Location Option
                    if (widget.showCurrentLocationOption)
                      ListTile(
                        leading:
                            const Icon(Icons.my_location, color: Colors.blue),
                        title: Text(context.l10n.useCurrentLocation),
                        onTap: () async {
                          // You can implement current location logic here
                          setState(() {
                            _showPredictions = false;
                          });
                          _focusNode.unfocus();
                        },
                      ),

                    // Loading indicator
                    if (geocodingProvider.isLoadingPredictions)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),

                    // Predictions
                    ...geocodingProvider.placePredictions.map((prediction) {
                      return ListTile(
                        leading:
                            const Icon(Icons.location_on, color: Colors.grey),
                        title: Text(
                          prediction.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () => _selectPlace(prediction),
                      );
                    }).toList(),

                    // Error message
                    if (geocodingProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          geocodingProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class AddressDisplayWidget extends StatelessWidget {
  final LatLng location;
  final String? customAddress;

  const AddressDisplayWidget({
    super.key,
    required this.location,
    this.customAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GeocodingProvider>(
      builder: (context, geocodingProvider, child) {
        // If custom address is provided, use it
        if (customAddress != null) {
          return _buildAddressCard(customAddress!);
        }

        // If we have current address from provider, use it
        if (geocodingProvider.currentAddress != null) {
          return _buildAddressCard(geocodingProvider.currentAddress!);
        }

        // If loading address
        if (geocodingProvider.isLoadingAddress) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Getting address...'),
                ],
              ),
            ),
          );
        }

        // Get address for current location
        WidgetsBinding.instance.addPostFrameCallback((_) {
          geocodingProvider.getAddressFromLocation(
            location.latitude,
            location.longitude,
          );
        });

        return _buildAddressCard('Getting address...');
      },
    );
  }

  Widget _buildAddressCard(String address) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
