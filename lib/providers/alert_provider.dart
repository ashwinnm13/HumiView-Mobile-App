import 'package:flutter/material.dart';
import '../data/models/alert.dart';
import '../data/mock/mock_alerts.dart';

class AlertProvider extends ChangeNotifier {
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

    await Future.delayed(const Duration(milliseconds: 800));

    // Sort by timestamp descending
    _alerts = List.from(MockAlerts.alerts)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    _isLoading = false;
    notifyListeners();
  }

  void acknowledgeAlert(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        status: AlertStatus.acknowledged,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void dismissAlert(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        status: AlertStatus.dismissed,
        isRead: true,
      );
      notifyListeners();
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
