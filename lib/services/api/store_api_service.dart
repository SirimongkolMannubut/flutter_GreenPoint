import '../../config/api_config.dart';
import '../../models/models.dart';
import 'api_service.dart';

class StoreApiService {
  static Future<List<Map<String, dynamic>>> getStores() async {
    final response = await ApiService.get(ApiConfig.stores);
    return List<Map<String, dynamic>>.from(response['stores'] ?? []);
  }
  
  static Future<Map<String, dynamic>> addStore(PartnerStore store) async {
    return await ApiService.post(ApiConfig.addStore, {
      'id': store.id,
      'name': store.name,
      'description': store.description,
      'category': store.category,
      'address': store.address,
      'latitude': store.latitude,
      'longitude': store.longitude,
      'phone': store.phone,
      'imageUrl': store.imageUrl,
      'rating': store.rating,
      'tags': store.tags,
      'discount': store.discount,
      'pointsRequired': store.pointsRequired,
      'openHours': store.openHours,
      'emoji': store.emoji,
    });
  }
  
  static Future<Map<String, dynamic>> updateStore(String storeId, Map<String, dynamic> data) async {
    return await ApiService.put('${ApiConfig.stores}/$storeId', data);
  }
  
  static Future<Map<String, dynamic>> deleteStore(String storeId) async {
    return await ApiService.delete('${ApiConfig.stores}/$storeId');
  }
  
  static Future<Map<String, dynamic>> getStoreById(String storeId) async {
    return await ApiService.get('${ApiConfig.stores}/$storeId');
  }
}