import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../providers/monitoring_provider.dart';
import '../../widgets/patient/patient_header.dart';
import '../../widgets/patient/patient_metrics.dart';
import '../../widgets/charts/live_line_chart.dart';
import '../../widgets/common/app_card.dart';

class LiveMonitoringScreen extends StatefulWidget {
  const LiveMonitoringScreen({super.key, required this.patientId});

  final String patientId;

  @override
  State<LiveMonitoringScreen> createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MonitoringProvider>().startMonitoring(widget.patientId);
    });
  }

  @override
  void dispose() {
    // Note: Don't stop monitoring here if we want background monitoring,
    // but for demo purposes, we can let the provider handle cleanup.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.liveMonitoring),
        actions: [
          Consumer<MonitoringProvider>(
            builder: (context, provider, _) {
              final isPaused = provider.isPaused;
              return IconButton(
                icon: Icon(isPaused ? AppIcons.play : AppIcons.pause),
                onPressed: provider.togglePause,
                tooltip: isPaused ? AppStrings.resume : AppStrings.pause,
              );
            },
          ),
          IconButton(
            icon: const Icon(AppIcons.heater),
            onPressed: () => context.push('/heater/${widget.patientId}'),
            tooltip: AppStrings.heaterControl,
          ),
        ],
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, _) {
          final patient = provider.currentPatient;
          
          if (patient == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ResponsiveLayout(
            mobile: (context, _) => _buildMobileLayout(context, provider),
            tablet: (context, _) => _buildTabletLayout(context, provider),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, MonitoringProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PatientHeader(patient: provider.currentPatient!),
          const SizedBox(height: 24),
          PatientMetrics(patient: provider.currentPatient!),
          const SizedBox(height: 24),
          _buildChartsSection(provider),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, MonitoringProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PatientHeader(patient: provider.currentPatient!),
                const SizedBox(height: 24),
                PatientMetrics(patient: provider.currentPatient!),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.divider),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.screenPaddingH),
            child: _buildChartsSection(provider),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(MonitoringProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.liveMonitoring, style: AppTypography.headlineSmall),
            _buildTimeRangeSelector(provider),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: AppCard(
            margin: EdgeInsets.zero,
            child: LiveLineChart(
              title: AppStrings.temperatureTrend,
              data: provider.liveData,
              unit: AppStrings.celsius,
              gradient: AppColors.temperatureGradient,
              minY: 34.0,
              maxY: 42.0,
              valueMapper: (r) => r.temperature,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: AppCard(
            margin: EdgeInsets.zero,
            child: LiveLineChart(
              title: AppStrings.rhTrend,
              data: provider.liveData,
              unit: AppStrings.percent,
              gradient: AppColors.humidityGradient,
              minY: 20.0,
              maxY: 100.0,
              valueMapper: (r) => r.relativeHumidity,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: AppCard(
            margin: EdgeInsets.zero,
            child: LiveLineChart(
              title: AppStrings.ahTrend,
              data: provider.liveData,
              unit: ' g/m³',
              gradient: AppColors.primaryGradient,
              minY: 0.0,
              maxY: 50.0,
              valueMapper: (r) => r.absoluteHumidity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector(MonitoringProvider provider) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 60, label: Text('1H')),
        ButtonSegment(value: 360, label: Text('6H')),
        ButtonSegment(value: 1440, label: Text('24H')),
      ],
      selected: {provider.timeRangeMinutes},
      onSelectionChanged: (set) => provider.setTimeRange(set.first),
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        textStyle: AppTypography.labelMedium,
      ),
    );
  }
}
