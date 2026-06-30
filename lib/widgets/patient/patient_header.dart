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
          backgroundImage: patient.imageUrl.isNotEmpty ? NetworkImage(patient.imageUrl) : null,
          child: patient.imageUrl.isEmpty ? Text(
            patient.initials,
            style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
          ) : null,
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 4,
                children: [
                  if (patient.age != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cake_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${patient.age} yrs', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  if (patient.admissionDate != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${patient.admissionDate!.day.toString().padLeft(2, '0')}/${patient.admissionDate!.month.toString().padLeft(2, '0')}/${patient.admissionDate!.year}', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(AppIcons.room, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        patient.roomNumber,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(AppIcons.device, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        patient.deviceId,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
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
