import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_icons.dart';

class HeaterAnimation extends StatelessWidget {
  const HeaterAnimation({
    super.key,
    required this.isActive,
    this.size = 120,
  });

  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? AppColors.heaterActiveGradient
                : AppColors.heaterIdleGradient,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.warning.withValues(alpha: 0.4),
                      blurRadius: 32,
                      spreadRadius: 8,
                    )
                  ]
                : [],
          ),
        )
            .animate(target: isActive ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds, curve: Curves.easeInOutSine)
            .then()
            .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 1.seconds, curve: Curves.easeInOutSine),

        // Inner circle
        Container(
          width: size * 0.7,
          height: size * 0.7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
          ),
          child: Center(
            child: Icon(
              isActive ? AppIcons.heaterActive : AppIcons.heater,
              size: size * 0.35,
              color: isActive ? AppColors.warning : AppColors.textTertiary,
            )
                .animate(target: isActive ? 1 : 0)
                .shake(duration: 500.ms, hz: 4),
          ),
        ),
      ],
    );
  }
}
