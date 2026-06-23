import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/alert.dart';

class AlertApiService {
  final http.Client _client;

  AlertApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch all alerts across all patients
  Future<List<Alert>> getAllAlerts() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/alerts');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) return [];
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Alert.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load alerts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while fetching alerts: $e');
    }
  }

  /// Fetch alerts for a specific patient
  Future<List<Alert>> getAlertsByPatientId(String patientId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/alerts/patient/$patientId');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        if (response.body.trim().isEmpty) return [];
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Alert.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load patient alerts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while fetching patient alerts: $e');
    }
  }

  /// Update an alert (e.g. to mark as acknowledged)
  Future<Alert> updateAlert(Alert alert) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/alerts/update');
    
    try {
      final response = await _client
          .put(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(alert.toJson()),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        return Alert.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update alert: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while updating alert: $e');
    }
  }
}
