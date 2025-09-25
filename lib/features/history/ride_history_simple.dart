import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/ride.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/location_display_widget.dart';
import 'ride_historyprovider.dart';
import '../../core/localization/localization_extension.dart';
import '../../core/providers/language_provider.dart';

class RideHistoryScreenSimple extends StatefulWidget {
  const RideHistoryScreenSimple({super.key});

  @override
  State<RideHistoryScreenSimple> createState() =>
      _RideHistoryScreenSimpleState();
}

class _RideHistoryScreenSimpleState extends State<RideHistoryScreenSimple> {
  final String _currentUserId = 'user123'; // Demo user ID

  @override
  void initState() {
    super.initState();
    // Load initial data only if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RideHistoryProvider>();
      if (!provider.hasLoaded) {
        provider.loadRideHistory(_currentUserId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            final text = context.l10n.rideHistory;
            print(
                'LanguageProvider - Selected Language: ${languageProvider.selectedLanguage}');
            print('LanguageProvider - Is RTL: ${languageProvider.isRTL}');
            print('AppBar Text: $text');
            return Text(
              text,
              style: Theme.of(context).appBarTheme.titleTextStyle,
              textDirection: languageProvider.isRTL
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            );
          },
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<RideHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(context.l10n.loadingRideHistory),
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error,
                      size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.errorLoadingRides,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.getLocalizedError(context),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textLight,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadRideHistory(_currentUserId,
                          forceRefresh: true);
                    },
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (provider.rideHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    context.l10n.noRidesFound,
                    style:
                        TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    context.l10n.rideHistoryWillAppearHere,
                    style: TextStyle(color: AppColors.textLight),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.rideHistory.length,
            itemBuilder: (context, index) {
              final ride = provider.rideHistory[index];
              return _buildSimpleRideCard(ride);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<RideHistoryProvider>()
              .loadRideHistory(_currentUserId, forceRefresh: true);
        },
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Icon(Icons.refresh,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
      ),
    );
  }

  Widget _buildSimpleRideCard(RideModel ride) {
    final statusColor =
        AppColors.getStatusColor(ride.status.toString().split('.').last);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getStatusIcon(ride.status),
                      color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.getStatusDisplayName(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${context.l10n.rideId} ${ride.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  ride.getFormattedTime(context),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LocationDisplay(
                    location: ride.pickup,
                    prefix: context.l10n.from,
                    icon: Icons.my_location,
                    iconColor: Theme.of(context).colorScheme.primary,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LocationDisplay(
                    location: ride.destination,
                    prefix: context.l10n.to,
                    icon: Icons.place,
                    iconColor: Theme.of(context).colorScheme.primary,
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}
