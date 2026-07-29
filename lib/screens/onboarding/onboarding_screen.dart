import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';

// ─── OnboardingScreen ─────────────────────────────────────────────────────────
// Three slides that introduce SHEcurify's key features.
// Each slide has a visual icon, title, description, and a feature badge.

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ── Slide data ───────────────────────────────────────────────────────────────
  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      icon: Icons.directions_walk,
      illustrationColor: Color(0xFF1A5F7A),
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      featureBadge: AppStrings.onboarding1Feature,
      badgeIcon: Icons.route,
    ),
    _OnboardingSlide(
      icon: Icons.crisis_alert,
      illustrationColor: Color(0xFFD32F2F),
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      featureBadge: AppStrings.onboarding2Feature,
      badgeIcon: Icons.emergency,
    ),
    _OnboardingSlide(
      icon: Icons.people_outline,
      illustrationColor: Color(0xFF2E7D32),
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      featureBadge: AppStrings.onboarding3Feature,
      badgeIcon: Icons.flag_outlined,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _getStarted() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──────────────────────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _getStarted,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // ── Slides ───────────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return _OnboardingPage(slide: _slides[index]);
                },
              ),
            ),

            // ── Page indicators ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.primary
                        : AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Action buttons ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Single onboarding page ───────────────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final _OnboardingSlide slide;
  const _OnboardingPage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: slide.illustrationColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: slide.illustrationColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Icon(
              slide.icon,
              size: 80,
              color: slide.illustrationColor,
            ),
          ),
          const SizedBox(height: 40),

          // Feature badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: slide.illustrationColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: slide.illustrationColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(slide.badgeIcon,
                    size: 14, color: slide.illustrationColor),
                const SizedBox(width: 6),
                Text(
                  slide.featureBadge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: slide.illustrationColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Slide data model ─────────────────────────────────────────────────────────
class _OnboardingSlide {
  final IconData icon;
  final Color illustrationColor;
  final String title;
  final String description;
  final String featureBadge;
  final IconData badgeIcon;

  const _OnboardingSlide({
    required this.icon,
    required this.illustrationColor,
    required this.title,
    required this.description,
    required this.featureBadge,
    required this.badgeIcon,
  });
}
