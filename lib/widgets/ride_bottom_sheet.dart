import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/provider/RideRequestProvider.dart';
import '../../core/providers/location_search_provider.dart';
import '../../core/models/ride.dart';
import '../../core/models/location_search_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/localization_extension.dart';
import '../features/search/location_search_page.dart';
import 'location_display_widget.dart';

class RideBottomSheet extends StatelessWidget {
  const RideBottomSheet({super.key});

  Future<void> _openLocationSearch(BuildContext context) async {
    final result = await Navigator.of(context).push<LocationSearchModel>(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(),
      ),
    );

    if (result != null && context.mounted) {
      context.read<LocationSearchProvider>().setSelectedDestination(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RideRequestProvider, LocationSearchProvider>(
      builder: (context, rideProvider, locationProvider, child) {
        final currentRide = rideProvider.currentRide;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF00CFC7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: currentRide == null
                    ? _buildRequestRideContent(
                        context, rideProvider, locationProvider)
                    : _buildActiveRideContent(
                        context, rideProvider, currentRide),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRequestRideContent(BuildContext context,
      RideRequestProvider provider, LocationSearchProvider locationProvider) {
    return Column(
      children: [
        // Where to text field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            children: [
              Icon(Icons.my_location,
                  color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.currentLocation,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Where to text field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on,
                  color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _openLocationSearch(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      locationProvider.selectedDestination?.name ??
                          context.l10n.whereTo,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: locationProvider.selectedDestination != null
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Quick destination buttons
        Row(
          children: [
            Expanded(
              child: _buildQuickDestination(context, Icons.home,
                  context.l10n.home, Color(0xFF00CFC7), () {}),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickDestination(context, Icons.work,
                  context.l10n.work, Color(0xFF00CFC7), () {}),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickDestination(context, Icons.star,
                  context.l10n.saved, Color(0xFF00CFC7), () {}),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildActiveRideContent(
      BuildContext context, RideRequestProvider provider, RideModel ride) {
    String status = ride.status.toString().split('.').last;
    Color statusColor = _getStatusColor(ride.status);
    IconData statusIcon = _getStatusIcon(ride.status);

    return Column(
      children: [
        // Status header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                statusColor.withOpacity(0.1),
                statusColor.withOpacity(0.05)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      _getStatusMessage(context, ride.status),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Driver info (if accepted)
        if (ride.status == RideStatus.accepted) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.statusAccepted.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.statusAccepted.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.statusAccepted,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.driverName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        context.l10n.driverRating,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.phone, color: AppColors.statusAccepted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Trip details
        _buildTripDetails(context, ride),

        const SizedBox(height: 16),

        // Action buttons
        _buildActionButtons(context, provider, ride),
      ],
    );
  }

  Widget _buildQuickDestination(BuildContext context, IconData icon,
      String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetails(BuildContext context, RideModel ride) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RideLocationDisplay(
        pickup: ride.pickup,
        destination: ride.destination,
        textStyle: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, RideRequestProvider provider, RideModel ride) {
    if (ride.status == RideStatus.pending) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => provider.cancelRequest(ride.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            context.l10n.cancelRide,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    if (ride.status == RideStatus.accepted) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => provider.completeRequest(ride.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n.complete,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => provider.cancelRequest(ride.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n.cancel,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Color _getStatusColor(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return const Color(0xFFFF9800);
      case RideStatus.accepted:
        return const Color(0xFF4CAF50);
      case RideStatus.completed:
        return const Color(0xFF2196F3);
      case RideStatus.canceled:
        return const Color(0xFFF44336);
    }
  }

  IconData _getStatusIcon(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return Icons.hourglass_empty;
      case RideStatus.accepted:
        return Icons.check_circle;
      case RideStatus.completed:
        return Icons.done_all;
      case RideStatus.canceled:
        return Icons.cancel;
    }
  }

  String _getStatusMessage(BuildContext context, RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return context.l10n.lookingForDrivers;
      case RideStatus.accepted:
        return context.l10n.driverOnWay;
      case RideStatus.completed:
        return context.l10n.tripCompletedSuccessfully;
      case RideStatus.canceled:
        return context.l10n.tripWasCanceled;
    }
  }
}
