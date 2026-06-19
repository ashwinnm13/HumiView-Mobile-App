/// A single sensor reading from the ESP32 device.
class SensorReading {
  final String? id;
  final DateTime timestamp;
  final double temperature;      // °C
  final double relativeHumidity; // %
  final double absoluteHumidity; // g/m³
  final int heaterStatus;        // Spring Boot expects Integer
  final String? patientId;       // Mapped to Spring Boot's Long patientId
  final int signalStrength;      // dBm

  const SensorReading({
    this.id,
    required this.timestamp,
    required this.temperature,
    required this.relativeHumidity,
    required this.absoluteHumidity,
    this.heaterStatus = 0,
    this.patientId,
    this.signalStrength = -50,
  });

  SensorReading copyWith({
    String? id,
    DateTime? timestamp,
    double? temperature,
    double? relativeHumidity,
    double? absoluteHumidity,
    int? heaterStatus,
    String? patientId,
    int? signalStrength,
  }) {
    return SensorReading(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      temperature: temperature ?? this.temperature,
      relativeHumidity: relativeHumidity ?? this.relativeHumidity,
      absoluteHumidity: absoluteHumidity ?? this.absoluteHumidity,
      heaterStatus: heaterStatus ?? this.heaterStatus,
      patientId: patientId ?? this.patientId,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }

  /// Creates a [SensorReading] from Spring Boot JSON.
  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id']?.toString(),
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relativeHumidity'] as num?)?.toDouble() ?? 0.0,
      absoluteHumidity: (json['absoluteHumidity'] as num?)?.toDouble() ?? 0.0,
      heaterStatus: json['heaterStatus'] as int? ?? 0,
      patientId: json['patientId']?.toString(),
      signalStrength: -50, // Not from DB
    );
  }

  /// Converts to JSON for the Spring Boot `POST /sensor` endpoint.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'relativeHumidity': relativeHumidity,
      'absoluteHumidity': absoluteHumidity,
      'heaterStatus': heaterStatus,
      'patientId': int.tryParse(patientId ?? '0'),
    };
  }
}
