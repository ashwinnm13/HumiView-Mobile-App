import 'package:flutter/material.dart';
import '../data/models/alert.dart';
import '../services/alert_api_service.dart';

class AlertProvider extends ChangeNotifier {
  final AlertApiService _apiService = AlertApiService();
  List<Alert> _alerts = [];
  bool _isLoading = false;

  AlertProvider() {
    _loadAlerts();
  }

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;

  int get unreadCount => _alerts.where((a) => !a.isRead).length;

  List<Alert> get criticalAlerts => 
      _alerts.where((a) => a.severity == AlertSeverity.critical).toList();

  Future<void> _loadAlerts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedAlerts = await _apiService.getAllAlerts();
      _alerts = List.from(fetchedAlerts)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Failed to load alerts: $e');
      _alerts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Reload alerts from the backend
  Future<void> refreshAlerts() async {
    await _loadAlerts();
  }

  Future<void> acknowledgeAlert(String id) async {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
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
  }

  Future<void> dismissAlert(String id) async {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
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
  }

  void markAllAsRead() {
    _alerts = _alerts.map((a) => a.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void clearDismissed() {
    _alerts.removeWhere((a) => a.status == AlertStatus.dismissed);
    notifyListeners();
  }
}
