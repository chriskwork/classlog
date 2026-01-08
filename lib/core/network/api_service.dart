import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Use API_URL for web (production), API_LOCAL_URL for other platforms (development)
  final String baseUrl = dotenv.env['API_URL'] ?? dotenv.env['API_LOCAL_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? dotenv.env['API_LOCAL_KEY'] ?? '';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Token': apiKey,
      };

  // GET
  Future<dynamic> get(String endpoint) async {
    try {
      final url = '$baseUrl/$endpoint';
      if (kIsWeb) {
        print('[API] GET request to: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (kIsWeb) {
        print('[API] Response status: ${response.statusCode}');
        print('[API] Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error - Cargar los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error - Cargar los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
