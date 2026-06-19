import 'sensor_reading.dart';
import 'heater_status.dart';

/// Connection status of a patient's monitoring device.
enum ConnectionStatus { online, offline, connecting }

/// Patient clinical status.
enum PatientStatus { stable, warning, critical, offline }

/// Connection type for the ESP32 device.
enum ConnectionType { wifi, usb }

/// A monitored patient with assigned device and latest readings.
class Patient {
  final String id;
  final String name;
  final String photoUrl;
  final String roomNumber;
  final String deviceId;
  final ConnectionType connectionType;
  final ConnectionStatus connectionStatus;
  final PatientStatus status;
  final SensorReading? latestReading;
  final HeaterStatus heaterStatus;
  final int signalStrength; // dBm
  final DateTime? lastSyncTime;

  const Patient({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.roomNumber,
    required this.deviceId,
    required this.connectionType,
    required this.connectionStatus,
    required this.status,
    this.latestReading,
    required this.heaterStatus,
    this.signalStrength = -50,
    this.lastSyncTime,
  });

  Patient copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? roomNumber,
    String? deviceId,
    ConnectionType? connectionType,
    ConnectionStatus? connectionStatus,
    PatientStatus? status,
    SensorReading? latestReading,
    HeaterStatus? heaterStatus,
    int? signalStrength,
    DateTime? lastSyncTime,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      roomNumber: roomNumber ?? this.roomNumber,
      deviceId: deviceId ?? this.deviceId,
      connectionType: connectionType ?? this.connectionType,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      status: status ?? this.status,
      latestReading: latestReading ?? this.latestReading,
      heaterStatus: heaterStatus ?? this.heaterStatus,
      signalStrength: signalStrength ?? this.signalStrength,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  /// Creates a [Patient] from Spring Boot backend JSON.
  ///
  /// Maps backend fields: `patientName`, `patientId`, `roomNumber`,
  /// `deviceId`, `status`. Fields not present in the backend get defaults.
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['patientId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['patientName'] as String? ?? 'Unknown',
      photoUrl: '', // Not stored in backend yet
      roomNumber: json['roomNumber'] as String? ?? '',
      deviceId: json['deviceId'] as String? ?? '',
      connectionType: ConnectionType.wifi,
      connectionStatus: ConnectionStatus.offline,
      status: _parseStatus(json['status'] as String?),
      heaterStatus: const HeaterStatus(),
    );
  }

  /// Converts to JSON for the Spring Boot `POST /api/patients` endpoint.
  Map<String, dynamic> toJson() {
    return {
      'patientName': name,
      'patientId': id,
      'roomNumber': roomNumber,
      'deviceId': deviceId,
      'status': status.name,
    };
  }

  /// Maps a backend status string to [PatientStatus].
  static PatientStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'critical':
        return PatientStatus.critical;
      case 'warning':
        return PatientStatus.warning;
      case 'stable':
        return PatientStatus.stable;
      case 'offline':
        return PatientStatus.offline;
      default:
        return PatientStatus.stable;
    }
  }

  /// Returns initials for avatar placeholder
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

