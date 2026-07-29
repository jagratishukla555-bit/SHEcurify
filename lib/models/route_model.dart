// ─── RouteModel ───────────────────────────────────────────────────────────────
// Represents a suggested safe route.
// Later: populated from Spring Boot /api/routes/suggest endpoint.

enum SafetyLevel { low, moderate, high }

extension SafetyLevelLabel on SafetyLevel {
  String get label {
    switch (this) {
      case SafetyLevel.low:
        return 'Low Risk';
      case SafetyLevel.moderate:
        return 'Moderate Risk';
      case SafetyLevel.high:
        return 'Higher Risk';
    }
  }
}

class RouteModel {
  final String id;
  final String label;          // e.g. "Safest Route"
  final SafetyLevel safetyLevel;
  final int estimatedMinutes;
  final double distanceKm;
  final int safetyScore;       // 0–100 (calculated by backend later)
  final bool isRecommended;
  final String description;

  const RouteModel({
    required this.id,
    required this.label,
    required this.safetyLevel,
    required this.estimatedMinutes,
    required this.distanceKm,
    required this.safetyScore,
    required this.isRecommended,
    required this.description,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      label: json['label'] as String,
      safetyLevel: SafetyLevel.values.byName(json['safetyLevel'] as String),
      estimatedMinutes: json['estimatedMinutes'] as int,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      safetyScore: json['safetyScore'] as int,
      isRecommended: json['isRecommended'] as bool,
      description: json['description'] as String,
    );
  }
}
