import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/alert.dart';
import '../services/alert_api_service.dart';
import 'patient_provider.dart';

/// Manages alert state with automatic 3-second polling from the backend.
///
/// Depends on [PatientProvider] to resolve `patientId` → patient name/room,
/// since the backend alert JSON only carries the numeric `patientId`.
///
/// Follows the same Timer.periodic pattern used by [MonitoringProvider]
/// for sensor data. All UI screens consume this via `Consumer<AlertProvider>`.
class AlertProvider extends ChangeNotifier {
  final AlertApiService _apiService;
  PatientProvider _patientProvider;

  List<Alert> _alerts = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _pollingTimer;

  /// Duration between automatic backend fetches.
  static const Duration _pollInterval = Duration(seconds: 3);

  AlertProvider(this._patientProvider, {AlertApiService? apiService})
      : _apiService = apiService ?? AlertApiService() {
    _startPolling();
  }

  /// Called by ChangeNotifierProxyProvider when PatientProvider updates.
  void updatePatientProvider(PatientProvider patientProvider) {
    _patientProvider = patientProvider;
  }

  // ── Getters ────────────────────────────────────────────────────────────

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  int get unreadCount => _alerts.where((a) => !a.isRead).length;

  List<Alert> get criticalAlerts =>
      _alerts.where((a) => a.severity == AlertSeverity.critical).toList();

  // ── Polling lifecycle ──────────────────────────────────────────────────

  /// Kick off the initial fetch + recurring timer.
  void _startPolling() {
    // Immediate first fetch
    _loadAlerts();

    // Periodic refresh — same pattern as MonitoringProvider._timer
    _pollingTimer = Timer.periodic(_pollInterval, (_) => _loadAlerts());
  }

  /// Stop the recurring timer (e.g. when disposed).
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  // ── Data loading ───────────────────────────────────────────────────────

  Future<void> _loadAlerts() async {
    // Only show the loading spinner on the very first fetch
    if (_alerts.isEmpty && _errorMessage == null) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final fetchedAlerts = await _apiService.getAllAlerts();

      // Enrich each alert with patient name & room from PatientProvider
      final enriched = fetchedAlerts.map((alert) {
        final patient = _patientProvider.getPatientById(alert.patientId);
        if (patient != null) {
          return Alert(
            id: alert.id,
            patientId: alert.patientId,
            patientName: patient.name,
            type: alert.type,
            message: alert.message,
            severity: alert.severity,
            status: alert.status,
            timestamp: alert.timestamp,
            roomNumber: patient.roomNumber,
            isRead: alert.isRead,
          );
        }
        return alert;
      }).toList();

      enriched.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _alerts = enriched;
      _errorMessage = null;
    } catch (e) {
      // On first load failure show error; on subsequent failures keep stale
      // data so the UI doesn't flash empty.
      if (_alerts.isEmpty) {
        _errorMessage = e.toString();
      }
      debugPrint('Failed to load alerts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Manual refresh — exposed so screens can trigger pull-to-refresh.
  Future<void> refreshAlerts() async {
    await _loadAlerts();
  }

  // ── Alert mutations ────────────────────────────────────────────────────

  Future<void> acknowledgeAlert(String id) async {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index == -1) return;

    // Optimistic update
    final original = _alerts[index];
    _alerts[index] = original.copyWith(
      status: AlertStatus.acknowledged,
      isRead: true,
    );
    notifyListeners();

    try {
      await _apiService.updateAlert(_alerts[index]);
    } catch (e) {
      // Revert on failure
      _alerts[index] = original;
      notifyListeners();
      debugPrint('Failed to acknowledge alert: $e');
    }
  }

  Future<void> dismissAlert(String id) async {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index == -1) return;

    // Optimistic update
    final original = _alerts[index];
    _alerts[index] = original.copyWith(
      status: AlertStatus.dismissed,
      isRead: true,
    );
    notifyListeners();

    try {
      await _apiService.updateAlert(_alerts[index]);
    } catch (e) {
      _alerts[index] = original;
      notifyListeners();
      debugPrint('Failed to dismiss alert: $e');
    }
  }

  void markAllAsRead() {
    _alerts = _alerts.map((a) => a.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void clearDismissed() {
    _alerts.removeWhere((a) => a.status == AlertStatus.dismissed);
    notifyListeners();
  }

  // ── Cleanup ────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _stopPolling();
    _apiService.dispose();
    super.dispose();
  }
}
