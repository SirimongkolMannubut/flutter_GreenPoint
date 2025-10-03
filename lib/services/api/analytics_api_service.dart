import '../../config/api_config.dart';
import 'api_service.dart';

class AnalyticsApiService {
  static Future<Map<String, dynamic>> getAnalytics() async {
    return await ApiService.get(ApiConfig.getAnalytics);
  }
}