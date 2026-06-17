import 'dart:math';
import '../models/sensor_reading.dart';

/// Mock sensor reading generators for realistic demo data.
class MockReadings {
  MockReadings._();

  static final _random = Random(42);

  /// Generate a time-series of sensor readings for charts.
  ///
  /// [count]: Number of data points
  /// [intervalSeconds]: Time between readings
  /// [baseTemp]: Baseline temperature (°C)
  /// [baseRH]: Baseline relative humidity (%)
  static List<SensorReading> generateTimeSeries({
    int count = 60,
    int intervalSeconds = 60,
    double baseTemp = 36.5,
    double baseRH = 62.0,
    double baseAH = 14.0,
  }) {
    final now = DateTime.now();
    final readings = <SensorReading>[];

    double temp = baseTemp;
    double rh = baseRH;
    double ah = baseAH;

    for (int i = count - 1; i >= 0; i--) {
      // Realistic drift with small random variation
      temp += (_random.nextDouble() - 0.48) * 0.3;
      rh += (_random.nextDouble() - 0.48) * 1.2;
      ah += (_random.nextDouble() - 0.48) * 0.4;

      // Clamp to realistic ranges
      temp = temp.clamp(20.0, 42.0);
      rh = rh.clamp(25.0, 95.0);
      ah = ah.clamp(5.0, 30.0);

      readings.add(SensorReading(
        timestamp: now.subtract(Duration(seconds: i * intervalSeconds)),
        temperature: double.parse(temp.toStringAsFixed(1)),
        relativeHumidity: double.parse(rh.toStringAsFixed(1)),
        absoluteHumidity: double.parse(ah.toStringAsFixed(1)),
        signalStrength: -40 - _random.nextInt(30),
      ));
    }

    return readings;
  }

  /// Generate a single new reading based on previous values (for live updates).
  static SensorReading generateNextReading(SensorReading previous) {
    final rand = Random();
    double temp = previous.temperature + (rand.nextDouble() - 0.48) * 0.2;
    double rh = previous.relativeHumidity + (rand.nextDouble() - 0.48) * 0.8;
    double ah = previous.absoluteHumidity + (rand.nextDouble() - 0.48) * 0.3;

    return SensorReading(
      timestamp: DateTime.now(),
      temperature: double.parse(temp.clamp(20.0, 42.0).toStringAsFixed(1)),
      relativeHumidity:
          double.parse(rh.clamp(25.0, 95.0).toStringAsFixed(1)),
      absoluteHumidity:
          double.parse(ah.clamp(5.0, 30.0).toStringAsFixed(1)),
      signalStrength: -40 - rand.nextInt(30),
    );
  }

  /// Pre-generated readings per patient for different scenarios.
  static List<SensorReading> stablePatientReadings() =>
      generateTimeSeries(baseTemp: 36.5, baseRH: 60, baseAH: 13.5);

  static List<SensorReading> warningPatientReadings() =>
      generateTimeSeries(baseTemp: 38.0, baseRH: 76, baseAH: 18.0);

  static List<SensorReading> criticalPatientReadings() =>
      generateTimeSeries(baseTemp: 39.5, baseRH: 87, baseAH: 23.0);
}
