// ─── UserModel ────────────────────────────────────────────────────────────────
// Represents the logged-in user.
// Later: populated from Spring Boot /api/auth/me endpoint.

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.createdAt,
  });

  // Convenience getter for first name greeting
  String get firstName => fullName.split(' ').first;

  // Later: fromJson(Map<String, dynamic> json) factory for API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt.toIso8601String(),
      };
}
