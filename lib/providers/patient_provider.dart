import 'package:flutter/material.dart';
import '../data/models/patient.dart';
import '../data/models/heater_status.dart';
import '../services/patient_api_service.dart';
import '../services/sensor_api_service.dart';

class PatientProvider extends ChangeNotifier {
  final PatientApiService _apiService = PatientApiService();

  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _currentFilter = 'All';
  String? _errorMessage;

  PatientProvider() {
    _loadPatients();
  }

  List<Patient> get patients => _filteredPatients;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get currentFilter => _currentFilter;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> _loadPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allPatients = await _apiService.getAllPatients();
      
      // Fetch latest reading for each patient to display on the dashboard cards
      final sensorApi = SensorApiService();
      for (int i = 0; i < _allPatients.length; i++) {
        try {
          final latest = await sensorApi.getLatestReading(_allPatients[i].id);
          if (latest != null) {
            _allPatients[i] = _allPatients[i].copyWith(latestReading: latest);
          }
        } catch (_) {
          // Ignore individual fetch errors so the rest of the list loads
        }
      }

      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
      _allPatients = [];
      _filteredPatients = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadPatients();
  }

  /// Adds a new patient by POSTing to the Spring Boot backend.
  Future<bool> addPatient({
    required String name,
    int? age,
    DateTime? admissionDate,
    String imageUrl = '',
    required String roomNumber,
    required String deviceId,
  }) async {
    try {
      final newPatient = Patient(
        id: '', // Backend will auto-generate
        name: name,
        imageUrl: imageUrl,
        age: age,
        admissionDate: admissionDate,
        roomNumber: roomNumber,
        deviceId: deviceId,
        connectionType: ConnectionType.wifi,
        connectionStatus: ConnectionStatus.offline,
        status: PatientStatus.stable,
        heaterStatus: const HeaterStatus(),
      );

      final savedPatient = await _apiService.savePatient(newPatient);
      _allPatients.add(savedPatient);
      _applyFilters();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredPatients = _allPatients.where((patient) {
      // 1. Apply Search
      final matchesSearch = _searchQuery.isEmpty ||
          patient.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          patient.roomNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          patient.deviceId.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      // 2. Apply Status Filter
      if (_currentFilter == 'All') return true;
      
      switch (_currentFilter) {
        case 'Critical':
          return patient.status == PatientStatus.critical;
        case 'Warning':
          return patient.status == PatientStatus.warning;
        case 'Stable':
          return patient.status == PatientStatus.stable;
        case 'Offline':
          return patient.status == PatientStatus.offline || patient.connectionStatus == ConnectionStatus.offline;
        default:
          return true;
      }
    }).toList();

    notifyListeners();
  }

  Patient? getPatientById(String id) {
    try {
      return _allPatients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Used by the MonitoringProvider to update patient data globally
  void updatePatientReadings(String patientId, Patient updatedPatient) {
    final index = _allPatients.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      _allPatients[index] = updatedPatient;
      // Also update in filtered list if present
      final filteredIndex = _filteredPatients.indexWhere((p) => p.id == patientId);
      if (filteredIndex != -1) {
        _filteredPatients[filteredIndex] = updatedPatient;
      }
      notifyListeners();
    }
  }
}
