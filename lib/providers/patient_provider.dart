import 'package:flutter/material.dart';
import '../data/models/patient.dart';
import '../data/mock/mock_patients.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _currentFilter = 'All';

  PatientProvider() {
    _loadPatients();
  }

  List<Patient> get patients => _filteredPatients;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get currentFilter => _currentFilter;

  Future<void> _loadPatients() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay for realism
    await Future.delayed(const Duration(seconds: 1));

    _allPatients = List.from(MockPatients.patients);
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadPatients();
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
