import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/alert.dart';

/// Service layer for communicating with the Spring Boot Alert REST API.
///
/// Mirrors [SensorApiService] conventions. All endpoints are derived from
/// [ApiConstants.alertsEndpoint] so a future Firestore migration only
/// requires swapping this class (or injecting a different implementation).
class AlertApiService {
  final http.Client _client;

  AlertApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── Helpers ──────────────────────────────────────────────────────────

  Uri _uri(String path) =>
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.alertsEndpoint}$path');

  Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ── GET all alerts ───────────────────────────────────────────────────

  /// Fetch every alert across all patients.
  Future<List<Alert>> getAllAlerts() async {
    final uri = _uri('');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) return [];
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Alert.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load alerts: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'Could not connect to the server. Is the backend running?',
      );
    }
  }

  // ── GET alerts for a patient ─────────────────────────────────────────

  /// Fetch alerts scoped to a single patient.
  Future<List<Alert>> getAlertsByPatientId(String patientId) async {
    final uri = _uri('/patient/$patientId');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) return [];
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Alert.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load patient alerts: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'Could not connect to the server. Is the backend running?',
      );
    }
  }

  // ── PUT update alert ─────────────────────────────────────────────────

  /// Persist an alert mutation (acknowledge / dismiss).
  Future<Alert> updateAlert(Alert alert) async {
    final uri = _uri('/update');

    try {
      final response = await _client
          .put(uri, headers: _jsonHeaders, body: jsonEncode(alert.toJson()))
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        return Alert.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw HttpException(
          'Failed to update alert: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'Could not connect to the server. Is the backend running?',
      );
    }
  }

  // ── DELETE alert ─────────────────────────────────────────────────────

  /// Delete a dismissed alert by its ID.
  Future<void> deleteAlert(String alertId) async {
    final uri = _uri('/$alertId');

    try {
      final response = await _client
          .delete(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpException(
          'Failed to delete alert: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'Could not connect to the server. Is the backend running?',
      );
    }
  }

  /// Disposes the underlying HTTP client.
  void dispose() {
    _client.close();
  }
}
