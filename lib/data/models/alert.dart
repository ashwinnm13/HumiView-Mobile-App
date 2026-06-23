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
  final String type;

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
    this.type = 'General',
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
      type: type,
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    final sevStr = json['severity']?.toString().toLowerCase();
    AlertSeverity sev = AlertSeverity.info;
    if (sevStr == 'critical') sev = AlertSeverity.critical;
    if (sevStr == 'warning') sev = AlertSeverity.warning;

    final bool ack = json['acknowledged'] == true;

    return Alert(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? 'Unknown',
      type: json['type']?.toString() ?? 'General',
      message: json['message']?.toString() ?? '',
      severity: sev,
      status: ack ? AlertStatus.acknowledged : AlertStatus.open,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      roomNumber: json['roomNumber']?.toString(),
      isRead: ack,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': int.tryParse(id) ?? id,
      if (patientId.isNotEmpty) 'patientId': int.tryParse(patientId) ?? patientId,
      'type': type,
      'message': message,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String().split('Z').first,
      'acknowledged': status == AlertStatus.acknowledged || status == AlertStatus.dismissed || isRead,
    };
  }
}
