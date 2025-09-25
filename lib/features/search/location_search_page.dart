import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/models/location_search_model.dart';
import '../../core/providers/location_search_provider.dart';
import '../../core/localization/localization_extension.dart';
import 'location_search_delegate.dart';
import '../booking/ride_booking_page.dart';

class LocationSearchPage extends StatefulWidget {
  final String? initialQuery;
  final LocationSearchModel? selectedLocation;

  const LocationSearchPage({
    super.key,
    this.initialQuery,
    this.selectedLocation,
  });

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');

    // Initialize provider if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LocationSearchProvider>();
      if (provider.savedPlaces.isEmpty) {
        provider.initializeDefaultPlaces(context);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(context.l10n.chooseLocation),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<LocationSearchProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Search bar
              _buildSearchBar(context, provider),

              // Content
              Expanded(
                child: _buildContent(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, LocationSearchProvider provider) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: context.l10n.searchForPlaces,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      provider.clearResults();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onTap: () => _openSearchDelegate(context, provider),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LocationSearchProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current location
          _buildCurrentLocationCard(context),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.my_location,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          context.l10n.useCurrentLocation,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          context.l10n.findPlacesNearYou,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        trailing: Icon(
          Icons.gps_fixed,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => _useCurrentLocation(context),
      ),
    );
  }

  void _openSearchDelegate(
      BuildContext context, LocationSearchProvider provider) async {
    // Clear any existing focus before opening search
    FocusScope.of(context).unfocus();

    // Small delay to ensure focus is cleared
    await Future.delayed(const Duration(milliseconds: 100));

    final result = await showSearch<LocationSearchModel?>(
      context: context,
      delegate: LocationSearchDelegate.localized(context),
    );

    if (result != null) {
      _selectLocation(context, result, provider);
    }
  }

  void _useCurrentLocation(BuildContext context) {
    // Mock current location
    final currentLocation = LocationSearchModel(
      placeId: 'current_location',
      name: context.l10n.currentLocation,
      address: context.l10n.yourCurrentPosition,
      coordinates: const LatLng(24.7136, 46.6753), // Riyadh coordinates
      type: LocationType.general,
    );

    Navigator.of(context).pop(currentLocation);
  }

  void _selectLocation(BuildContext context, LocationSearchModel location,
      LocationSearchProvider provider) {
    provider.addToRecentSearches(location);

    // Navigate to ride booking page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RideBookingPage(destination: location),
      ),
    );
  }
}
