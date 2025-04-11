// Removed the Donation class from this file as it has been moved to donation.dart
// Import the Donation class from its new location

class UserEntity {
  final String id;
  final String name;
  final String email;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// Removed the User class from this file as it has been moved to the bloc folder.
