import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_search_model.dart';

class RideHistoryModel {
  final String id;
  final String userId;
  final LocationSearchModel pickup;
  final LocationSearchModel destination;
  final String carType;
  final String driverName;
  final String driverPhone;
  final String carPlate;
  final double driverRating;
  final double fare;
  final String paymentMethod;
  final DateTime startTime;
  final DateTime? endTime;
  final RideStatus status;
  final List<LatLng> routePoints;
  final double distance;
  final Duration duration;

  RideHistoryModel({
    required this.id,
    required this.userId,
    required this.pickup,
    required this.destination,
    required this.carType,
    required this.driverName,
    required this.driverPhone,
    required this.carPlate,
    required this.driverRating,
    required this.fare,
    required this.paymentMethod,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.routePoints,
    required this.distance,
    required this.duration,
  });

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      pickup: LocationSearchModel.fromJson(json['pickup'] ?? {}),
      destination: LocationSearchModel.fromJson(json['destination'] ?? {}),
      carType: json['carType'] ?? '',
      driverName: json['driverName'] ?? '',
      driverPhone: json['driverPhone'] ?? '',
      carPlate: json['carPlate'] ?? '',
      driverRating: (json['driverRating'] ?? 0.0).toDouble(),
      fare: (json['fare'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      startTime:
          DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: RideStatus.values.firstWhere(
        (s) => s.toString() == json['status'],
        orElse: () => RideStatus.completed,
      ),
      routePoints: (json['routePoints'] as List<dynamic>? ?? [])
          .map((point) => LatLng(point['lat'] ?? 0.0, point['lng'] ?? 0.0))
          .toList(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'pickup': pickup.toJson(),
      'destination': destination.toJson(),
      'carType': carType,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'carPlate': carPlate,
      'driverRating': driverRating,
      'fare': fare,
      'paymentMethod': paymentMethod,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.toString(),
      'routePoints': routePoints
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'distance': distance,
      'durationSeconds': duration.inSeconds,
    };
  }

  String get formattedDate {
    return "${startTime.day}/${startTime.month}/${startTime.year}";
  }

  String get formattedTime {
    return "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
  }

  String get formattedDistance {
    if (distance >= 1) {
      return "${distance.toStringAsFixed(1)} km";
    } else {
      return "${(distance * 1000).toInt()} m";
    }
  }

  String get formattedDuration {
    if (duration.inHours > 0) {
      return "${duration.inHours}h ${duration.inMinutes % 60}m";
    } else {
      return "${duration.inMinutes}m";
    }
  }

  String get formattedFare {
    return "\$${fare.toStringAsFixed(0)}";
  }

  RideHistoryModel copyWith({
    String? id,
    String? userId,
    LocationSearchModel? pickup,
    LocationSearchModel? destination,
    String? carType,
    String? driverName,
    String? driverPhone,
    String? carPlate,
    double? driverRating,
    double? fare,
    String? paymentMethod,
    DateTime? startTime,
    DateTime? endTime,
    RideStatus? status,
    List<LatLng>? routePoints,
    double? distance,
    Duration? duration,
  }) {
    return RideHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      carType: carType ?? this.carType,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      carPlate: carPlate ?? this.carPlate,
      driverRating: driverRating ?? this.driverRating,
      fare: fare ?? this.fare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      routePoints: routePoints ?? this.routePoints,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }
}

enum RideStatus {
  requested,
  driverAssigned,
  driverEnRoute,
  driverArrived,
  pickupCompleted,
  inProgress,
  completed,
  cancelled,
}
