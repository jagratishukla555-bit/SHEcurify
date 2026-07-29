// ─── Named route registry ─────────────────────────────────────────────────────
// All navigation in the app goes through these string constants.
// When you add a new screen, add its route name here first.

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String map = '/map';
  static const String safeRoute = '/safe-route';
  static const String sos = '/sos';
  static const String sosActive = '/sos-active';
  static const String trustedContacts = '/trusted-contacts';
  static const String reports = '/reports';
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
