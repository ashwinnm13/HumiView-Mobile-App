import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../data/mock/mock_analytics.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/charts/trend_chart.dart';
import '../../widgets/charts/bar_chart_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _timeRange = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.analytics),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(AppIcons.export_, size: 20),
            label: const Text(AppStrings.export),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: context.screenPaddingH,
          right: context.screenPaddingH,
          bottom: 80,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimeRangeSelector(),
            const SizedBox(height: 24),
            _buildSummaryCards(context),
            const SizedBox(height: 24),
            ResponsiveLayout(
              mobile: (context, _) => Column(
                children: [
                  _buildTemperatureTrend(),
                  const SizedBox(height: 24),
                  _buildHumidityTrend(),
                  const SizedBox(height: 24),
                  _buildAbsoluteHumidityTrend(),
                  const SizedBox(height: 24),
                  _buildConnectionStability(),
                ],
              ),
              tablet: (context, _) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTemperatureTrend()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildHumidityTrend()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildAbsoluteHumidityTrend()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildConnectionStability()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildHeaterRuntime()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Daily', label: Text('Daily')),
        ButtonSegment(value: 'Weekly', label: Text('Weekly')),
        ButtonSegment(value: 'Monthly', label: Text('Monthly')),
      ],
      selected: {_timeRange},
      onSelectionChanged: (set) => setState(() => _timeRange = set.first),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final stats = MockAnalytics.systemStats;
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = context.isMobile ? 2 : 4;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard('Total Patients', stats.totalPatients.toString(), AppIcons.patients),
            _buildStatCard('Online Devices', stats.onlineDevices.toString(), AppIcons.online),
            _buildStatCard('Active Alerts', stats.activeAlerts.toString(), AppIcons.warningIcon),
            _buildStatCard('Avg Uptime', '${stats.avgUptime}%', AppIcons.timeline),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTypography.headlineMedium),
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureTrend() {
    return SizedBox(
      height: 300,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: TrendChart(
          title: 'Avg Temperature Trend',
          data: MockAnalytics.weeklyTemperature(),
          gradient: AppColors.temperatureGradient,
          minY: 34.0,
          maxY: 42.0,
        ),
      ),
    );
  }

  Widget _buildHumidityTrend() {
    return SizedBox(
      height: 300,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: TrendChart(
          title: 'Avg Relative Humidity Trend',
          data: MockAnalytics.weeklyHumidity(),
          gradient: AppColors.humidityGradient,
          minY: 30.0,
          maxY: 100.0,
        ),
      ),
    );
  }

  Widget _buildAbsoluteHumidityTrend() {
    return SizedBox(
      height: 300,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: TrendChart(
          title: 'Avg Absolute Humidity Trend',
          data: MockAnalytics.weeklyAbsoluteHumidity(),
          gradient: AppColors.primaryGradient,
          minY: 0.0,
          maxY: 50.0,
        ),
      ),
    );
  }

  Widget _buildConnectionStability() {
    return SizedBox(
      height: 300,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: BarChartWidget(
          title: AppStrings.connectionStability,
          data: MockAnalytics.connectionStability(),
          color: AppColors.success,
          maxY: 100.0,
          valueFormatter: (v) => '${v.toStringAsFixed(1)}%',
        ),
      ),
    );
  }

  Widget _buildHeaterRuntime() {
    return SizedBox(
      height: 300,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: BarChartWidget(
          title: AppStrings.heaterRuntime,
          data: MockAnalytics.heaterRuntime(),
          color: AppColors.warning,
          maxY: 60.0,
          valueFormatter: (v) => '${v.toStringAsFixed(0)}m',
        ),
      ),
    );
  }
}
