import '../../config/api_config.dart';
import 'api_service.dart';

class WasteApiService {
  static Future<List<Map<String, dynamic>>> getWasteEntries() async {
    final response = await ApiService.get(ApiConfig.wasteEntries);
    return List<Map<String, dynamic>>.from(response['entries'] ?? []);
  }
  
  static Future<Map<String, dynamic>> addWasteEntry(Map<String, dynamic> entry) async {
    return await ApiService.post(ApiConfig.addWasteEntry, entry);
  }
}