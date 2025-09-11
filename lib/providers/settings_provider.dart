import 'package:flutter/material.dart';
import '../services/services.dart';


class SettingsProvider with ChangeNotifier {
  String _currentLanguage = 'th';
  bool _notificationsEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _isLoading = false;

  String get currentLanguage => _currentLanguage;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get twoFactorEnabled => _twoFactorEnabled;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentLanguage = await LocalizationService.getLanguage();
      _notificationsEnabled = await NotificationService.areNotificationsEnabled();
      _pushNotificationsEnabled = await NotificationService.arePushNotificationsEnabled();
      _emailNotificationsEnabled = await NotificationService.areEmailNotificationsEnabled();
      _biometricEnabled = await SecurityService.isBiometricEnabled();
      _twoFactorEnabled = await SecurityService.isTwoFactorEnabled();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    await LocalizationService.setLanguage(languageCode);
    await AnalyticsService.incrementSettingsChange();

    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await NotificationService.setNotificationsEnabled(enabled);
    
    if (!enabled) {
      await NotificationService.cancelAllNotifications();
    }
    
    await AnalyticsService.incrementSettingsChange();

    
    notifyListeners();
  }

  Future<void> setPushNotificationsEnabled(bool enabled) async {
    _pushNotificationsEnabled = enabled;
    await NotificationService.setPushNotificationsEnabled(enabled);
    notifyListeners();
  }

  Future<void> setEmailNotificationsEnabled(bool enabled) async {
    _emailNotificationsEnabled = enabled;
    await NotificationService.setEmailNotificationsEnabled(enabled);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    if (enabled) {
      final isAvailable = await SecurityService.checkBiometricAvailability();
      if (!isAvailable) {
        throw Exception('Biometric authentication not available');
      }
      
      final authenticated = await SecurityService.authenticateWithBiometric();
      if (!authenticated) {
        throw Exception('Biometric authentication failed');
      }
    }
    
    _biometricEnabled = enabled;
    await SecurityService.setBiometricEnabled(enabled);
    notifyListeners();
  }

  Future<void> setTwoFactorEnabled(bool enabled) async {
    _twoFactorEnabled = enabled;
    await SecurityService.setTwoFactorEnabled(enabled);
    notifyListeners();
  }

  String translate(String key) {
    return LocalizationService.translate(key, _currentLanguage);
  }

  List<Map<String, String>> getSupportedLanguages() {
    return LocalizationService.getSupportedLanguages();
  }

  Future<void> resetAllSettings() async {
    _currentLanguage = 'th';
    _notificationsEnabled = true;
    _pushNotificationsEnabled = true;
    _emailNotificationsEnabled = false;
    _biometricEnabled = false;
    _twoFactorEnabled = false;

    await LocalizationService.setLanguage(_currentLanguage);
    await NotificationService.setNotificationsEnabled(_notificationsEnabled);
    await NotificationService.setPushNotificationsEnabled(_pushNotificationsEnabled);
    await NotificationService.setEmailNotificationsEnabled(_emailNotificationsEnabled);
    await SecurityService.setBiometricEnabled(_biometricEnabled);
    await SecurityService.setTwoFactorEnabled(_twoFactorEnabled);

    notifyListeners();
  }
}