import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';

// ─── SplashScreen ─────────────────────────────────────────────────────────────
// Shown on first launch while the app initialises.
// After [AppConstants.splashDurationMs] ms it navigates to Onboarding.
//
// FUTURE INTEGRATION:
//   Replace the Future.delayed with a real initialisation:
//     1. Check SharedPreferences for existing JWT token
//     2. If token exists → validate with Spring Boot /api/auth/validate
//     3. If valid → navigate to /home
//     4. If not → navigate to /onboarding or /login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // Make status bar transparent over the gradient
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Navigate away after the splash duration
    Future.delayed(
      const Duration(milliseconds: AppConstants.splashDurationMs),
      () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF1A7A9A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo ───────────────────────────────────────────────────────
              FadeTransition(
                opacity: _fadeIn,
                child: AnimatedBuilder(
                  animation: _logoScale,
                  builder: (context, child) => Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                  child: Column(
                    children: [
                      // Shield icon as logo placeholder
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // App name
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'SHE',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            TextSpan(
                              text: 'curify',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Tagline ────────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _slideUp,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _slideUp.value),
                  child: child,
                ),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      AppConstants.appTagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.6,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ── Loading indicator ──────────────────────────────────────────
              FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Initialising…',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
