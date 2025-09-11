import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _emailNotificationsKey = 'email_notifications';

  static Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  static Future<bool> arePushNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pushNotificationsKey) ?? true;
  }

  static Future<void> setPushNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushNotificationsKey, enabled);
  }

  static Future<bool> areEmailNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emailNotificationsKey) ?? false;
  }

  static Future<void> setEmailNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailNotificationsKey, enabled);
  }

  static void showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) {
    // TODO: Implement local notifications
    debugPrint('Notification: $title - $body');
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // TODO: Implement scheduled notifications
    debugPrint('Scheduled notification: $title at $scheduledTime');
  }

  static Future<void> cancelAllNotifications() async {
    // TODO: Implement cancel all notifications
    debugPrint('All notifications cancelled');
  }

  static Future<void> requestPermissions() async {
    // TODO: Implement notification permissions request
    debugPrint('Notification permissions requested');
  }
}