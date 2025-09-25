import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../localization/localization_extension.dart';

class LocationSearchModel {
  final String placeId;
  final String name;
  final String address;
  final LatLng? coordinates;
  final String? description;
  final LocationType type;
  final double? rating;

  LocationSearchModel({
    required this.placeId,
    required this.name,
    required this.address,
    this.coordinates,
    this.description,
    required this.type,
    this.rating,
  });

  factory LocationSearchModel.fromJson(Map<String, dynamic> json) {
    return LocationSearchModel(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? json['structured_formatting']?['main_text'] ?? '',
      address: json['formatted_address'] ??
          json['structured_formatting']?['secondary_text'] ??
          '',
      coordinates: json['geometry']?['location'] != null
          ? LatLng(
              json['geometry']['location']['lat']?.toDouble() ?? 0.0,
              json['geometry']['location']['lng']?.toDouble() ?? 0.0,
            )
          : null,
      description: json['description'],
      type: _getLocationType(json['types'] ?? []),
      rating: json['rating']?.toDouble(),
    );
  }

  // Factory for Google Places API search results
  factory LocationSearchModel.fromGooglePlaces(Map<String, dynamic> json) {
    return LocationSearchModel(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['formatted_address'] ?? json['vicinity'] ?? '',
      coordinates: json['geometry']?['location'] != null
          ? LatLng(
              json['geometry']['location']['lat']?.toDouble() ?? 0.0,
              json['geometry']['location']['lng']?.toDouble() ?? 0.0,
            )
          : null,
      type: _getLocationType(json['types'] ?? []),
      rating: json['rating']?.toDouble(),
    );
  }

  // Factory for Google Places Autocomplete predictions
  factory LocationSearchModel.fromGooglePrediction(Map<String, dynamic> json) {
    return LocationSearchModel(
      placeId: json['place_id'] ?? '',
      name: json['structured_formatting']?['main_text'] ??
          json['description'] ??
          '',
      address: json['structured_formatting']?['secondary_text'] ?? '',
      description: json['description'],
      type: _getLocationType(json['types'] ?? []),
    );
  }

  // Factory for Google Places Details API
  factory LocationSearchModel.fromGooglePlaceDetails(
      Map<String, dynamic> json, String placeId) {
    return LocationSearchModel(
      placeId: placeId,
      name: json['name'] ?? '',
      address: json['formatted_address'] ?? '',
      coordinates: json['geometry']?['location'] != null
          ? LatLng(
              json['geometry']['location']['lat']?.toDouble() ?? 0.0,
              json['geometry']['location']['lng']?.toDouble() ?? 0.0,
            )
          : null,
      type: _getLocationType(json['types'] ?? []),
      rating: json['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'name': name,
      'address': address,
      'coordinates': coordinates != null
          ? {
              'latitude': coordinates!.latitude,
              'longitude': coordinates!.longitude,
            }
          : null,
      'description': description,
      'type': type.toString().split('.').last,
      'rating': rating,
    };
  }

  static LocationType _getLocationType(List<dynamic> types) {
    final typeStrings = types.cast<String>();

    if (typeStrings.contains('airport')) return LocationType.airport;
    if (typeStrings.contains('hospital')) return LocationType.hospital;
    if (typeStrings.contains('school') || typeStrings.contains('university')) {
      return LocationType.school;
    }
    if (typeStrings.contains('shopping_mall')) return LocationType.shopping;
    if (typeStrings.contains('restaurant')) return LocationType.restaurant;
    if (typeStrings.contains('gas_station')) return LocationType.gasStation;
    if (typeStrings.contains('bank')) return LocationType.bank;
    if (typeStrings.contains('lodging')) return LocationType.hotel;

    return LocationType.general;
  }

  String get displayAddress => address.isNotEmpty ? address : name;

  String get shortName =>
      name.length > 30 ? '${name.substring(0, 30)}...' : name;

  bool get hasCoordinates => coordinates != null;
}

enum LocationType {
  general,
  restaurant,
  shopping,
  hospital,
  school,
  airport,
  gasStation,
  bank,
  hotel,
}

extension LocationTypeExtension on LocationType {
  String get displayName {
    switch (this) {
      case LocationType.general:
        return 'Location';
      case LocationType.restaurant:
        return 'Restaurant';
      case LocationType.shopping:
        return 'Shopping';
      case LocationType.hospital:
        return 'Hospital';
      case LocationType.school:
        return 'School';
      case LocationType.airport:
        return 'Airport';
      case LocationType.gasStation:
        return 'Gas Station';
      case LocationType.bank:
        return 'Bank';
      case LocationType.hotel:
        return 'Hotel';
    }
  }

  String getLocalizedName(BuildContext context) {
    switch (this) {
      case LocationType.general:
        return context.l10n.location;
      case LocationType.restaurant:
        return context.l10n.restaurant;
      case LocationType.shopping:
        return context.l10n.shopping;
      case LocationType.hospital:
        return context.l10n.hospital;
      case LocationType.school:
        return context.l10n.school;
      case LocationType.airport:
        return context.l10n.airport;
      case LocationType.gasStation:
        return context.l10n.gasStation;
      case LocationType.bank:
        return context.l10n.bank;
      case LocationType.hotel:
        return context.l10n.hotel;
    }
  }

  IconData get icon {
    switch (this) {
      case LocationType.general:
        return Icons.place;
      case LocationType.restaurant:
        return Icons.restaurant;
      case LocationType.shopping:
        return Icons.shopping_cart;
      case LocationType.hospital:
        return Icons.local_hospital;
      case LocationType.school:
        return Icons.school;
      case LocationType.airport:
        return Icons.flight;
      case LocationType.gasStation:
        return Icons.local_gas_station;
      case LocationType.bank:
        return Icons.account_balance;
      case LocationType.hotel:
        return Icons.hotel;
    }
  }
}
