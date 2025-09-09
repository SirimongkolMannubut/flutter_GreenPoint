import 'package:flutter/foundation.dart';
import '../models/partner_store.dart';

class StoreProvider with ChangeNotifier {
  List<PartnerStore> _stores = [];
  List<PartnerStore> _filteredStores = [];
  String _searchQuery = '';
  String _selectedCategory = 'ทั้งหมด';

  List<PartnerStore> get stores => _filteredStores;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

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
    _loadStores();
  }

  void _loadStores() {
    _stores = [
      PartnerStore(
        id: '1',
        name: 'Green Café & Bistro',
        category: 'คาเฟ่',
        description: 'คาเฟ่เพื่อสิ่งแวดล้อม เสิร์ฟเครื่องดื่มออร์แกนิค',
        address: '123 ถนนสีลม แขวงสีลม เขตบางรัก กรุงเทพฯ 10500',
        latitude: 13.7249,
        longitude: 100.5343,
        phone: '02-234-5678',
        imageUrl: '',
        rating: 4.8,
        tags: ['ออร์แกนิค', 'เป็นมิตรกับสิ่งแวดล้อม', 'ไม่ใช้พลาสติก'],
        discount: 'ลด 15% เมื่อใช้แต้ม',
        pointsRequired: 100,
        openHours: '07:00 - 21:00',
        emoji: '☕',
      ),
      PartnerStore(
        id: '2',
        name: 'Eco Market',
        category: 'ซูเปอร์มาร์เก็ต',
        description: 'ซูเปอร์มาร์เก็ตสินค้าออร์แกนิคและเป็นมิตรกับสิ่งแวดล้อม',
        address: '456 ถนนสุขุมวิท แขวงคลองตัน เขตวัฒนา กรุงเทพฯ 10110',
        latitude: 13.7308,
        longitude: 100.5418,
        phone: '02-345-6789',
        imageUrl: '',
        rating: 4.6,
        tags: ['ออร์แกนิค', 'ผลิตภัณฑ์ธรรมชาติ', 'บรรจุภัณฑ์รีไซเคิล'],
        discount: 'ลด 10% สำหรับสินค้าออร์แกนิค',
        pointsRequired: 150,
        openHours: '08:00 - 22:00',
        emoji: '🛒',
      ),
      PartnerStore(
        id: '3',
        name: 'Veggie Delight',
        category: 'ร้านอาหาร',
        description: 'ร้านอาหารเจมังสวิรัติ 100% ไม่ใช้ถุงพลาสติก',
        address: '789 ถนนพหลโยธิน แขวงสามเสนใน เขตพญาไท กรุงเทพฯ 10400',
        latitude: 13.7650,
        longitude: 100.5380,
        phone: '02-456-7890',
        imageUrl: '',
        rating: 4.7,
        tags: ['อาหารเจ', 'มังสวิรัติ', 'ไม่ใช้พลาสติก'],
        discount: 'ลด 20% เมื่อนำกล่องอาหารมาเอง',
        pointsRequired: 120,
        openHours: '10:00 - 20:00',
        emoji: '🥗',
      ),
      PartnerStore(
        id: '4',
        name: 'Earth Books',
        category: 'ร้านหนังสือ',
        description: 'ร้านหนังสือเกี่ยวกับสิ่งแวดล้อมและการพัฒนาอย่างยั่งยืน',
        address: '321 ถนนราชดำเนิน แขวงบวรนิเวศ เขตพระนคร กรุงเทพฯ 10200',
        latitude: 13.7563,
        longitude: 100.5018,
        phone: '02-567-8901',
        imageUrl: '',
        rating: 4.5,
        tags: ['หนังสือสิ่งแวดล้อม', 'ความรู้', 'การศึกษา'],
        discount: 'ลด 25% หนังสือเกี่ยวกับสิ่งแวดล้อม',
        pointsRequired: 80,
        openHours: '09:00 - 19:00',
        emoji: '📚',
      ),
      PartnerStore(
        id: '5',
        name: 'Natural Threads',
        category: 'ร้านเสื้อผ้า',
        description: 'ร้านเสื้อผ้าจากผ้าออร์แกนิคและรีไซเคิล',
        address: '654 ถนนเจริญกรุง แขวงบางรัก เขตบางรัก กรุงเทพฯ 10500',
        latitude: 13.7200,
        longitude: 100.5150,
        phone: '02-678-9012',
        imageUrl: '',
        rating: 4.4,
        tags: ['ผ้าออร์แกนิค', 'รีไซเคิล', 'แฟชั่นยั่งยืน'],
        discount: 'ลด 30% เสื้อผ้าจากผ้ารีไซเคิล',
        pointsRequired: 200,
        openHours: '10:00 - 21:00',
        emoji: '👕',
      ),
      PartnerStore(
        id: '6',
        name: 'Fresh & Clean',
        category: 'ร้านค้าทั่วไป',
        description: 'ร้านขายผลิตภัณฑ์ทำความสะอาดธรรมชาติ',
        address: '987 ถนนลาดพร้าว แขวงจอมพล เขตจตุจักร กรุงเทพฯ 10900',
        latitude: 13.8000,
        longitude: 100.5692,
        phone: '02-789-0123',
        imageUrl: '',
        rating: 4.3,
        tags: ['ผลิตภัณฑ์ธรรมชาติ', 'ไม่มีสารเคมี', 'เป็นมิตรกับสิ่งแวดล้อม'],
        discount: 'ลด 15% ผลิตภัณฑ์ทำความสะอาด',
        pointsRequired: 90,
        openHours: '08:30 - 20:30',
        emoji: '🧽',
      ),
    ];
    _filteredStores = List.from(_stores);
    notifyListeners();
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