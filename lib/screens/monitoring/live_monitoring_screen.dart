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
import '../../widgets/common/pulsing_status_indicator.dart';
import '../../providers/alert_provider.dart';
import '../../data/models/alert.dart';
import '../../data/models/patient.dart';
import 'package:intl/intl.dart';

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
            icon: const Icon(AppIcons.history),
            onPressed: () => context.push('/history/${widget.patientId}'),
            tooltip: AppStrings.patientHistory,
          ),
          IconButton(
            icon: const Icon(AppIcons.heater),
            onPressed: () => context.push('/heater/${widget.patientId}'),
            tooltip: AppStrings.heaterControl,
          ),
        ],
      ),
      body: Selector<MonitoringProvider, bool>(
        selector: (context, provider) => provider.currentPatient == null,
        builder: (context, isNull, _) {
          if (isNull) {
            return const Center(child: CircularProgressIndicator());
          }

          return ResponsiveLayout(
            mobile: (context, _) => _buildMobileLayout(context),
            tablet: (context, _) => _buildTabletLayout(context),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Selector<MonitoringProvider, Patient?>(
            selector: (context, provider) => provider.currentPatient,
            shouldRebuild: (prev, next) => prev?.id != next?.id,
            builder: (context, patient, _) => patient != null ? PatientHeader(patient: patient) : const SizedBox(),
          ),
          const SizedBox(height: 24),
          Consumer<MonitoringProvider>(
            builder: (context, provider, _) => provider.currentPatient != null 
                ? PatientMetrics(patient: provider.currentPatient!) 
                : const SizedBox(),
          ),
          const SizedBox(height: 16),
          Consumer<MonitoringProvider>(
            builder: (context, provider, _) => _buildHeaterStatusCard(provider),
          ),
          const SizedBox(height: 24),
          Consumer<MonitoringProvider>(
            builder: (context, provider, _) => _buildChartsSection(provider),
          ),
          const SizedBox(height: 24),
          _buildActiveAlertsSection(context, widget.patientId),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
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
                Selector<MonitoringProvider, Patient?>(
                  selector: (context, provider) => provider.currentPatient,
                  shouldRebuild: (prev, next) => prev?.id != next?.id,
                  builder: (context, patient, _) => patient != null ? PatientHeader(patient: patient) : const SizedBox(),
                ),
                const SizedBox(height: 24),
                Consumer<MonitoringProvider>(
                  builder: (context, provider, _) => provider.currentPatient != null 
                      ? PatientMetrics(patient: provider.currentPatient!) 
                      : const SizedBox(),
                ),
                const SizedBox(height: 16),
                Consumer<MonitoringProvider>(
                  builder: (context, provider, _) => _buildHeaterStatusCard(provider),
                ),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.divider),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<MonitoringProvider>(
                  builder: (context, provider, _) => _buildChartsSection(provider),
                ),
                const SizedBox(height: 24),
                _buildActiveAlertsSection(context, widget.patientId),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(MonitoringProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 12,
          children: [
            Text(AppStrings.liveMonitoring, style: AppTypography.headlineSmall),
            _buildTimeRangeSelector(provider),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: AppCard(
            margin: EdgeInsets.zero,
            child: LiveLineChart(
              title: AppStrings.temperatureTrend,
              data: provider.liveData,
              unit: AppStrings.celsius,
              color: AppColors.critical,
              minY: 20.0,
              maxY: 50.0,
              valueMapper: (r) => r.temperature,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: AppCard(
            margin: EdgeInsets.zero,
            child: LiveLineChart(
              title: AppStrings.rhTrend,
              data: provider.liveData,
              unit: AppStrings.percent,
              color: AppColors.primary,
              minY: 20.0,
              maxY: 100.0,
              valueMapper: (r) => r.relativeHumidity,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: AppCard(
            margin: EdgeInsets.zero,
            child: LiveLineChart(
              title: AppStrings.ahTrend,
              data: provider.liveData,
              unit: ' g/m³',
              color: AppColors.accent,
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

  Widget _buildHeaterStatusCard(MonitoringProvider provider) {
    final reading = provider.currentPatient?.latestReading;
    if (reading == null) return const SizedBox.shrink();

    final isOn = reading.heaterStatus == 1;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          PulsingStatusIndicator(
            isActive: isOn,
            activeColor: AppColors.success,
            inactiveColor: AppColors.textTertiary,
            size: 16.0,
          ),
          const SizedBox(width: 8),
          Text(
            isOn ? 'Heater ON' : 'Heater OFF',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isOn ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlertsSection(BuildContext context, String patientId) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, _) {
        final patientAlerts = alertProvider.alerts
            .where((a) => a.patientId == patientId && a.status == AlertStatus.open)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Active Alerts', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            if (alertProvider.hasError && patientAlerts.isEmpty)
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.wifi_off, size: 48, color: AppColors.offline),
                      const SizedBox(height: 16),
                      Text('Connection Error', style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      Text(alertProvider.errorMessage ?? 'Unable to reach backend.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
            else if (patientAlerts.isEmpty)
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
                      const SizedBox(height: 16),
                      Text('No active alerts', style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      Text('Patient is in stable condition.', style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              )
            else
              ...patientAlerts.map((alert) => _buildAlertCard(context, alertProvider, alert)),
          ],
        );
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, AlertProvider provider, Alert alert) {
    IconData icon;
    Color color;

    switch (alert.severity) {
      case AlertSeverity.critical:
        icon = Icons.error_outline;
        color = AppColors.critical;
        break;
      case AlertSeverity.warning:
        icon = Icons.warning_amber_rounded;
        color = AppColors.warning;
        break;
      case AlertSeverity.info:
      default:
        icon = Icons.info_outline;
        color = AppColors.primary;
        break;
    }

    final timeStr = DateFormat('hh:mm a').format(alert.timestamp);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(alert.message, style: AppTypography.titleMedium),
        subtitle: Text('Reported at $timeStr', style: AppTypography.bodySmall),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          color: AppColors.success,
          tooltip: 'Acknowledge',
          onPressed: () => provider.acknowledgeAlert(alert.id),
        ),
      ),
    );
  }
}
