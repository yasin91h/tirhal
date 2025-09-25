import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../localization/localization_extension.dart';

enum RideStatus { pending, accepted, canceled, completed }

class RideModel {
  final String id;
  final String userId;
  final String driverId;
  final LatLng pickup;
  final LatLng destination;
  final RideStatus status;
  final DateTime? createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  RideModel({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.pickup,
    required this.destination,
    required this.status,
    this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json, String id) {
    return RideModel(
      id: id,
      userId: json['userId'] ?? '',
      driverId: json['driverId'] ?? '',
      pickup: LatLng(
        (json['pickup']['lat'] ?? 0.0).toDouble(),
        (json['pickup']['lng'] ?? 0.0).toDouble(),
      ),
      destination: LatLng(
        (json['destination']['lat'] ?? 0.0).toDouble(),
        (json['destination']['lng'] ?? 0.0).toDouble(),
      ),
      status: _rideStatusFromString(json['status'] ?? 'pending'),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      acceptedAt: json['acceptedAt'] != null
          ? (json['acceptedAt'] as Timestamp).toDate()
          : null,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'driverId': driverId,
      'pickup': {'lat': pickup.latitude, 'lng': pickup.longitude},
      'destination': {
        'lat': destination.latitude,
        'lng': destination.longitude
      },
      'status': _rideStatusToString(status),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      if (acceptedAt != null) 'acceptedAt': Timestamp.fromDate(acceptedAt!),
      if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
    };
  }

  static RideStatus _rideStatusFromString(String status) {
    switch (status) {
      case 'accepted':
        return RideStatus.accepted;
      case 'canceled':
        return RideStatus.canceled;
      case 'completed':
        return RideStatus.completed;
      case 'pending':
      default:
        return RideStatus.pending;
    }
  }

  static String _rideStatusToString(RideStatus status) {
    switch (status) {
      case RideStatus.accepted:
        return 'accepted';
      case RideStatus.canceled:
        return 'canceled';
      case RideStatus.completed:
        return 'completed';
      case RideStatus.pending:
        return 'pending';
    }
  }

  // Helper method to get human-readable time
  String getFormattedTime(BuildContext context) {
    if (createdAt == null) return context.l10n.unknownTime;

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inMinutes < 1) {
      return context.l10n.justNow;
    } else if (difference.inMinutes < 60) {
      return context.l10n.minAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return context.l10n.hrAgo(difference.inHours);
    } else {
      return context.l10n.daysAgo(difference.inDays);
    }
  }

  // Helper method to get status color
  String getStatusDisplayName(BuildContext context) {
    switch (status) {
      case RideStatus.pending:
        return context.l10n.waitingForDriver;
      case RideStatus.accepted:
        return context.l10n.driverOnTheWay;
      case RideStatus.completed:
        return context.l10n.rideCompleted;
      case RideStatus.canceled:
        return context.l10n.rideCanceled;
    }
  }
}
