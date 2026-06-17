import 'package:flutter/material.dart';

/// HumiView Design System — Shadows & Elevation
///
/// Soft, medical-grade shadows for layered card interfaces.
class AppShadows {
  AppShadows._();

  /// Subtle shadow for resting state cards
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Default card shadow
  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  /// Elevated shadow for floating elements
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Modal / dialog shadow
  static List<BoxShadow> get modal => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Primary color glow for active elements
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: const Color(0xFF1565C0).withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Critical alert glow
  static List<BoxShadow> get criticalGlow => [
        BoxShadow(
          color: const Color(0xFFE53935).withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  /// Success glow
  static List<BoxShadow> get successGlow => [
        BoxShadow(
          color: const Color(0xFF22C55E).withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];
}
