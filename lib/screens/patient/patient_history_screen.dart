import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/responsive/responsive_utils.dart';

import '../../data/models/sensor_reading.dart';
import '../../providers/patient_provider.dart';
import '../../services/sensor_api_service.dart';

import '../../widgets/common/app_card.dart';
import '../../widgets/patient/patient_header.dart';

class PatientHistoryScreen extends StatefulWidget {
  final String patientId;

  const PatientHistoryScreen({super.key, required this.patientId});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  final SensorApiService _apiService = SensorApiService();
  
  List<SensorReading> _allReadings = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    
    try {
      final patientReadings = await _apiService.getPatientHistory(widget.patientId);
      
      // Since backend is ordered by timestamp DESC, let's reverse it or sort chronologically (ASC)
      // because our charts expect older data first and newer data last.
      patientReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      if (mounted) {
        setState(() {
          _allReadings = patientReadings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final patient = patientProvider.getPatientById(widget.patientId);

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(AppIcons.back),
            onPressed: () => context.pop(),
          ),
          title: const Text(AppStrings.patientHistory),
        ),
        body: const Center(child: Text('Patient not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.patientHistory),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text('Error: $_error', style: const TextStyle(color: AppColors.critical)))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenPaddingH,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PatientHeader(patient: patient),
                      const SizedBox(height: 24),
                      if (_allReadings.isEmpty)
                        _buildEmptyState()
                      else ...[
                        _buildAveragesSummary(_allReadings),
                        const SizedBox(height: 16),
                        _buildHeaterSummary(_allReadings),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          AppStrings.noHistoryData,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildAveragesSummary(List<SensorReading> readings) {
    if (readings.isEmpty) return const SizedBox.shrink();
    
    final avgTemp = readings.map((r) => r.temperature).reduce((a, b) => a + b) / readings.length;
    final avgRh = readings.map((r) => r.relativeHumidity).reduce((a, b) => a + b) / readings.length;
    final avgAh = readings.map((r) => r.absoluteHumidity).reduce((a, b) => a + b) / readings.length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Averages', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStat('Temp', '${avgTemp.toStringAsFixed(1)}${AppStrings.celsius}')),
              Expanded(child: _buildStat('Humidity', '${avgRh.toStringAsFixed(1)}${AppStrings.percent}')),
              Expanded(child: _buildStat('Abs. Hum', '${avgAh.toStringAsFixed(1)}${AppStrings.gPerM3}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.headlineSmall.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildHeaterSummary(List<SensorReading> readings) {
    if (readings.isEmpty) return const SizedBox.shrink();
    
    final onCount = readings.where((r) => r.heaterStatus == 1).length;
    final percent = (onCount / readings.length) * 100;
    
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.heaterActivity, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${percent.toStringAsFixed(1)}% Active time', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          Icon(AppIcons.heaterActive, color: percent > 0 ? AppColors.warning : AppColors.textSecondary, size: 32),
        ],
      ),
    );
  }

}
