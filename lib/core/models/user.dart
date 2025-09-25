class ProfileModel {
  final String name;
  final String jobTitle;
  final String email;
  final String phone;
  final String location;
  final String imagePath;

  ProfileModel({
    required this.name,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.location,
    required this.imagePath,
  });

  /// Copy with method (to update only some fields)
  ProfileModel copyWith({
    String? name,
    String? jobTitle,
    String? email,
    String? phone,
    String? location,
    String? imagePath,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
