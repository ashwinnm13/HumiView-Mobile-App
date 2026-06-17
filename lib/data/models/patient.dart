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

  /// Returns initials for avatar placeholder
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
