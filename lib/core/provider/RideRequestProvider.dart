import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirhal/core/models/ride.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequestProvider extends ChangeNotifier {
  final CollectionReference _rideCollection =
      FirebaseFirestore.instance.collection('rideRequests');

  RideModel? _currentRide;
  RideModel? get currentRide => _currentRide;

  StreamSubscription<DocumentSnapshot>? _rideSubscription;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void createRequest(
      String userId, String driverId, LatLng pickup, LatLng destination) async {
    try {
      _setLoading(true);
      _clearError();

      final docRef = _rideCollection.doc();
      final ride = RideModel(
        id: docRef.id,
        userId: userId,
        driverId: driverId,
        pickup: pickup,
        destination: destination,
        status: RideStatus.pending,
        createdAt: DateTime.now(),
      );

      final rideData = ride.toJson();
      rideData['createdAt'] = FieldValue.serverTimestamp();

      await docRef.set(rideData);
      _currentRide = ride;
      _listenToRide(docRef.id);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create ride request: $e');
      _setLoading(false);
    }
  }

  void cancelRequest(String requestId) async {
    try {
      _clearError();
      await _rideCollection.doc(requestId).update({'status': 'canceled'});
      _stopListening();
      _currentRide = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to cancel ride: $e');
    }
  }

  void acceptRequest(String requestId, String driverId) async {
    try {
      _clearError();
      await _rideCollection.doc(requestId).update({
        'status': 'accepted',
        'driverId': driverId,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _setError('Failed to accept ride: $e');
    }
  }

  void completeRequest(String requestId) async {
    try {
      _clearError();
      await _rideCollection.doc(requestId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _setError('Failed to complete ride: $e');
    }
  }

  void _listenToRide(String requestId) {
    _stopListening(); // Stop any existing listener

    _rideSubscription = _rideCollection.doc(requestId).snapshots().listen(
      (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          _currentRide = RideModel.fromJson(data, snapshot.id);
          notifyListeners();
        } else {
          _currentRide = null;
          notifyListeners();
        }
      },
      onError: (error) {
        _setError('Real-time update failed: $error');
      },
    );
  }

  Stream<List<RideModel>> getRidesForUser(String userId) {
    return _rideCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RideModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  Stream<List<RideModel>> getPendingRides() {
    return _rideCollection
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RideModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _stopListening() {
    _rideSubscription?.cancel();
    _rideSubscription = null;
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }
}
