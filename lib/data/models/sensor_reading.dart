/// A single sensor reading from the ESP32 device.
class SensorReading {
  final DateTime timestamp;
  final double temperature;      // °C
  final double relativeHumidity; // %
  final double absoluteHumidity; // g/m³
  final int signalStrength;      // dBm

  const SensorReading({
    required this.timestamp,
    required this.temperature,
    required this.relativeHumidity,
    required this.absoluteHumidity,
    this.signalStrength = -50,
  });

  SensorReading copyWith({
    DateTime? timestamp,
    double? temperature,
    double? relativeHumidity,
    double? absoluteHumidity,
    int? signalStrength,
  }) {
    return SensorReading(
      timestamp: timestamp ?? this.timestamp,
      temperature: temperature ?? this.temperature,
      relativeHumidity: relativeHumidity ?? this.relativeHumidity,
      absoluteHumidity: absoluteHumidity ?? this.absoluteHumidity,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }
}
