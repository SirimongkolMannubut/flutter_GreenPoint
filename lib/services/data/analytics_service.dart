import 'package:flutter/material.dart';
import 'api_service.dart';

class AnalyticsService {
  static Future<Map<String, dynamic>> getRealTimeStats() async {
    try {
      final response = await ApiService.get('/admin/stats');
      return response;
    } catch (e) {
      return {
        'totalUsers': 0,
        'totalPoints': 0,
        'plasticReduced': 0.0,
        'totalActivities': 0,
        'qrScans': 0,
        'profileUpdates': 0,
        'settingsChanges': 0,
        'loginCount': 0,
        'registrationCount': 0,
      };
    }
  }

  static Future<void> incrementUserCount() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'users'});
    } catch (e) {
      print('Error incrementing user count: $e');
    }
  }

  static Future<void> addPoints(int points) async {
    try {
      await ApiService.post('/admin/stats/add-points', {'points': points});
    } catch (e) {
      print('Error adding points: $e');
    }
  }

  static Future<void> addPlasticReduced(double amount) async {
    try {
      await ApiService.post('/admin/stats/add-plastic', {'amount': amount});
    } catch (e) {
      print('Error adding plastic reduced: $e');
    }
  }

  static Future<void> incrementActivity() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'activities'});
    } catch (e) {
      print('Error incrementing activity: $e');
    }
  }

  static Future<void> incrementQRScan() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'qrScans'});
    } catch (e) {
      print('Error incrementing QR scan: $e');
    }
  }

  static Future<void> incrementProfileUpdate() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'profileUpdates'});
    } catch (e) {
      print('Error incrementing profile update: $e');
    }
  }

  static Future<void> incrementSettingsChange() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'settingsChanges'});
    } catch (e) {
      print('Error incrementing settings change: $e');
    }
  }

  static Future<void> incrementLogin() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'loginCount'});
    } catch (e) {
      print('Error incrementing login: $e');
    }
  }

  static Future<void> incrementRegistration() async {
    try {
      await ApiService.post('/admin/stats/increment', {'type': 'registrationCount'});
    } catch (e) {
      print('Error incrementing registration: $e');
    }
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