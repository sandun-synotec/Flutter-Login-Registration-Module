import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand palette
  static const Color primary = Color(0xFF2563EB); // Vibrant Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primarySubtle = Color(0xFFEFF6FF);

  // Secondary brand palette
  static const Color secondary = Color(0xFF0D9488); // Teal
  static const Color secondaryLight = Color(0xFF2DD4BF);

  // Neutral palette
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9); // Slate 100
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderFocused = Color(0xFF2563EB);

  // Typography colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status & Feedback colors
  static const Color success = Color(0xFF16A34A); // Emerald/Green 600
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF0284C7); // Sky 600
}
