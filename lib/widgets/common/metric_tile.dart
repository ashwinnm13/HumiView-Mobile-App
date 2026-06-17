import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import 'app_card.dart';

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.color = AppColors.primary,
    this.trend,
    this.isCritical = false,
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final double? trend;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isCritical ? AppColors.critical : color;

    return AppCard(
      padding: const EdgeInsets.all(16),
      border: isCritical
          ? Border.all(color: AppColors.critical.withValues(alpha: 0.5), width: 1.5)
          : null,
      shadows: isCritical ? AppShadows.criticalGlow : AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: effectiveColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.metricMedium.copyWith(
                  color: isCritical ? AppColors.critical : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTypography.bodyMedium.copyWith(
                  color: isCritical ? AppColors.critical : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  trend! >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: trend! >= 0 ? AppColors.warning : AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trend!.abs().toStringAsFixed(1)}$unit',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
