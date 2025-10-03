import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'api_service.dart';

class UploadService {
  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/upload/profile');
      final request = http.MultipartRequest('POST', uri);
      
      // Add auth header if available
      if (ApiService.token != null) {
        request.headers['Authorization'] = 'Bearer ${ApiService.token}';
      }
      
      // Add image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final data = ApiService.parseResponse(responseBody);
        return data['imageUrl'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}