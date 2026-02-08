import 'dart:convert';

/// User Profile Model - Database ready
class UserProfile {
  final String id;
  final String name;
  final int age;
  final String bloodType;
  final double height; // cm
  final double weight; // kg
  final List<String> allergies;
  final List<String> conditions;
  final String? email;
  final String? phone;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bloodType,
    required this.height,
    required this.weight,
    required this.allergies,
    required this.conditions,
    this.email,
    this.phone,
  });

  /// JSON serialization for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'height': height,
      'weight': weight,
      'allergies': allergies,
      'conditions': conditions,
      'email': email,
      'phone': phone,
    };
  }

  /// JSON deserialization
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      bloodType: json['bloodType'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      allergies: List<String>.from(json['allergies'] ?? []),
      conditions: List<String>.from(json['conditions'] ?? []),
      email: json['email'],
      phone: json['phone'],
    );
  }

  /// Copy with method for updates
  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? bloodType,
    double? height,
    double? weight,
    List<String>? allergies,
    List<String>? conditions,
    String? email,
    String? phone,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
