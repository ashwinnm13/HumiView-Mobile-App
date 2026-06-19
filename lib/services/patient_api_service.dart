import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/patient.dart';

/// Service layer for communicating with the Spring Boot Patient REST API.
class PatientApiService {
  final http.Client _client;

  PatientApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all patients from `GET /api/patients`.
  Future<List<Patient>> getAllPatients() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.patientsEndpoint}');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => Patient.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load patients: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException('Could not connect to the server. Is the backend running?');
    }
  }

  /// Saves a new patient via `POST /api/patients`.
  Future<Patient> savePatient(Patient patient) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.patientsEndpoint}');

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(patient.toJson()),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Patient.fromJson(json);
      } else {
        throw HttpException(
          'Failed to save patient: ${response.statusCode} ${response.reasonPhrase}',
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
