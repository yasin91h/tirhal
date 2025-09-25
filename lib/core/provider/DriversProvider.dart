import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tirhal/core/models/driver.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class DriversProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DriverModel> _drivers = [];
  List<DriverModel> get drivers => _drivers;

  Set<Marker> markers = {};

  BitmapDescriptor? _carIconGreen;
  BitmapDescriptor? _carIconRed;

  DriversProvider() {
    _loadCarIcons();
    _listenToDrivers();
  }

  Future<BitmapDescriptor> getResizedCarIcon(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  Future<void> _loadCarIcons() async {
    _carIconGreen = await getResizedCarIcon("assets/images/car.png", 180);
    _carIconRed = await getResizedCarIcon("assets/images/car.png", 180);
  }

  void _listenToDrivers() {
    _firestore.collection("drivers").snapshots().listen((snapshot) {
      _drivers = snapshot.docs.map((doc) {
        return DriverModel.fromJson(doc.data(), doc.id);
      }).toList();
      driverMarkers();
      notifyListeners();
    });
  }

  Future<void> fetchDrivers() async {
    final snapshot = await _firestore.collection("drivers").get();
    _drivers = snapshot.docs.map((doc) {
      return DriverModel.fromJson(doc.data(), doc.id);
    }).toList();
    driverMarkers();
    notifyListeners();
  }

  void driverMarkers() {
    markers = drivers.map((driver) {
      return Marker(
        markerId: MarkerId(driver.id),
        position: driver.location,
        infoWindow: InfoWindow(
          title: driver.name,
          snippet: driver.available ? "Available" : "Busy",
        ),
        icon: driver.available
            ? (_carIconGreen ?? BitmapDescriptor.defaultMarker)
            : (_carIconRed ?? BitmapDescriptor.defaultMarker),
      );
    }).toSet();

    notifyListeners();
  }

  Future<void> addDummyDrivers() async {
    final dummyDrivers = [
      {
        "name": "Ahmed",
        "location": {"lat": 30.050, "lng": 31.200},
        "available": true,
      },
      {
        "name": "Ali",
        "location": {"lat": 30.052, "lng": 31.205},
        "available": true,
      },
      {
        "name": "Omar",
        "location": {"lat": 30.054, "lng": 31.210},
        "available": false,
      },
      {
        "name": "Hassan",
        "location": {"lat": 30.056, "lng": 31.215},
        "available": true,
      },
      {
        "name": "Khaled",
        "location": {"lat": 30.058, "lng": 31.220},
        "available": true,
      },
      {
        "name": "Youssef",
        "location": {"lat": 30.060, "lng": 31.225},
        "available": false,
      },
      {
        "name": "Mahmoud",
        "location": {"lat": 30.062, "lng": 31.230},
        "available": true,
      },
      {
        "name": "Mostafa",
        "location": {"lat": 30.064, "lng": 31.235},
        "available": true,
      },
      {
        "name": "Ibrahim",
        "location": {"lat": 30.066, "lng": 31.240},
        "available": true,
      },
      {
        "name": "Tamer",
        "location": {"lat": 30.068, "lng": 31.245},
        "available": false,
      },
    ];

    final driversCollection = _firestore.collection("drivers");

    for (var driver in dummyDrivers) {
      await driversCollection.add(driver);
    }
  }
}
