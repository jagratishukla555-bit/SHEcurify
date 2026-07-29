// ─── SafetyAlertModel ─────────────────────────────────────────────────────────
// Represents a safety alert displayed to the user.
// Later: fetched from Spring Boot /api/alerts/nearby endpoint.

enum AlertSeverity { low, medium, high }

extension AlertSeverityLabel on AlertSeverity {
  String get label {
    switch (this) {
      case AlertSeverity.low:
        return 'Low';
      case AlertSeverity.medium:
        return 'Medium';
      case AlertSeverity.high:
        return 'High';
    }
  }
}

class SafetyAlertModel {
  final String id;
  final String title;
  final String location;
  final String description;
  final AlertSeverity severity;
  final DateTime reportedAt;
  final double? distanceKm;

  const SafetyAlertModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.severity,
    required this.reportedAt,
    this.distanceKm,
  });

  factory SafetyAlertModel.fromJson(Map<String, dynamic> json) {
    return SafetyAlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      severity: AlertSeverity.values.byName(json['severity'] as String),
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }
}
