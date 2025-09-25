import 'package:flutter/material.dart';
import 'package:tirhal/core/models/user.dart';

class ProfileProvider with ChangeNotifier {
  /// Initial user data
  ProfileModel _profile = ProfileModel(
    name: "Yasin Ahmed",
    jobTitle: "Flutter Developer",
    email: "yasin91.h@gmail.com",
    phone: "+966536869750",
    location: "Riyadh, Saudi Arabia",
    imagePath: "assets/images/yasin.jpg",
  );

  /// Getter
  ProfileModel get profile => _profile;

  /// Update Profile
  void updateProfile(ProfileModel updatedProfile) {
    _profile = updatedProfile;
    notifyListeners();
  }

  /// Update single field with copyWith
  void updateField({
    String? name,
    String? jobTitle,
    String? email,
    String? phone,
    String? location,
    String? imagePath,
  }) {
    _profile = _profile.copyWith(
      name: name,
      jobTitle: jobTitle,
      email: email,
      phone: phone,
      location: location,
      imagePath: imagePath,
    );
    notifyListeners();
  }
}
