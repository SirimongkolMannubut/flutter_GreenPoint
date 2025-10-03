import 'dart:io';
import '../../config/api_config.dart';
import '../../models/models.dart';
import 'api_service.dart';
import 'upload_service.dart';

class UserApiService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.post(ApiConfig.login, {
      'email': email,
      'password': password,
    });
    
    if (response['token'] != null) {
      ApiService.setToken(response['token']);
    }
    
    return response;
  }
  
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await ApiService.post(ApiConfig.register, {
      'name': name,
      'email': email,
      'password': password,
    });
    
    if (response['token'] != null) {
      ApiService.setToken(response['token']);
    }
    
    return response;
  }
  
  static Future<void> logout() async {
    try {
      await ApiService.post(ApiConfig.logout, {});
    } catch (e) {
      // Continue with logout even if API call fails
    }
    ApiService.clearToken();
  }
  
  static Future<Map<String, dynamic>> getProfile() async {
    return await ApiService.get(ApiConfig.profile);
  }
  
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await ApiService.put(ApiConfig.updateProfile, data);
  }
  
  static Future<Map<String, dynamic>> addPoints(String userId, int points, String reason) async {
    return await ApiService.post(ApiConfig.addPoints, {
      'userId': userId,
      'points': points,
      'reason': reason,
    });
  }
  
  static Future<Map<String, dynamic>> deductPoints(String userId, int points, String reason) async {
    return await ApiService.post(ApiConfig.deductPoints, {
      'userId': userId,
      'points': points,
      'reason': reason,
    });
  }
  
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await ApiService.get(ApiConfig.users);
    return List<Map<String, dynamic>>.from(response['users'] ?? []);
  }
  
  static Future<String?> uploadProfileImage(File imageFile) async {
    return await UploadService.uploadProfileImage(imageFile);
  }
}