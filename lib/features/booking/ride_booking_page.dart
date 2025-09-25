import 'package:flutter/material.dart';
import '../../core/models/location_search_model.dart';
import '../../core/localization/localization_extension.dart';
import '../payment/payment_selection_page.dart';

class RideBookingPage extends StatefulWidget {
  final LocationSearchModel destination;
  final LocationSearchModel? pickup;

  const RideBookingPage({
    Key? key,
    required this.destination,
    this.pickup,
  }) : super(key: key);

  @override
  State<RideBookingPage> createState() => _RideBookingPageState();
}

class _RideBookingPageState extends State<RideBookingPage> {
  int selectedCarTypeIndex = 0;

  // Currency conversion (USD to SAR)
  static const double _usdToSarRate = 3.75;

  double convertToSAR(double usdAmount) {
    return usdAmount * _usdToSarRate;
  }

  String formatPrice(double usdAmount) {
    final sarAmount = convertToSAR(usdAmount);
    return '${sarAmount.toStringAsFixed(0)} ${context.l10n.sar}';
  }

  List<CarType> getCarTypes(BuildContext context) {
    return [
      CarType(
        name: context.l10n.economy,
        icon: Icons.directions_car,
        description: context.l10n.affordableRides,
        estimatedPrice: 25.0,
        estimatedTime: '5-8 min',
        passengers: 4,
      ),
      CarType(
        name: context.l10n.comfort,
        icon: Icons.local_taxi,
        description: context.l10n.moreSpaceComfort,
        estimatedPrice: 35.0,
        estimatedTime: '4-6 min',
        passengers: 4,
      ),
      CarType(
        name: context.l10n.premium,
        icon: Icons.car_rental,
        description: context.l10n.luxuryVehicles,
        estimatedPrice: 50.0,
        estimatedTime: '3-5 min',
        passengers: 4,
      ),
      CarType(
        name: context.l10n.xl,
        icon: Icons.airport_shuttle,
        description: context.l10n.extraSpaceGroups,
        estimatedPrice: 40.0,
        estimatedTime: '6-10 min',
        passengers: 6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chooseYourRide),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Trip info
          _buildTripInfo(),

          // Car types list
          Expanded(
            child: _buildCarTypesList(),
          ),

          // Bottom booking section
          _buildBottomBookingSection(),
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          children: [
            // Pickup location
            _buildLocationRow(
              icon: Icons.radio_button_checked,
              iconColor: Colors.green,
              title: widget.pickup?.name ?? context.l10n.currentLocationPickup,
              subtitle:
                  widget.pickup?.address ?? context.l10n.yourCurrentPosition,
            ),

            // Connection line
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Container(
                    width: 2,
                    height: 30,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Destination location
            _buildLocationRow(
              icon: Icons.location_on,
              iconColor: Theme.of(context).colorScheme.primary,
              title: widget.destination.name,
              subtitle: widget.destination.address,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
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

  Widget _buildCarTypesList() {
    final carTypes = getCarTypes(context);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: carTypes.length,
      itemBuilder: (context, index) {
        final carType = carTypes[index];
        final isSelected = selectedCarTypeIndex == index;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedCarTypeIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Car icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        carType.icon,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Car info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                carType.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.person,
                                size: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${carType.passengers}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            carType.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.7),
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            carType.estimatedTime,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Text(
                      formatPrice(carType.estimatedPrice),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBookingSection() {
    final carTypes = getCarTypes(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price breakdown
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.estimatedTotal,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                  ),
                  Text(
                    formatPrice(carTypes[selectedCarTypeIndex].estimatedPrice),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Request ride button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _requestRide(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '${context.l10n.requestRide} ${carTypes[selectedCarTypeIndex].name}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestRide(BuildContext context) {
    final carTypes = getCarTypes(context);
    final selectedCarType = carTypes[selectedCarTypeIndex];

    // Navigate to payment selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSelectionPage(
          destination: widget.destination,
          pickup: widget.pickup,
          carType: selectedCarType,
        ),
      ),
    );
  }
}

// Car type model
class CarType {
  final String name;
  final IconData icon;
  final String description;
  final double estimatedPrice;
  final String estimatedTime;
  final int passengers;

  CarType({
    required this.name,
    required this.icon,
    required this.description,
    required this.estimatedPrice,
    required this.estimatedTime,
    required this.passengers,
  });
}
