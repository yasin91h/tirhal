import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverModel {
  final String id;
  final String name;
  final LatLng location;
  final bool available;

  DriverModel({
    required this.id,
    required this.name,
    required this.location,
    required this.available,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json, String id) {
    return DriverModel(
      id: id,
      name: json['name'] ?? '',
      location: LatLng(
        (json['location']['lat'] ?? 0.0).toDouble(),
        (json['location']['lng'] ?? 0.0).toDouble(),
      ),
      available: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'available': available,
    };
  }
}
