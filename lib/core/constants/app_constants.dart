// ─── App-wide constants ───────────────────────────────────────────────────────
// These values are referenced throughout the app.
// When the Spring Boot backend is ready, base URL and timeouts live here.

class AppConstants {
  AppConstants._();

  // ── App metadata ────────────────────────────────────────────────────────────
  static const String appName = 'SHEcurify';
  static const String appTagline =
      'Navigate Safely. Stay Connected. Get Help When It Matters.';
  static const String appVersion = '1.0.0';

  // ── Future backend base URL (left blank until Sprint 2) ──────────────────
  // Replace with your Spring Boot server address when ready.
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // ── Splash screen ───────────────────────────────────────────────────────────
  static const int splashDurationMs = 2800;

  // ── SOS countdown (seconds before auto-activating if no cancel) ──────────
  static const int sosCountdownSeconds = 5;

  // ── Pagination / limits ─────────────────────────────────────────────────────
  static const int alertsPageSize = 20;
  static const int reportsPageSize = 20;

  // ── Validation ───────────────────────────────────────────────────────────────
  static const int minPasswordLength = 8;
  static const int maxNameLength = 60;
  static const int maxDescriptionLength = 500;
}
