import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/alert.dart';
import '../common/app_card.dart';
import 'severity_indicator.dart';

class AlertTile extends StatelessWidget {
  const AlertTile({
    super.key,
    required this.alert,
    this.onAcknowledge,
    this.onDismiss,
  });

  final Alert alert;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final isUnread = !alert.isRead;
    final isActionable = alert.status == AlertStatus.open;

    return AppCard(
      padding: EdgeInsets.zero,
      color: isUnread ? AppColors.surface : AppColors.surfaceVariant.withValues(alpha: 0.5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Severity Color Bar
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: _getSeverityColor(alert.severity),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SeverityIndicator(severity: alert.severity),
                            const SizedBox(width: 8),
                            Text(
                              alert.patientName,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                              ),
                            ),
                            if (alert.roomNumber != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                alert.roomNumber!,
                                style: AppTypography.caption,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          Formatters.timeAgo(alert.timestamp),
                          style: AppTypography.caption.copyWith(
                            color: isUnread ? AppColors.primary : AppColors.textTertiary,
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    if (isActionable) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: onAcknowledge,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Acknowledge'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: onDismiss,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return AppColors.critical;
      case AlertSeverity.warning:
        return AppColors.warning;
      case AlertSeverity.info:
        return AppColors.primary;
    }
  }
}
