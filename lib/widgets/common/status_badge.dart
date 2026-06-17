import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/patient.dart';
import 'pulse_indicator.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  final ConnectionStatus status;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    bool isPulsing = false;

    switch (status) {
      case ConnectionStatus.online:
        color = AppColors.success;
        label = 'Online';
        isPulsing = true;
        break;
      case ConnectionStatus.offline:
        color = AppColors.offline;
        label = 'Offline';
        break;
      case ConnectionStatus.connecting:
        color = AppColors.warning;
        label = 'Connecting...';
        isPulsing = true;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 8 : 4,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPulsing)
            PulseIndicator(color: color, size: 8)
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
