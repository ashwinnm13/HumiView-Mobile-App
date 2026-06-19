/// Central configuration for the Spring Boot backend API.
///
/// Change [baseUrl] depending on your environment:
/// - Android Emulator → host machine: `http://10.0.2.2:8080`
/// - Physical device on same Wi-Fi: `http://<your-machine-ip>:8080`
/// - iOS Simulator → host machine: `http://localhost:8080`
class ApiConstants {
  ApiConstants._();

  // ── Base URL ──────────────────────────────────────────────────────────
  // Change this to your machine's local IP when running on a physical device.
  static const String baseUrl = 'http://192.168.1.85:8080';

  // ── Endpoints ─────────────────────────────────────────────────────────
  static const String patientsEndpoint = '/patients';
  static const String sensorEndpoint = '/sensor';

  // ── Timeouts ──────────────────────────────────────────────────────────
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
