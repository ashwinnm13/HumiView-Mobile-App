import 'package:flutter/material.dart';

/// HumiView Design System — Color Palette
///
/// Medical-grade color tokens optimized for clinical environments.
/// High contrast ratios ensure readability in varied lighting conditions.
class AppColors {
  AppColors._();

  // ─── Primary Brand ───
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primarySurface = Color(0xFFE3F2FD);

  // ─── Secondary / Teal ───
  static const Color secondary = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color secondaryDark = Color(0xFF00695C);
  static const Color secondarySurface = Color(0xFFE0F2F1);

  // ─── Accent ───
  static const Color accent = Color(0xFF14B8A6);
  static const Color accentLight = Color(0xFF5EEAD4);

  // ─── Backgrounds ───
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // ─── Semantic Status ───
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF15803D);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFB45309);

  static const Color critical = Color(0xFFE53935);
  static const Color criticalLight = Color(0xFFFEE2E2);
  static const Color criticalDark = Color(0xFFB71C1C);

  static const Color offline = Color(0xFF94A3B8);
  static const Color offlineLight = Color(0xFFF1F5F9);

  // ─── Text ───
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF8FAFC);

  // ─── Borders & Dividers ───
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E1);
  static const Color borderLight = Color(0xFFF1F5F9);

  // ─── Opacity Variants ───
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color criticalWithOpacity(double opacity) =>
      critical.withValues(alpha: opacity);
  static Color successWithOpacity(double opacity) =>
      success.withValues(alpha: opacity);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF1E88E5)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  static const LinearGradient heaterActiveGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF8A65), Color(0xFFE53935)],
  );

  static const LinearGradient heaterIdleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF90CAF9), Color(0xFF42A5F5)],
  );

  static const LinearGradient temperatureGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFFE53935)],
  );

  static const LinearGradient humidityGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF1565C0)],
  );
}
