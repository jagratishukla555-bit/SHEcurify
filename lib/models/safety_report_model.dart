// ─── SafetyReportModel ────────────────────────────────────────────────────────
// Represents a community-submitted safety report.
// Later: submitted to Spring Boot /api/reports endpoint.

enum ReportCategory {
  unsafeArea,
  poorLighting,
  harassment,
  suspiciousActivity,
  isolatedArea,
  other,
}

extension ReportCategoryLabel on ReportCategory {
  String get label {
    switch (this) {
      case ReportCategory.unsafeArea:
        return 'Unsafe Area';
      case ReportCategory.poorLighting:
        return 'Poor Street Lighting';
      case ReportCategory.harassment:
        return 'Harassment';
      case ReportCategory.suspiciousActivity:
        return 'Suspicious Activity';
      case ReportCategory.isolatedArea:
        return 'Isolated Area';
      case ReportCategory.other:
        return 'Other Safety Concern';
    }
  }

  String get icon {
    switch (this) {
      case ReportCategory.unsafeArea:
        return '⚠️';
      case ReportCategory.poorLighting:
        return '💡';
      case ReportCategory.harassment:
        return '🚨';
      case ReportCategory.suspiciousActivity:
        return '👁️';
      case ReportCategory.isolatedArea:
        return '🏚️';
      case ReportCategory.other:
        return '📋';
    }
  }
}

class SafetyReportModel {
  final String id;
  final ReportCategory category;
  final String location;
  final String description;
  final DateTime reportedAt;
  final bool isVerified;

  const SafetyReportModel({
    required this.id,
    required this.category,
    required this.location,
    required this.description,
    required this.reportedAt,
    required this.isVerified,
  });

  factory SafetyReportModel.fromJson(Map<String, dynamic> json) {
    return SafetyReportModel(
      id: json['id'] as String,
      category: ReportCategory.values.byName(json['category'] as String),
      location: json['location'] as String,
      description: json['description'] as String,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      isVerified: json['isVerified'] as bool,
    );
  }
}
