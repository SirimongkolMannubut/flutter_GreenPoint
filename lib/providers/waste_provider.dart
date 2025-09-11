import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class WasteProvider with ChangeNotifier {
  List<WasteEntry> _entries = [];
  bool _isLoading = false;

  List<WasteEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  List<WasteEntry> get todayEntries {
    final today = DateTime.now();
    return _entries.where((entry) {
      return entry.date.year == today.year &&
             entry.date.month == today.month &&
             entry.date.day == today.day;
    }).toList();
  }

  double get todayTotalWeight => todayEntries.fold(0.0, (sum, entry) => sum + entry.totalWeight);
  double get todayTotalCo2Saved => todayEntries.fold(0.0, (sum, entry) => sum + entry.totalCo2Saved);
  int get todayTotalPoints => todayEntries.fold(0, (sum, entry) => sum + entry.totalPoints);

  Map<WasteType, double> get wasteTypeStats {
    final stats = <WasteType, double>{};
    for (final entry in _entries) {
      for (final item in entry.items) {
        stats[item.type] = (stats[item.type] ?? 0) + item.weight;
      }
    }
    return stats;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadEntries() async {
    setLoading(true);
    try {
      final entriesData = await StorageService.getWasteEntries();
      _entries = entriesData.map((data) => WasteEntry.fromJson(data)).toList();
      _entries.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      debugPrint('Error loading waste entries: $e');
      _entries = [];
    } finally {
      setLoading(false);
    }
  }

  Future<void> addEntry(WasteEntry entry) async {
    _entries.insert(0, entry);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> updateEntry(WasteEntry updatedEntry) async {
    final index = _entries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
      await _saveEntries();
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String entryId) async {
    _entries.removeWhere((entry) => entry.id == entryId);
    await _saveEntries();
    notifyListeners();
  }

  List<WasteEntry> getEntriesForDate(DateTime date) {
    return _entries.where((entry) {
      return entry.date.year == date.year &&
             entry.date.month == date.month &&
             entry.date.day == date.day;
    }).toList();
  }

  Future<void> _saveEntries() async {
    final entriesData = _entries.map((entry) => entry.toJson()).toList();
    await StorageService.saveWasteEntries(entriesData);
  }

  List<WasteItem> getAvailableWasteItems() {
    return [
      // พลาสติก
      WasteItem(
        id: 'plastic_bottle',
        name: 'ขวดพลาสติก',
        type: WasteType.plastic,
        weight: 25.0,
        co2Impact: 0.082,
        points: 5,
        icon: Icons.local_drink,
        color: Colors.blue,
        description: 'ขวดน้ำพลาสติก PET',
        disposalTip: 'ล้างให้สะอาดก่อนทิ้งถังรีไซเคิล',
      ),
      WasteItem(
        id: 'plastic_bag',
        name: 'ถุงพลาสติก',
        type: WasteType.plastic,
        weight: 6.0,
        co2Impact: 0.033,
        points: 3,
        icon: Icons.shopping_bag,
        color: Colors.blue[300]!,
        description: 'ถุงพลาสติกใส/สี',
        disposalTip: 'นำไปจุดรับถุงพลาสติกในห้าง',
      ),
      WasteItem(
        id: 'food_container',
        name: 'กล่องอาหาร',
        type: WasteType.plastic,
        weight: 15.0,
        co2Impact: 0.055,
        points: 4,
        icon: Icons.lunch_dining,
        color: Colors.orange,
        description: 'กล่องอาหารพลาสติก',
        disposalTip: 'ล้างเศษอาหารออกก่อนทิ้ง',
      ),

      // กระดาษ
      WasteItem(
        id: 'newspaper',
        name: 'หนังสือพิมพ์',
        type: WasteType.paper,
        weight: 50.0,
        co2Impact: 0.165,
        points: 8,
        icon: Icons.newspaper,
        color: Colors.brown,
        description: 'หนังสือพิมพ์/นิตยสาร',
        disposalTip: 'แยกออกจากกระดาษอื่น',
      ),
      WasteItem(
        id: 'cardboard',
        name: 'กล่องกระดาษ',
        type: WasteType.paper,
        weight: 100.0,
        co2Impact: 0.33,
        points: 10,
        icon: Icons.inventory_2,
        color: Colors.brown[400]!,
        description: 'กล่องกระดาษลูกฟูก',
        disposalTip: 'พับให้เรียบก่อนทิ้ง',
      ),

      // แก้ว
      WasteItem(
        id: 'glass_bottle',
        name: 'ขวดแก้ว',
        type: WasteType.glass,
        weight: 200.0,
        co2Impact: 0.314,
        points: 12,
        icon: Icons.wine_bar,
        color: Colors.green,
        description: 'ขวดแก้วใส/สี',
        disposalTip: 'ล้างให้สะอาดและระวังของแหลมคม',
      ),

      // โลหะ
      WasteItem(
        id: 'aluminum_can',
        name: 'กระป๋องอลูมิเนียม',
        type: WasteType.metal,
        weight: 15.0,
        co2Impact: 0.128,
        points: 8,
        icon: Icons.local_cafe,
        color: Colors.grey,
        description: 'กระป๋องเครื่องดื่ม',
        disposalTip: 'ล้างให้สะอาดก่อนทิ้ง',
      ),

      // อิเล็กทรอนิกส์
      WasteItem(
        id: 'battery',
        name: 'ถ่านไฟฉาย',
        type: WasteType.electronic,
        weight: 25.0,
        co2Impact: 0.045,
        points: 15,
        icon: Icons.battery_full,
        color: Colors.red,
        description: 'ถ่านไฟฉายทุกชนิด',
        disposalTip: 'ทิ้งที่จุดรับถ่านเท่านั้น',
      ),
      WasteItem(
        id: 'phone',
        name: 'โทรศัพท์เก่า',
        type: WasteType.electronic,
        weight: 150.0,
        co2Impact: 0.85,
        points: 50,
        icon: Icons.phone_android,
        color: Colors.purple,
        description: 'โทรศัพท์มือถือเก่า',
        disposalTip: 'ลบข้อมูลก่อนนำไปรีไซเคิล',
      ),

      // อินทรีย์
      WasteItem(
        id: 'food_waste',
        name: 'เศษอาหาร',
        type: WasteType.organic,
        weight: 200.0,
        co2Impact: 0.42,
        points: 6,
        icon: Icons.restaurant,
        color: Colors.green[600]!,
        description: 'เศษอาหารและผักผลไม้',
        disposalTip: 'แยกทิ้งถังขยะเปียก หรือทำปุ๋ยหมัก',
      ),

      // ผ้า
      WasteItem(
        id: 'old_clothes',
        name: 'เสื้อผ้าเก่า',
        type: WasteType.textile,
        weight: 300.0,
        co2Impact: 0.95,
        points: 20,
        icon: Icons.checkroom,
        color: Colors.pink,
        description: 'เสื้อผ้าที่ไม่ใช้แล้ว',
        disposalTip: 'บริจาคหรือนำไปรีไซเคิล',
      ),

      // อันตราย
      WasteItem(
        id: 'paint_can',
        name: 'กระป๋องสี',
        type: WasteType.hazardous,
        weight: 500.0,
        co2Impact: 1.2,
        points: 25,
        icon: Icons.format_paint,
        color: Colors.red[700]!,
        description: 'กระป๋องสี/สารเคมี',
        disposalTip: 'ทิ้งที่จุดรับขยะอันตรายเท่านั้น',
      ),
    ];
  }
}