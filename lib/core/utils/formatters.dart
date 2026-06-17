import 'package:intl/intl.dart';

/// HumiView — Data Formatters
///
/// Formatting utilities for temperature, humidity, dates, and numbers.
class Formatters {
  Formatters._();

  /// Format temperature: "36.5°C"
  static String temperature(double value) => '${value.toStringAsFixed(1)}°C';

  /// Format relative humidity: "65.2%"
  static String relativeHumidity(double value) =>
      '${value.toStringAsFixed(1)}%';

  /// Format absolute humidity: "12.3 g/m³"
  static String absoluteHumidity(double value) =>
      '${value.toStringAsFixed(1)} g/m³';

  /// Format signal strength: "-67 dBm"
  static String signalStrength(int value) => '$value dBm';

  /// Signal strength description
  static String signalLabel(int dBm) {
    if (dBm >= -50) return 'Excellent';
    if (dBm >= -60) return 'Good';
    if (dBm >= -70) return 'Fair';
    if (dBm >= -80) return 'Weak';
    return 'Poor';
  }

  /// Format timestamp: "2:30 PM"
  static String time(DateTime dt) => DateFormat('h:mm a').format(dt);

  /// Format timestamp: "Jun 15, 2:30 PM"
  static String dateTime(DateTime dt) =>
      DateFormat('MMM d, h:mm a').format(dt);

  /// Format date: "June 15, 2025"
  static String dateFull(DateTime dt) =>
      DateFormat('MMMM d, yyyy').format(dt);

  /// Format date short: "Jun 15"
  static String dateShort(DateTime dt) => DateFormat('MMM d').format(dt);

  /// Time ago: "2 min ago", "1 hr ago", "3 days ago"
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return dateShort(dt);
  }

  /// Duration: "20 sec", "5 min", "2 hr"
  static String duration(Duration d) {
    if (d.inSeconds < 60) return '${d.inSeconds} sec';
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    return '${d.inHours} hr ${d.inMinutes.remainder(60)} min';
  }

  /// Percentage: "85%"
  static String percentage(double value) =>
      '${value.toStringAsFixed(0)}%';

  /// Countdown timer: "04:32"
  static String countdown(Duration remaining) {
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
