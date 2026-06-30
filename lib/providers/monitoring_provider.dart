import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/patient.dart';
import '../data/models/sensor_reading.dart';
import '../data/models/heater_status.dart';
import '../data/mock/mock_readings.dart';
import 'patient_provider.dart';
import '../services/sensor_api_service.dart';

class MonitoringProvider extends ChangeNotifier {
  final PatientProvider _patientProvider;
  final SensorApiService _sensorApiService = SensorApiService();
  
  Patient? _currentPatient;
  List<SensorReading> _liveData = [];
  Timer? _timer;
  bool _isPaused = false;
  
  // Chart time range (1h, 6h, 24h) in minutes
  int _timeRangeMinutes = 60;

  MonitoringProvider(this._patientProvider);

  Patient? get currentPatient => _currentPatient;
  List<SensorReading> get liveData => _liveData;
  bool get isPaused => _isPaused;
  int get timeRangeMinutes => _timeRangeMinutes;

  void startMonitoring(String patientId) async {
    // Clean up previous monitoring session
    stopMonitoring();

    _currentPatient = _patientProvider.getPatientById(patientId);
    if (_currentPatient == null) return;

    // Fetch real historical data from backend
    try {
      final patientReadings = await _sensorApiService.getPatientHistory(patientId);
      patientReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      if (patientReadings.isNotEmpty) {
        _liveData = patientReadings.length > 100 
            ? patientReadings.sublist(patientReadings.length - 100) 
            : patientReadings;
            
        final latest = _liveData.last;
        _currentPatient = _currentPatient!.copyWith(
          latestReading: latest,
          lastSyncTime: latest.timestamp,
        );
      } else {
        _liveData = [];
      }
    } catch (e) {
      debugPrint('Failed to load historical sensor data: $e');
      _liveData = [];
    }

    notifyListeners();

    // Start live updates (polling every 3 seconds)
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_isPaused) {
        _fetchLatestReading();
      }
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    _currentPatient = null;
    _liveData = [];
    _isPaused = false;
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void setTimeRange(int minutes) {
    _timeRangeMinutes = minutes;
    notifyListeners();
  }

  void setHeaterMode(HeaterMode mode) {
    if (_currentPatient == null) return;
    
    final updatedHeater = _currentPatient!.heaterStatus.copyWith(
      mode: mode,
      isActive: mode == HeaterMode.manual ? true : _currentPatient!.heaterStatus.isActive,
    );
    
    _currentPatient = _currentPatient!.copyWith(heaterStatus: updatedHeater);
    _patientProvider.updatePatientReadings(_currentPatient!.id, _currentPatient!);
    
    notifyListeners();
  }

  Future<void> _fetchLatestReading() async {
    if (_currentPatient == null) return;

    try {
      final nextReading = await _sensorApiService.getLatestReading(_currentPatient!.id);
      if (nextReading == null) return;

      // Only add if it's a new reading based on timestamp
      if (_liveData.isNotEmpty) {
        final lastTimestamp = _liveData.last.timestamp;
        if (!nextReading.timestamp.isAfter(lastTimestamp)) {
          return; // No new data
        }
      }

      // Add to chart data
      _liveData.add(nextReading);
      
      // Keep list size manageable (e.g., last 100 points)
      if (_liveData.length > 100) {
        _liveData.removeAt(0);
      }

      // Determine status based on thresholds
      PatientStatus newStatus = PatientStatus.stable;
      if (nextReading.temperature > 39.0 || nextReading.relativeHumidity > 85.0) {
        newStatus = PatientStatus.critical;
      } else if (nextReading.temperature > 37.5 || nextReading.relativeHumidity > 75.0) {
        newStatus = PatientStatus.warning;
      }

      // Update patient in provider
      _currentPatient = _currentPatient!.copyWith(
        latestReading: nextReading,
        status: newStatus,
        lastSyncTime: nextReading.timestamp,
        signalStrength: nextReading.signalStrength,
      );
      
      _patientProvider.updatePatientReadings(_currentPatient!.id, _currentPatient!);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load latest sensor reading from backend: $e');
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}

