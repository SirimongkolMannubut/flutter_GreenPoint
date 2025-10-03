import '../../config/api_config.dart';
import 'api_service.dart';

class AdminApiService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.post(ApiConfig.adminLogin, {
      'email': email,
      'password': password,
    });
    
    if (response['token'] != null) {
      ApiService.setToken(response['token']);
    }
    
    return response;
  }
  
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await ApiService.get(ApiConfig.adminUsers);
    return List<Map<String, dynamic>>.from(response['users'] ?? []);
  }
  
  static Future<Map<String, dynamic>> addPointsToUser(String userId, int points, String reason) async {
    return await ApiService.post(ApiConfig.adminAddPoints, {
      'userId': userId,
      'points': points,
      'reason': reason,
    });
  }
  
  static Future<Map<String, dynamic>> deductPointsFromUser(String userId, int points, String reason) async {
    return await ApiService.post(ApiConfig.adminDeductPoints, {
      'userId': userId,
      'points': points,
      'reason': reason,
    });
  }
}