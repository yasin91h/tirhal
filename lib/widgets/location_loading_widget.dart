import 'package:flutter/material.dart';
import '../core/localization/localization_extension.dart';

class LocationLoadingWidget extends StatelessWidget {
  final String? customMessage;

  const LocationLoadingWidget({
    super.key,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated location icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_searching,
                  size: 50,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              // Loading indicator
              CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 3,
              ),

              const SizedBox(height: 24),

              // Loading message
              Text(
                customMessage ?? context.l10n.gettingYourLocation,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                context.l10n.thisMayTakeFewSeconds,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
