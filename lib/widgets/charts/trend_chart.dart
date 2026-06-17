import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_analytics.dart';
import 'package:intl/intl.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    required this.data,
    required this.title,
    required this.gradient,
    required this.minY,
    required this.maxY,
  });

  final List<DailyMetric> data;
  final String title;
  final LinearGradient gradient;
  final double minY;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.avg);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleMedium),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.divider,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value < 0 || value >= data.length) return const SizedBox.shrink();
                      final date = data[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('E').format(date),
                          style: AppTypography.caption,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(0),
                      style: AppTypography.caption,
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: gradient,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradient.colors.map((c) => c.withValues(alpha: 0.1)).toList(),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
