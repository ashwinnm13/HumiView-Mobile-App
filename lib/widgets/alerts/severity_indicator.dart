import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/alert.dart';

class SeverityIndicator extends StatelessWidget {
  const SeverityIndicator({
    super.key,
    required this.severity,
    this.size = 12,
  });

  final AlertSeverity severity;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (severity) {
      case AlertSeverity.critical:
        color = AppColors.critical;
        break;
      case AlertSeverity.warning:
        color = AppColors.warning;
        break;
      case AlertSeverity.info:
        color = AppColors.primary;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
