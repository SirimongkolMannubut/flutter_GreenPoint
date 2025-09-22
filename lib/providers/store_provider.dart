import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/data/storage_service.dart';

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
    
    try {
      final storesData = await StorageService.getStores();
      _stores = storesData.map((store) => PartnerStore.fromJson(store)).toList();
      _filteredStores = List.from(_stores);
    } catch (e) {
      debugPrint('Error loading stores: $e');
      _stores = [];
      _filteredStores = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _loadStores() {
    // ไม่ต้องโหลด demo data แล้ว เพราะจะโหลดจาก API
  }

  Future<bool> addStore(PartnerStore store) async {
    try {
      await StorageService.addStore(store.toJson());
      _stores.add(store);
      _filterStores();
      return true;
    } catch (e) {
      debugPrint('Error adding store: $e');
      return false;
    }
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