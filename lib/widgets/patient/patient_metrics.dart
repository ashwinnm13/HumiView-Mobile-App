import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/patient.dart';
import '../common/metric_tile.dart';

class PatientMetrics extends StatelessWidget {
  const PatientMetrics({
    super.key,
    required this.patient,
  });

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final reading = patient.latestReading;

    if (reading == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('No data available')),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        final tempTile = MetricTile(
          title: AppStrings.temperature,
          value: reading.temperature.toStringAsFixed(1),
          unit: AppStrings.celsius,
          icon: AppIcons.temperature,
          color: AppColors.primary,
          isCritical: reading.temperature > 39.0 || reading.temperature < 35.0,
        );

        final rhTile = MetricTile(
          title: AppStrings.relativeHumidity,
          value: reading.relativeHumidity.toStringAsFixed(1),
          unit: AppStrings.percent,
          icon: AppIcons.humidity,
          color: AppColors.accent,
          isCritical: reading.relativeHumidity > 85.0 || reading.relativeHumidity < 30.0,
        );

        final ahTile = MetricTile(
          title: AppStrings.absoluteHumidity,
          value: reading.absoluteHumidity.toStringAsFixed(1),
          unit: AppStrings.gPerM3,
          icon: AppIcons.humidityAbsolute,
          color: AppColors.secondary,
        );

        if (isTablet) {
          return GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [tempTile, rhTile, ahTile],
          );
        }

        const double spacing = 16.0;
        final double cardWidth = (constraints.maxWidth - spacing) / 2;
        final double cardHeight = cardWidth / 1.2;

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: SizedBox(height: cardHeight, child: tempTile)),
                const SizedBox(width: spacing),
                Expanded(child: SizedBox(height: cardHeight, child: rhTile)),
              ],
            ),
            const SizedBox(height: spacing),
            SizedBox(
              width: double.infinity,
              height: cardHeight,
              child: ahTile,
            ),
          ],
        );
      },
    );
  }
}
