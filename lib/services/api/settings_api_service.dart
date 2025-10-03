import '../../config/api_config.dart';
import 'api_service.dart';

class SettingsApiService {
  static Future<Map<String, dynamic>> getSettings() async {
    return await ApiService.get(ApiConfig.getSettings);
  }
  
  static Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> settings) async {
    return await ApiService.put(ApiConfig.updateSettings, settings);
  }
}