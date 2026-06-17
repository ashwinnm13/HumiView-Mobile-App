import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/patient.dart';
import '../data/models/sensor_reading.dart';
import '../data/models/heater_status.dart';
import '../data/mock/mock_readings.dart';
import 'patient_provider.dart';

class MonitoringProvider extends ChangeNotifier {
  final PatientProvider _patientProvider;
  
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

  void startMonitoring(String patientId) {
    // Clean up previous monitoring session
    stopMonitoring();

    _currentPatient = _patientProvider.getPatientById(patientId);
    if (_currentPatient == null) return;

    // Load initial historical data based on patient status
    if (_currentPatient!.status == PatientStatus.critical) {
      _liveData = MockReadings.criticalPatientReadings();
    } else if (_currentPatient!.status == PatientStatus.warning) {
      _liveData = MockReadings.warningPatientReadings();
    } else {
      _liveData = MockReadings.stablePatientReadings();
    }

    notifyListeners();

    // Start live updates (every 2 seconds for demo purposes)
    if (_currentPatient!.connectionStatus != ConnectionStatus.offline) {
      _timer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_isPaused) {
          _generateNextReading();
        }
      });
    }
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

  void _generateNextReading() {
    if (_currentPatient == null || _liveData.isEmpty) return;

    // Generate new point based on last point
    final nextReading = MockReadings.generateNextReading(_liveData.last);
    
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
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
