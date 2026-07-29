// ─── TrustedContactModel ──────────────────────────────────────────────────────
// Represents a trusted emergency contact.
// Later: saved via Spring Boot /api/contacts endpoint.

class TrustedContactModel {
  final String id;
  final String name;
  final String relationship;
  final String phone;
  final int priority;          // 1 = highest priority
  final String? avatarInitials;

  const TrustedContactModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    required this.priority,
    this.avatarInitials,
  });

  String get initials {
    if (avatarInitials != null) return avatarInitials!;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory TrustedContactModel.fromJson(Map<String, dynamic> json) {
    return TrustedContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
      priority: json['priority'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'relationship': relationship,
        'phone': phone,
        'priority': priority,
      };

  TrustedContactModel copyWith({
    String? name,
    String? relationship,
    String? phone,
    int? priority,
  }) {
    return TrustedContactModel(
      id: id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      priority: priority ?? this.priority,
    );
  }
}
