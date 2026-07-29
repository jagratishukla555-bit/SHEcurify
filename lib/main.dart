import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

// ── Screens ──────────────────────────────────────────────────────────────────
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/safe_route/safe_route_screen.dart';
import 'screens/sos/sos_screen.dart';
import 'screens/trusted_contacts/trusted_contacts_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/alerts/alerts_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';

// ─── Application entry point ──────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for a mobile-optimised safety app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SHEcurifyApp());
}

// ─── Root widget ──────────────────────────────────────────────────────────────
class SHEcurifyApp extends StatelessWidget {
  const SHEcurifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHEcurify',
      debugShowCheckedModeBanner: false,

      // ── Design system ──────────────────────────────────────────────────
      theme: AppTheme.lightTheme,

      // ── Navigation ─────────────────────────────────────────────────────
      // All routes are registered here using named routes.
      // This means every screen can be reached via:
      //   Navigator.of(context).pushNamed(AppRoutes.xxx)
      //
      // When Spring Boot is integrated, you can add authentication guards
      // here using onGenerateRoute + a session-check before navigation.
      initialRoute: AppRoutes.splash,

      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.map: (_) => const MapScreen(),
        AppRoutes.safeRoute: (_) => const SafeRouteScreen(),
        AppRoutes.sos: (_) => const SosScreen(),
        AppRoutes.trustedContacts: (_) => const TrustedContactsScreen(),
        AppRoutes.reports: (_) => const ReportsScreen(),
        AppRoutes.alerts: (_) => const AlertsScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
