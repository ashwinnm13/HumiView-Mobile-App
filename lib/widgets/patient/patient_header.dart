import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_icons.dart';
import '../../data/models/patient.dart';
import '../common/status_badge.dart';

class PatientHeader extends StatelessWidget {
  const PatientHeader({
    super.key,
    required this.patient,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primarySurface,
          child: Text(
            patient.initials,
            style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(AppIcons.room, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    patient.roomNumber,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  Icon(AppIcons.device, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      patient.deviceId,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        StatusBadge(status: patient.connectionStatus),
      ],
    );
  }
}
