import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../core/provider/geocoding_provider.dart';
import '../core/localization/localization_extension.dart';

class LocationDisplay extends StatefulWidget {
  final LatLng location;
  final String prefix;
  final IconData icon;
  final Color iconColor;
  final TextStyle? textStyle;
  final bool showCoordinates;
  final int maxLines;

  const LocationDisplay({
    super.key,
    required this.location,
    this.prefix = '',
    this.icon = Icons.location_on,
    this.iconColor = Colors.grey,
    this.textStyle,
    this.showCoordinates = false,
    this.maxLines = 2,
  });

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay address fetching to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAddress();
    });
  }

  @override
  void didUpdateWidget(LocationDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _getAddress();
    }
  }

  Future<void> _getAddress() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final geocodingProvider = context.read<GeocodingProvider>();
      await geocodingProvider.getAddressFromLocation(
        widget.location.latitude,
        widget.location.longitude,
      );

      if (mounted) {
        setState(() {
          _address = geocodingProvider.currentAddress;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = context.l10n.addressNotAvailable;
          _isLoading = false;
        });
      }
    }
  }

  String _getDisplayText() {
    if (_isLoading) {
      return '${widget.prefix}Getting address...';
    }

    if (_address != null && _address!.isNotEmpty) {
      final addressText = '${widget.prefix}$_address';
      if (widget.showCoordinates) {
        return '$addressText\n(${widget.location.latitude.toStringAsFixed(4)}, ${widget.location.longitude.toStringAsFixed(4)})';
      }
      return addressText;
    }

    // Fallback to coordinates
    return '${widget.prefix}${widget.location.latitude.toStringAsFixed(4)}, ${widget.location.longitude.toStringAsFixed(4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          widget.icon,
          color: widget.iconColor,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _getDisplayText(),
            style: widget.textStyle,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Simplified version for quick inline use
class QuickLocationDisplay extends StatefulWidget {
  final LatLng location;
  final String? prefix;

  const QuickLocationDisplay({
    super.key,
    required this.location,
    this.prefix,
  });

  @override
  State<QuickLocationDisplay> createState() => _QuickLocationDisplayState();
}

class _QuickLocationDisplayState extends State<QuickLocationDisplay> {
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  @override
  void didUpdateWidget(QuickLocationDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _getAddress();
    }
  }

  Future<void> _getAddress() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    // Use a delayed call to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      try {
        final geocodingProvider = context.read<GeocodingProvider>();
        await geocodingProvider.getAddressFromLocation(
          widget.location.latitude,
          widget.location.longitude,
        );

        if (mounted) {
          setState(() {
            _address = geocodingProvider.currentAddress;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _address = null;
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Text('${widget.prefix ?? ''}Getting address...');
    }

    if (_address != null && _address!.isNotEmpty) {
      return Text('${widget.prefix ?? ''}$_address');
    }

    // Fallback to coordinates
    return Text(
      '${widget.prefix ?? ''}${widget.location.latitude.toStringAsFixed(4)}, ${widget.location.longitude.toStringAsFixed(4)}',
    );
  }
}

// Widget for displaying pickup and destination together
class RideLocationDisplay extends StatelessWidget {
  final LatLng pickup;
  final LatLng destination;
  final TextStyle? textStyle;

  const RideLocationDisplay({
    super.key,
    required this.pickup,
    required this.destination,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationDisplay(
          location: pickup,
          prefix: 'Pickup: ',
          icon: Icons.my_location,
          iconColor: Theme.of(context).colorScheme.primary,
          textStyle: textStyle,
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        LocationDisplay(
          location: destination,
          prefix: 'Destination: ',
          icon: Icons.location_on,
          iconColor: Theme.of(context).colorScheme.primary,
          textStyle: textStyle,
          maxLines: 2,
        ),
      ],
    );
  }
}
