import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.isDefault,
  });

  PaymentMethod copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? description,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethod &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.description == description &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        icon.hashCode ^
        description.hashCode ^
        isDefault.hashCode;
  }

  @override
  String toString() {
    return 'PaymentMethod(id: $id, name: $name, description: $description, isDefault: $isDefault)';
  }
}
