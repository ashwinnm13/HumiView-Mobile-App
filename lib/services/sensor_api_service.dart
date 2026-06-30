import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/sensor_reading.dart';

/// Service layer for communicating with the Spring Boot Sensor REST API.
class SensorApiService {
  final http.Client _client;

  SensorApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all sensor readings from `GET /sensor`.
  /// Note: The backend currently returns all readings. You may want to filter
  /// by patient ID on the frontend if needed, or update the backend to filter.
  Future<List<SensorReading>> getAllReadings() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sensorEndpoint}');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => SensorReading.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load sensor readings: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException('Could not connect to the server. Is the backend running?');
    }
  }

  /// Fetches the latest sensor reading for a specific patient.
  Future<SensorReading?> getLatestReading(String patientId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sensorEndpoint}/latest/$patientId');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) {
          return null; // Spring Boot returns empty body when returning null
        }
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return SensorReading.fromJson(json);
      } else if (response.statusCode == 404 || response.statusCode == 204) {
        return null;
      } else {
        throw HttpException(
          'Failed to load latest reading: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException('Could not connect to the server. Is the backend running?');
    }
  }

  /// Fetches the historical sensor readings for a specific patient.
  Future<List<SensorReading>> getPatientHistory(String patientId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sensorEndpoint}/history/$patientId');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) return [];
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => SensorReading.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load patient history: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException('Could not connect to the server. Is the backend running?');
    }
  }

  /// Saves a new sensor reading via `POST /sensor`.
  Future<SensorReading> saveReading(SensorReading reading) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sensorEndpoint}');

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(reading.toJson()),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return SensorReading.fromJson(json);
      } else {
        throw HttpException(
          'Failed to save sensor reading: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException('Could not connect to the server. Is the backend running?');
    }
  }

  /// Disposes the underlying HTTP client.
  void dispose() {
    _client.close();
  }
}
