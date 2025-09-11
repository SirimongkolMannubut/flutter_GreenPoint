import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.104:3000/api/v1';
  static String? _token;
  
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth APIs
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({'email': email, 'password': password}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        return data;
      }
    } catch (e) {
      print('Login API error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['token'];
        return data;
      }
    } catch (e) {
      print('Register API error: $e');
    }
    return null;
  }

  // User APIs
  static Future<User?> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      }
    } catch (e) {
      print('Get profile API error: $e');
    }
    return null;
  }

  static Future<bool> updateProfile(String name, String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: _headers,
        body: json.encode({'name': name, 'email': email}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Update profile API error: $e');
    }
    return false;
  }

  static Future<bool> addPoints(int points, int plasticReduced, String activity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/points'),
        headers: _headers,
        body: json.encode({
          'points': points,
          'plasticReduced': plasticReduced,
          'activity': activity,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Add points API error: $e');
    }
    return false;
  }

  // Store APIs
  static Future<List<PartnerStore>> getStores() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stores'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['stores'] as List)
            .map((store) => PartnerStore.fromJson(store))
            .toList();
      }
    } catch (e) {
      print('Get stores API error: $e');
    }
    return [];
  }

  static Future<bool> redeemReward(String storeId, int points) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rewards/redeem'),
        headers: _headers,
        body: json.encode({'storeId': storeId, 'points': points}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Redeem reward API error: $e');
    }
    return false;
  }

  // Admin APIs
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['users']);
      }
    } catch (e) {
      print('Get all users API error: $e');
    }
    return [];
  }

  static Future<bool> addPointsToUser(String userId, int points, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/users/$userId/points'),
        headers: _headers,
        body: json.encode({'points': points, 'reason': reason}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Add points to user API error: $e');
    }
    return false;
  }

  static Future<bool> addStore(PartnerStore store) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/stores'),
        headers: _headers,
        body: json.encode(store.toJson()),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      print('Add store API error: $e');
    }
    return false;
  }

  static void logout() {
    _token = null;
  }
}