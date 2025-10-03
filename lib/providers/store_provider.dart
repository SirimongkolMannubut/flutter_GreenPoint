import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/data/storage_service.dart';
import '../services/api/store_api_service.dart';

class StoreProvider with ChangeNotifier {
  List<PartnerStore> _stores = [];
  List<PartnerStore> _filteredStores = [];
  String _searchQuery = '';
  String _selectedCategory = 'ทั้งหมด';
  bool _isLoading = false;

  List<PartnerStore> get stores => _filteredStores;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<String> get categories => [
    'ทั้งหมด',
    'ร้านอาหาร',
    'คาเฟ่',
    'ร้านค้าทั่วไป',
    'ซูเปอร์มาร์เก็ต',
    'ร้านหนังสือ',
    'ร้านเสื้อผ้า',
  ];

  StoreProvider() {
    loadStores();
  }

  Future<void> loadStores() async {
    _isLoading = true;
    notifyListeners();
    
    // โหลดจาก local storage ก่อนเสมอ
    try {
      final localStores = await StorageService.getStores();
      _stores = localStores.map((store) => PartnerStore.fromJson(store as Map<String, dynamic>)).toList();
      _filteredStores = List.from(_stores);
      notifyListeners(); // แสดงข้อมูล local ก่อน
    } catch (localError) {
      debugPrint('Local storage load failed: $localError');
    }
    
    // จากนั้นพยายามโหลดจาก API
    try {
      final apiStores = await StoreApiService.getStores();
      
      // รวมข้อมูลจาก API กับ local storage
      final Map<String, PartnerStore> storeMap = {};
      
      // เพิ่มร้านค้าจาก local ก่อน
      for (var store in _stores) {
        storeMap[store.id] = store;
      }
      
      // เพิ่มหรืออัปเดตจาก API
      for (var storeData in apiStores) {
        final store = PartnerStore.fromJson(storeData);
        storeMap[store.id] = store;
        // บันทึกลง local storage
        await StorageService.addStore(storeData);
      }
      
      _stores = storeMap.values.toList();
      _filteredStores = List.from(_stores);
      
    } catch (apiError) {
      debugPrint('API load stores failed: $apiError - ใช้ข้อมูล local');
      // ไม่ต้องทำอะไร เพราะมีข้อมูล local อยู่แล้ว
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _loadStores() {
    _stores = [];
    _filteredStores = [];
  }

  Future<bool> addStore(PartnerStore store) async {
    // เพิ่มลง local ทันที
    _stores.add(store);
    _filterStores();
    notifyListeners(); // แจ้งให้ UI อัปเดต
    
    // บันทึกลง local storage ทันที
    try {
      await StorageService.addStore(store.toJson());
    } catch (localError) {
      debugPrint('Local storage failed: $localError');
    }
    
    // พยายามส่งไป API ในพื้นหลัง
    try {
      await StoreApiService.addStore(store);
      debugPrint('Store synced to API successfully');
    } catch (apiError) {
      debugPrint('API sync failed: $apiError - ร้านค้าถูกบันทึกใน local แล้ว');
    }
    
    return true;
  }

  void removeStore(String storeId) {
    _stores.removeWhere((store) => store.id == storeId);
    _filterStores();
  }

  void updateStore(PartnerStore updatedStore) {
    final index = _stores.indexWhere((store) => store.id == updatedStore.id);
    if (index != -1) {
      _stores[index] = updatedStore;
      _filterStores();
    }
  }

  void searchStores(String query) {
    _searchQuery = query;
    _filterStores();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _filterStores();
  }

  void _filterStores() {
    _filteredStores = _stores.where((store) {
      final matchesSearch = _searchQuery.isEmpty ||
          store.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          store.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          store.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesCategory = _selectedCategory == 'ทั้งหมด' ||
          store.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }

  PartnerStore? getStoreById(String id) {
    try {
      return _stores.firstWhere((store) => store.id == id);
    } catch (e) {
      return null;
    }
  }
}