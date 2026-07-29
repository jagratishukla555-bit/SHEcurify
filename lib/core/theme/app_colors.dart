import 'package:flutter/material.dart';

// ─── SHEcurify Design System – Colours ───────────────────────────────────────
//
// Philosophy: calm, trustworthy, modern. Deep teal-blue as the primary
// conveys security. Soft rose/coral accent adds a subtle feminine touch without
// being decorative. Neutral greys keep the interface clean and readable.

class AppColors {
  AppColors._();

  // ── Primary (deep teal-blue – trust, security, technology) ──────────────────
  static const Color primary = Color(0xFF1A5F7A);        // deep teal
  static const Color primaryLight = Color(0xFF2E86AB);   // medium teal
  static const Color primaryDark = Color(0xFF0D3D52);    // very dark teal

  // ── Accent (soft rose – feminine, alert, action) ─────────────────────────────
  static const Color accent = Color(0xFFE84393);         // vibrant rose
  static const Color accentLight = Color(0xFFFF6FB8);    // lighter rose
  static const Color accentDark = Color(0xFFBD1D6C);     // deep rose

  // ── SOS (strong red – emergency, urgency) ────────────────────────────────────
  static const Color sos = Color(0xFFD32F2F);
  static const Color sosLight = Color(0xFFFF6659);
  static const Color sosDark = Color(0xFF9A0007);

  // ── Safety levels ────────────────────────────────────────────────────────────
  static const Color safeGreen = Color(0xFF2E7D32);
  static const Color moderateOrange = Color(0xFFF57C00);
  static const Color highRiskRed = Color(0xFFC62828);
  static const Color safeGreenLight = Color(0xFFE8F5E9);
  static const Color moderateOrangeLight = Color(0xFFFFF3E0);
  static const Color highRiskRedLight = Color(0xFFFFEBEE);

  // ── Neutrals ─────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4F8);
  static const Color divider = Color(0xFFE2E8F0);

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);
  static const Color textInverse = Color(0xFFFFFFFF);

  // ── Status ───────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ── Gradient (used on Splash, SOS button) ────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sosGradient = LinearGradient(
    colors: [sosDark, sos],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
