// All user-facing strings in one place.
// This makes it easy to localise or update copy later.

class AppStrings {
  AppStrings._();

  // ── Onboarding ───────────────────────────────────────────────────────────────
  static const String onboarding1Title = 'Travel with Confidence';
  static const String onboarding1Desc =
      'Discover safer travel routes using safety information and community reports.';
  static const String onboarding1Feature = 'Safe Route – Prevention';

  static const String onboarding2Title = 'Help When You Need It';
  static const String onboarding2Desc =
      'Trigger an emergency alert and share your location with people you trust.';
  static const String onboarding2Feature = 'SOS Rescue – Emergency Response';

  static const String onboarding3Title = 'Safety Powered by Community';
  static const String onboarding3Desc =
      'Help improve safety by reporting unsafe areas, poor lighting, and other safety concerns.';
  static const String onboarding3Feature = 'Community Safety Reports';

  // ── Auth ─────────────────────────────────────────────────────────────────────
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to continue';
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Join the SHEcurify community';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String termsAccept =
      'I agree to the Terms of Service and Privacy Policy';

  // ── Home ─────────────────────────────────────────────────────────────────────
  static const String findSafeRoute = 'Find Safe Route';
  static const String sosButtonLabel = 'SOS';
  static const String needHelp = 'Need immediate help?';
  static const String enterDestination = 'Enter destination';
  static const String currentLocation = 'Current Location';
  static const String nearbyAlerts = 'Nearby Safety Alerts';
  static const String trustedContacts = 'Trusted Contacts';
  static const String recentReports = 'Recent Reports';

  // ── SOS ──────────────────────────────────────────────────────────────────────
  static const String sosConfirmTitle = 'Activate SOS Alert?';
  static const String sosConfirmBody =
      'This will share your live location with your trusted contacts and nearby verified volunteers.';
  static const String sosActivate = 'Activate SOS';
  static const String sosCancel = 'Cancel';
  static const String sosActiveTitle = 'SOS Active';
  static const String sosActiveSubtitle = 'Emergency assistance activated';
  static const String sosResolve = 'Resolve Emergency';
  static const String sosLocationSharing = 'Location sharing active';
  static const String sosContactsNotified = 'Trusted contacts notified';

  // ── Safe Route ───────────────────────────────────────────────────────────────
  static const String safestRoute = 'Safest Route';
  static const String alternativeRoute = 'Alternative Route';
  static const String fastestRoute = 'Fastest Route';

  // ── Report ───────────────────────────────────────────────────────────────────
  static const String submitReport = 'Submit Report';
  static const String reportSuccess = 'Report submitted successfully';
  static const String reportSuccessBody =
      'Thank you for helping keep the community safe.';
}
