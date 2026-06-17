import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/logo_circle.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
              const SizedBox(height: 32),
              Text(
                AppStrings.appName,
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.surface,
                  letterSpacing: 2,
                ),
              ).animate().slideY(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOutQuart).fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                AppStrings.tagline,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.surface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    const LinearProgressIndicator(
                      color: AppColors.accent,
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.splashLoading,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.surface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 800.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
