/// Severity level for alerts.
enum AlertSeverity { critical, warning, info }

/// Status of an alert.
enum AlertStatus { open, acknowledged, dismissed }

/// An alert notification for the monitoring system.
class Alert {
  final String id;
  final String patientId;
  final String patientName;
  final String message;
  final AlertSeverity severity;
  final AlertStatus status;
  final DateTime timestamp;
  final String? roomNumber;
  final bool isRead;

  const Alert({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.message,
    required this.severity,
    this.status = AlertStatus.open,
    required this.timestamp,
    this.roomNumber,
    this.isRead = false,
  });

  Alert copyWith({
    AlertStatus? status,
    bool? isRead,
  }) {
    return Alert(
      id: id,
      patientId: patientId,
      patientName: patientName,
      message: message,
      severity: severity,
      status: status ?? this.status,
      timestamp: timestamp,
      roomNumber: roomNumber,
      isRead: isRead ?? this.isRead,
    );
  }
}
