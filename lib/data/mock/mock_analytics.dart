import 'dart:math';

/// Mock analytics data for charts and reports.
class MockAnalytics {
  MockAnalytics._();

  static final _random = Random(42);

  /// Daily average temperatures for the past 7 days
  static List<DailyMetric> weeklyTemperature() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DailyMetric(
        date: date,
        avg: 36.0 + _random.nextDouble() * 2.5,
        min: 35.5 + _random.nextDouble() * 1.0,
        max: 37.5 + _random.nextDouble() * 2.0,
      );
    });
  }

  /// Daily average relative humidity for the past 7 days
  static List<DailyMetric> weeklyHumidity() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DailyMetric(
        date: date,
        avg: 55.0 + _random.nextDouble() * 20.0,
        min: 45.0 + _random.nextDouble() * 10.0,
        max: 70.0 + _random.nextDouble() * 15.0,
      );
    });
  }

  /// Connection stability percentages per day
  static List<DailyValue> connectionStability() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DailyValue(
        date: date,
        value: 92.0 + _random.nextDouble() * 8.0,
      );
    });
  }

  /// Heater runtime minutes per day
  static List<DailyValue> heaterRuntime() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DailyValue(
        date: date,
        value: 5.0 + _random.nextDouble() * 15.0,
      );
    });
  }

  /// Overall system stats
  static SystemStats get systemStats => SystemStats(
        totalPatients: 10,
        onlineDevices: 8,
        activeAlerts: 4,
        avgUptime: 97.3,
      );
}

class DailyMetric {
  final DateTime date;
  final double avg;
  final double min;
  final double max;

  const DailyMetric({
    required this.date,
    required this.avg,
    required this.min,
    required this.max,
  });
}

class DailyValue {
  final DateTime date;
  final double value;

  const DailyValue({required this.date, required this.value});
}

class SystemStats {
  final int totalPatients;
  final int onlineDevices;
  final int activeAlerts;
  final double avgUptime;

  const SystemStats({
    required this.totalPatients,
    required this.onlineDevices,
    required this.activeAlerts,
    required this.avgUptime,
  });
}
