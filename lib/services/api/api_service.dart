import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';

class ApiService {
  static String? _token;
  
  static void setToken(String token) {
    _token = token;
  }
  
  static void clearToken() {
    _token = null;
  }
  
  static String? get token => _token;
  
  static Map<String, dynamic> parseResponse(String responseBody) {
    return json.decode(responseBody);
  }
  
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: _token != null 
          ? ApiConfig.authHeaders(_token!)
          : ApiConfig.headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: _token != null 
          ? ApiConfig.authHeaders(_token!)
          : ApiConfig.headers,
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: _token != null 
          ? ApiConfig.authHeaders(_token!)
          : ApiConfig.headers,
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: _token != null 
          ? ApiConfig.authHeaders(_token!)
          : ApiConfig.headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = json.decode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'API Error: ${response.statusCode}');
    }
  }
}