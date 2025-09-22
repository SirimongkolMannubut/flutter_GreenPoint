import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static const String _userCountKey = 'total_users';
  static const String _pointsKey = 'total_points';
  static const String _plasticKey = 'total_plastic_reduced';
  static const String _activitiesKey = 'total_activities';
  static const String _qrScansKey = 'total_qr_scans';
  static const String _profileUpdatesKey = 'profile_updates';
  static const String _settingsChangesKey = 'settings_changes';
  static const String _loginCountKey = 'login_count';
  static const String _registrationCountKey = 'registration_count';

  static Future<Map<String, dynamic>> getRealTimeStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'totalUsers': prefs.getInt(_userCountKey) ?? 0,
      'totalPoints': prefs.getInt(_pointsKey) ?? 0,
      'plasticReduced': prefs.getDouble(_plasticKey) ?? 0.0,
      'totalActivities': prefs.getInt(_activitiesKey) ?? 0,
      'qrScans': prefs.getInt(_qrScansKey) ?? 0,
      'profileUpdates': prefs.getInt(_profileUpdatesKey) ?? 0,
      'settingsChanges': prefs.getInt(_settingsChangesKey) ?? 0,
      'loginCount': prefs.getInt(_loginCountKey) ?? 0,
      'registrationCount': prefs.getInt(_registrationCountKey) ?? 0,
    };
  }

  static Future<void> incrementUserCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_userCountKey) ?? 0;
    await prefs.setInt(_userCountKey, current + 1);
  }

  static Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_pointsKey) ?? 0;
    await prefs.setInt(_pointsKey, current + points);
  }

  static Future<void> addPlasticReduced(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getDouble(_plasticKey) ?? 0.0;
    await prefs.setDouble(_plasticKey, current + amount);
  }

  static Future<void> incrementActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_activitiesKey) ?? 0;
    await prefs.setInt(_activitiesKey, current + 1);
  }

  static Future<void> incrementQRScan() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_qrScansKey) ?? 0;
    await prefs.setInt(_qrScansKey, current + 1);
  }

  static Future<void> incrementProfileUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_profileUpdatesKey) ?? 0;
    await prefs.setInt(_profileUpdatesKey, current + 1);
  }

  static Future<void> incrementSettingsChange() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_settingsChangesKey) ?? 0;
    await prefs.setInt(_settingsChangesKey, current + 1);
  }

  static Future<void> incrementLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_loginCountKey) ?? 0;
    await prefs.setInt(_loginCountKey, current + 1);
  }

  static Future<void> incrementRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_registrationCountKey) ?? 0;
    await prefs.setInt(_registrationCountKey, current + 1);
  }

  static Future<List<Map<String, dynamic>>> getFeatureUsage() async {
    final stats = await getRealTimeStats();
    return [
      {'feature': 'การสมัครสมาชิก', 'count': stats['registrationCount'], 'icon': Icons.person_add},
      {'feature': 'การเข้าสู่ระบบ', 'count': stats['loginCount'], 'icon': Icons.login},
      {'feature': 'สแกน QR Code', 'count': stats['qrScans'], 'icon': Icons.qr_code_scanner},
      {'feature': 'อัปเดตโปรไฟล์', 'count': stats['profileUpdates'], 'icon': Icons.edit},
      {'feature': 'เปลี่ยนการตั้งค่า', 'count': stats['settingsChanges'], 'icon': Icons.settings},
      {'feature': 'กิจกรรมทั้งหมด', 'count': stats['totalActivities'], 'icon': Icons.eco},
    ];
  }
}