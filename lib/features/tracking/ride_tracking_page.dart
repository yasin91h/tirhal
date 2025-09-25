import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/core/models/payment_method_model.dart';
import '../../core/models/location_search_model.dart';
import '../../core/models/ride_history_model.dart';
import '../../core/provider/ride_tracking_provider.dart';
import '../../core/localization/localization_extension.dart';

import '../booking/ride_booking_page.dart';

class RideTrackingPage extends StatefulWidget {
  final LocationSearchModel destination;
  final LocationSearchModel? pickup;
  final CarType carType;
  final PaymentMethod paymentMethod;

  const RideTrackingPage({
    Key? key,
    required this.destination,
    required this.pickup,
    required this.carType,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<RideTrackingPage> createState() => _RideTrackingPageState();
}

class _RideTrackingPageState extends State<RideTrackingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize ride tracking with provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRideTracking();
    });
  }

  @override
  void dispose() {
    _pulseAnimationController.dispose();
    // Provider will manage its own cleanup - no context access needed here
    super.dispose();
  }

  Future<void> _initializeRideTracking() async {
    final provider = Provider.of<RideTrackingProvider>(context, listen: false);

    try {
      await provider.initializeRide(
        destination: widget.destination,
        pickup: widget.pickup,
        carType: widget.carType,
        paymentMethod: widget.paymentMethod,
      );
    } catch (e) {
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.l10n.errorInitializingRide}: ${e.toString()}',
              style: TextStyle(
                color: theme.colorScheme.onError,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    final provider = Provider.of<RideTrackingProvider>(context, listen: false);
    provider.setMapController(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideTrackingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: provider.driverLocation,
                  zoom: 14,
                ),
                markers: provider.markers,
                polylines: provider.polylines,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

              // Top status card
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: _buildStatusCard(provider),
              ),

              // Bottom ride info sheet
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildRideInfoSheet(provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(RideTrackingProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(provider.rideStatus),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.getLocalizedStatusMessage(context),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  context.l10n.eta(provider.getLocalizedEstimatedTime(context)),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          if (provider.rideStatus != RideStatus.completed)
            IconButton(
              onPressed: () => _showCancelDialog(provider),
              icon: Icon(Icons.close, color: theme.colorScheme.error),
            ),
        ],
      ),
    );
  }

  Widget _buildRideInfoSheet(RideTrackingProvider provider) {
    final ride = provider.currentRide;
    if (ride == null) return const SizedBox();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Driver info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    ride.driverName.split(' ').map((e) => e[0]).join(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.getLocalizedDriverName(context),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            ride.driverRating.toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            ride.carPlate,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _callDriver(ride.driverPhone),
                      icon: Icon(Icons.phone, color: theme.colorScheme.primary),
                    ),
                    IconButton(
                      onPressed: () => _messageDriver(ride.driverName),
                      icon:
                          Icon(Icons.message, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Trip details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildLocationRow(
                  Icons.my_location,
                  context.l10n.pickupLocationLabel,
                  ride.pickup.address == "Current Location"
                      ? provider.getLocalizedCurrentLocationLabel(context)
                      : ride.pickup.address,
                  const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 12),
                _buildLocationRow(
                  Icons.location_on,
                  context.l10n.destination,
                  ride.destination.address,
                  const Color(0xFFF44336),
                ),
              ],
            ),
          ),

          // Trip summary
          if (provider.rideStatus == RideStatus.completed)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    context.l10n.tripCompleted,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.totalFare,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        '${ride.fare.toStringAsFixed(2)} SAR',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        context.l10n.done,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
      IconData icon, String title, String address, Color color) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(RideStatus status) {
    switch (status) {
      case RideStatus.driverEnRoute:
        return const Color(0xFFF57C00);
      case RideStatus.driverArrived:
        return const Color(0xFF4CAF50);
      case RideStatus.inProgress:
        return const Color(0xFF2196F3);
      case RideStatus.completed:
        return const Color(0xFF4CAF50);
      case RideStatus.cancelled:
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  void _showCancelDialog(RideTrackingProvider provider) {
    final theme = Theme.of(context); // Capture theme early

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(context.l10n.cancelRide, style: theme.textTheme.titleLarge),
        content: Text(context.l10n.areYouSureCancelRide,
            style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.l10n.no,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              // Capture localized strings before async operations
              final rideCanceledText = context.l10n.rideCanceled;
              final errorCancellingRideText = context.l10n.errorCancellingRide;

              navigator.pop();

              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => PopScope(
                  canPop: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary), // Use captured theme
                    ),
                  ),
                ),
              );

              try {
                // Cancel the ride
                await provider.cancelRide();

                // Add small delay to ensure provider state is properly updated
                await Future.delayed(const Duration(milliseconds: 500));

                // Close loading dialog
                if (mounted) {
                  navigator.pop(); // Close loading dialog

                  // Show success message
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        rideCanceledText, // Use captured string
                        style: TextStyle(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Wait a bit before navigation to let snackbar show
                  await Future.delayed(const Duration(milliseconds: 800));

                  // Navigate back to home safely
                  if (mounted) {
                    navigator.popUntil((route) => route.isFirst);
                  }
                }
              } catch (e) {
                // Handle error
                if (mounted) {
                  navigator.pop(); // Close loading dialog
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '$errorCancellingRideText: ${e.toString()}', // Use captured string
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: Text(
              context.l10n.yesCancel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callDriver(String phoneNumber) {
    final theme = Theme.of(context);

    // Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${context.l10n.callingDriver} $phoneNumber',
          style: TextStyle(
            color: theme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _messageDriver(String driverName) {
    final theme = Theme.of(context);

    // Implement messaging functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${context.l10n.openingChatWith} $driverName',
          style: TextStyle(
            color: theme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
