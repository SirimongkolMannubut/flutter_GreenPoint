import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _usersKey = 'all_users_data';
  static const String _activitiesKey = 'activities_data';
  static const String _settingsKey = 'settings_data';

  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      if (userData != null && userData.isNotEmpty) {
        final decoded = json.decode(userData);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  static Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      if (userData.isEmpty) return false;
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(userData);
      return await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activitiesData = prefs.getString(_activitiesKey);
      if (activitiesData != null) {
        final List<dynamic> decoded = json.decode(activitiesData);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error getting activities data: $e');
    }
    return [];
  }

  static Future<bool> saveActivities(List<Map<String, dynamic>> activities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activitiesJson = json.encode(activities);
      return await prefs.setString(_activitiesKey, activitiesJson);
    } catch (e) {
      print('Error saving activities data: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsData = prefs.getString(_settingsKey);
      if (settingsData != null) {
        return json.decode(settingsData);
      }
    } catch (e) {
      print('Error getting settings data: $e');
    }
    return null;
  }

  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings);
      return await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings data: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getWasteEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasteData = prefs.getString('waste_entries');
      if (wasteData != null) {
        final List<dynamic> decoded = json.decode(wasteData);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error getting waste entries: $e');
    }
    return [];
  }

  static Future<bool> saveWasteEntries(List<Map<String, dynamic>> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = json.encode(entries);
      return await prefs.setString('waste_entries', entriesJson);
    } catch (e) {
      print('Error saving waste entries: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString(_usersKey);
      if (usersData != null) {
        final List<dynamic> decoded = json.decode(usersData);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error getting all users: $e');
    }
    return [];
  }

  static Future<bool> addUser(Map<String, dynamic> userData) async {
    try {
      final allUsers = await getAllUsers();
      allUsers.add(userData);
      final prefs = await SharedPreferences.getInstance();
      final usersJson = json.encode(allUsers);
      return await prefs.setString(_usersKey, usersJson);
    } catch (e) {
      print('Error adding user: $e');
      return false;
    }
  }

  static Future<bool> updateUser(Map<String, dynamic> userData) async {
    try {
      final allUsers = await getAllUsers();
      final userIndex = allUsers.indexWhere((user) => user['id'] == userData['id']);
      
      if (userIndex != -1) {
        allUsers[userIndex] = userData;
        final prefs = await SharedPreferences.getInstance();
        final usersJson = json.encode(allUsers);
        return await prefs.setString(_usersKey, usersJson);
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  static Future<bool> setCurrentUser(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(userData);
      return await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error setting current user: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getStores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storesData = prefs.getString('stores_data');
      if (storesData != null) {
        final List<dynamic> decoded = json.decode(storesData);
        return decoded.map((store) => {
          'id': store['id'] ?? '',
          'name': store['name'] ?? '',
          'description': store['description'] ?? '',
          'category': store['category'] ?? 'ร้านค้าทั่วไป',
          'address': store['address'] ?? '',
          'phone': store['phone'] ?? '',
          'imageUrl': store['imageUrl'] ?? '',
          'rating': (store['rating'] ?? 4.0).toDouble(),
          'distance': (store['distance'] ?? 0.0).toDouble(),
          'isOpen': store['isOpen'] ?? true,
          'tags': List<String>.from(store['tags'] ?? []),
          'latitude': (store['latitude'] ?? 0.0).toDouble(),
          'longitude': (store['longitude'] ?? 0.0).toDouble(),
        }).toList();
      }
    } catch (e) {
      print('Error getting stores: $e');
    }
    return _getDefaultStores();
  }

  static Future<bool> addStore(dynamic store) async {
    try {
      final stores = await getStores();
      stores.add(store);
      final prefs = await SharedPreferences.getInstance();
      final storesJson = json.encode(stores);
      return await prefs.setString('stores_data', storesJson);
    } catch (e) {
      print('Error adding store: $e');
      return false;
    }
  }

  static List<dynamic> _getDefaultStores() {
    return [
      {
        'id': 'store_001',
        'name': 'Green Café',
        'description': 'คาเฟ่เพื่อสิ่งแวดล้อม ไม่ใช้ถุงพลาสติก',
        'category': 'คาเฟ่',
        'address': '123 ถนนสีเขียว เขตธรรมชาติ กรุงเทพฯ',
        'phone': '02-123-4567',
        'imageUrl': '',
        'rating': 4.5,
        'distance': 0.8,
        'isOpen': true,
        'tags': ['เป็นมิตรกับสิ่งแวดล้อม', 'ไม่ใช้พลาสติก', 'อาหารออร์แกนิค'],
        'latitude': 13.7563,
        'longitude': 100.5018,
      },
      {
        'id': 'store_002',
        'name': 'Eco Market',
        'description': 'ซูเปอร์มาร์เก็ตสีเขียว สินค้าเป็นมิตรกับสิ่งแวดล้อม',
        'category': 'ซูเปอร์มาร์เก็ต',
        'address': '456 ถนนรีไซเคิล เขตสะอาด กรุงเทพฯ',
        'phone': '02-234-5678',
        'imageUrl': '',
        'rating': 4.2,
        'distance': 1.2,
        'isOpen': true,
        'tags': ['สินค้าออร์แกนิค', 'ถุงผ้า', 'รีไซเคิล'],
        'latitude': 13.7463,
        'longitude': 100.5118,
      },
    ];
  }

  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }
}