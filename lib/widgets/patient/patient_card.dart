import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_icons.dart';
import '../../data/models/patient.dart';
import '../common/app_card.dart';
import '../common/status_badge.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  final Patient patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      border: patient.status == PatientStatus.critical
          ? Border.all(color: AppColors.critical.withValues(alpha: 0.5), width: 1.5)
          : null,
      shadows: patient.status == PatientStatus.critical
          ? AppShadows.criticalGlow
          : AppShadows.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primarySurface,
                backgroundImage: patient.imageUrl.isNotEmpty ? NetworkImage(patient.imageUrl) : null,
                child: patient.imageUrl.isEmpty ? Text(
                  patient.initials,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
                ) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (patient.age != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cake_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('${patient.age} yrs', style: AppTypography.caption),
                            ],
                          ),
                        if (patient.admissionDate != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('${patient.admissionDate!.day.toString().padLeft(2, '0')}/${patient.admissionDate!.month.toString().padLeft(2, '0')}/${patient.admissionDate!.year}', style: AppTypography.caption),
                            ],
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.room, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              patient.roomNumber,
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.device, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              patient.deviceId,
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(status: patient.connectionStatus, showLabel: false),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildMiniMetric(
                  AppIcons.temperature,
                  patient.latestReading != null ? '${patient.latestReading!.temperature}°C' : '--',
                  patient.status == PatientStatus.critical ? AppColors.critical : (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary),
                ),
              ),
              Expanded(
                child: _buildMiniMetric(
                  AppIcons.humidity,
                  patient.latestReading != null ? '${patient.latestReading!.relativeHumidity}%' : '--',
                  Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                ),
              ),
              Expanded(
                child: _buildMiniMetric(
                  AppIcons.heater,
                  patient.heaterStatus.statusText,
                  patient.heaterStatus.isActive ? AppColors.warning : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: AppTypography.labelMedium.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
