import 'package:flutter/foundation.dart';
import '../models/partner_store.dart';
import '../services/api_service.dart';

class ApiStoreProvider with ChangeNotifier {
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

  Future<void> loadStores() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _stores = await ApiService.getStores();
      _filteredStores = List.from(_stores);
    } catch (e) {
      debugPrint('Error loading stores: $e');
      _stores = [];
      _filteredStores = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStore(PartnerStore store) async {
    try {
      final success = await ApiService.addStore(store);
      if (success) {
        _stores.add(store);
        _filterStores();
      }
    } catch (e) {
      debugPrint('Error adding store: $e');
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