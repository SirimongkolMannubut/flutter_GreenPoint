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