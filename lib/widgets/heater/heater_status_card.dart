import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/heater_status.dart';
import '../common/app_card.dart';
import 'heater_animation.dart';

class HeaterStatusCard extends StatelessWidget {
  const HeaterStatusCard({
    super.key,
    required this.status,
    this.onModeChanged,
  });

  final HeaterStatus status;
  final ValueChanged<HeaterMode>? onModeChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.heaterControl,
                style: AppTypography.titleLarge,
              ),
              if (onModeChanged != null)
                SegmentedButton<HeaterMode>(
                  segments: const [
                    ButtonSegment(
                      value: HeaterMode.auto,
                      label: Text(AppStrings.autoMode),
                    ),
                    ButtonSegment(
                      value: HeaterMode.manual,
                      label: Text(AppStrings.manualMode),
                    ),
                  ],
                  selected: {status.mode},
                  onSelectionChanged: (set) => onModeChanged!(set.first),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: HeaterAnimation(
              isActive: status.isActive,
              size: 160,
            ),
          ),
          const SizedBox(height: 32),
          _buildInfoRow(
            'Status',
            status.statusText,
            status.isActive ? AppColors.warning : AppColors.textPrimary,
            bold: true,
          ),
          const Divider(height: 32),
          _buildInfoRow('Cycle', AppStrings.cycleInfo, AppColors.textSecondary),
          const SizedBox(height: 12),
          if (status.timeToNextCycle != null)
            _buildInfoRow(
              AppStrings.nextCycle,
              'in ${status.timeToNextCycle!.inMinutes}m ${status.timeToNextCycle!.inSeconds % 60}s',
              AppColors.primary,
              bold: true,
            ),
          const SizedBox(height: 12),
          _buildInfoRow(
            AppStrings.runtime,
            '${status.totalRuntime.inMinutes}m ${status.totalRuntime.inSeconds % 60}s today',
            AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: color,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
