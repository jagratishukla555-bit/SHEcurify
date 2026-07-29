// ─── Mock Data ────────────────────────────────────────────────────────────────
// All mock/placeholder data lives here so it can be easily replaced later
// by actual HTTP responses from the Spring Boot REST API.
//
// HOW TO REPLACE LATER:
//   1. Create a method in lib/services/api_service.dart
//   2. Fetch data from your Spring Boot endpoint
//   3. Replace calls to MockData.xxx with calls to ApiService.xxx

import '../models/user_model.dart';
import '../models/route_model.dart';
import '../models/trusted_contact_model.dart';
import '../models/safety_report_model.dart';
import '../models/safety_alert_model.dart';

class MockData {
  MockData._();

  // ── Current user ─────────────────────────────────────────────────────────────
  static final UserModel currentUser = UserModel(
    id: 'mock-user-001',
    fullName: 'Sarah Johnson',
    email: 'sarah.johnson@email.com',
    phone: '+1 (555) 987-6543',
    createdAt: DateTime(2024, 1, 15),
  );

  // ── Trusted contacts ─────────────────────────────────────────────────────────
  static final List<TrustedContactModel> trustedContacts = [
    const TrustedContactModel(
      id: 'tc-001',
      name: 'Emily Johnson',
      relationship: 'Sister',
      phone: '+1 (555) 123-4567',
      priority: 1,
    ),
    const TrustedContactModel(
      id: 'tc-002',
      name: 'David Johnson',
      relationship: 'Father',
      phone: '+1 (555) 234-5678',
      priority: 2,
    ),
    const TrustedContactModel(
      id: 'tc-003',
      name: 'Maria Sanchez',
      relationship: 'Best Friend',
      phone: '+1 (555) 345-6789',
      priority: 3,
    ),
  ];

  // ── Safe routes ───────────────────────────────────────────────────────────────
  static final List<RouteModel> suggestedRoutes = [
    const RouteModel(
      id: 'route-001',
      label: 'Safest Route',
      safetyLevel: SafetyLevel.low,
      estimatedMinutes: 25,
      distanceKm: 8.2,
      safetyScore: 92,
      isRecommended: true,
      description:
          'Well-lit streets with high foot traffic. Passes near police station and shopping district.',
    ),
    const RouteModel(
      id: 'route-002',
      label: 'Alternative Route',
      safetyLevel: SafetyLevel.moderate,
      estimatedMinutes: 20,
      distanceKm: 6.8,
      safetyScore: 71,
      isRecommended: false,
      description:
          'Moderate lighting. Some sections pass through quieter streets. Recommended during daytime.',
    ),
    const RouteModel(
      id: 'route-003',
      label: 'Fastest Route',
      safetyLevel: SafetyLevel.high,
      estimatedMinutes: 17,
      distanceKm: 5.9,
      safetyScore: 48,
      isRecommended: false,
      description:
          'Shortest path but includes poorly lit areas and isolated stretches. Not recommended at night.',
    ),
  ];

  // ── Safety alerts ─────────────────────────────────────────────────────────────
  static final List<SafetyAlertModel> nearbyAlerts = [
    SafetyAlertModel(
      id: 'alert-001',
      title: 'Poor Lighting Reported',
      location: 'Near Main Road & 5th St',
      description:
          'Multiple street lights are out on this stretch. Exercise caution after dark.',
      severity: AlertSeverity.medium,
      reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
      distanceKm: 0.4,
    ),
    SafetyAlertModel(
      id: 'alert-002',
      title: 'Unsafe Area Warning',
      location: 'Riverside Park – North Section',
      description:
          'Several harassment incidents reported in this area over the past week.',
      severity: AlertSeverity.high,
      reportedAt: DateTime.now().subtract(const Duration(hours: 6)),
      distanceKm: 0.8,
    ),
    SafetyAlertModel(
      id: 'alert-003',
      title: 'Suspicious Activity',
      location: 'Old Industrial Road',
      description: 'Residents reported unfamiliar vehicles in the area.',
      severity: AlertSeverity.low,
      reportedAt: DateTime.now().subtract(const Duration(hours: 14)),
      distanceKm: 1.2,
    ),
    SafetyAlertModel(
      id: 'alert-004',
      title: 'Isolated Zone',
      location: 'Underpass – Central Avenue',
      description:
          'No foot traffic, minimal visibility. Avoid this route when alone.',
      severity: AlertSeverity.high,
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
      distanceKm: 1.9,
    ),
  ];

  // ── Recent community reports ──────────────────────────────────────────────────
  static final List<SafetyReportModel> recentReports = [
    SafetyReportModel(
      id: 'rpt-001',
      category: ReportCategory.poorLighting,
      location: 'Baker Street – Block 3',
      description: 'Three consecutive street lights are not functioning.',
      reportedAt: DateTime.now().subtract(const Duration(hours: 3)),
      isVerified: true,
    ),
    SafetyReportModel(
      id: 'rpt-002',
      category: ReportCategory.harassment,
      location: 'Bus Stop – Central Terminal',
      description: 'Verbal harassment reported at this bus stop during evenings.',
      reportedAt: DateTime.now().subtract(const Duration(hours: 8)),
      isVerified: false,
    ),
    SafetyReportModel(
      id: 'rpt-003',
      category: ReportCategory.unsafeArea,
      location: 'Parkway Lane – Near Flyover',
      description: 'Area feels unsafe due to low visibility and no pedestrians.',
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
      isVerified: true,
    ),
    SafetyReportModel(
      id: 'rpt-004',
      category: ReportCategory.suspiciousActivity,
      location: 'Near City College Gate 2',
      description: 'Unfamiliar individuals loitering around the college gate.',
      reportedAt: DateTime.now().subtract(const Duration(days: 2)),
      isVerified: false,
    ),
  ];

  // ── Location placeholder ──────────────────────────────────────────────────────
  static const String currentLocationLabel = 'MG Road, Bangalore, Karnataka';
}
