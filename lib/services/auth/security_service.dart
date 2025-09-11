import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SecurityService {
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _twoFactorEnabledKey = 'two_factor_enabled';
  static const String _passwordHashKey = 'password_hash';
  static const String _lastLoginKey = 'last_login';
  static const String _loginAttemptsKey = 'login_attempts';
  static const String _lockoutTimeKey = 'lockout_time';

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  static Future<bool> isTwoFactorEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_twoFactorEnabledKey) ?? false;
  }

  static Future<void> setTwoFactorEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_twoFactorEnabledKey, enabled);
  }

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> savePasswordHash(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPassword = hashPassword(password);
    await prefs.setString(_passwordHashKey, hashedPassword);
  }

  static Future<bool> verifyPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString(_passwordHashKey);
    if (savedHash == null) return true; // No password set
    
    final inputHash = hashPassword(password);
    return savedHash == inputHash;
  }

  static Future<void> recordLoginAttempt(bool successful) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (successful) {
      await prefs.remove(_loginAttemptsKey);
      await prefs.remove(_lockoutTimeKey);
      await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
    } else {
      final attempts = prefs.getInt(_loginAttemptsKey) ?? 0;
      await prefs.setInt(_loginAttemptsKey, attempts + 1);
      
      if (attempts + 1 >= 5) {
        final lockoutTime = DateTime.now().add(const Duration(minutes: 15));
        await prefs.setString(_lockoutTimeKey, lockoutTime.toIso8601String());
      }
    }
  }

  static Future<bool> isAccountLocked() async {
    final prefs = await SharedPreferences.getInstance();
    final lockoutTimeString = prefs.getString(_lockoutTimeKey);
    
    if (lockoutTimeString == null) return false;
    
    final lockoutTime = DateTime.parse(lockoutTimeString);
    final now = DateTime.now();
    
    if (now.isAfter(lockoutTime)) {
      await prefs.remove(_lockoutTimeKey);
      await prefs.remove(_loginAttemptsKey);
      return false;
    }
    
    return true;
  }

  static Future<int> getRemainingLockoutMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final lockoutTimeString = prefs.getString(_lockoutTimeKey);
    
    if (lockoutTimeString == null) return 0;
    
    final lockoutTime = DateTime.parse(lockoutTimeString);
    final now = DateTime.now();
    
    if (now.isAfter(lockoutTime)) return 0;
    
    return lockoutTime.difference(now).inMinutes;
  }

  static Future<int> getFailedLoginAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_loginAttemptsKey) ?? 0;
  }

  static Future<DateTime?> getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginString = prefs.getString(_lastLoginKey);
    
    if (lastLoginString == null) return null;
    
    return DateTime.parse(lastLoginString);
  }

  static Future<bool> checkBiometricAvailability() async {
    // TODO: Implement biometric availability check
    return true;
  }

  static Future<bool> authenticateWithBiometric() async {
    // TODO: Implement biometric authentication
    return true;
  }

  static String generateTwoFactorCode() {
    // Generate 6-digit code
    final random = DateTime.now().millisecondsSinceEpoch % 1000000;
    return random.toString().padLeft(6, '0');
  }

  static Future<void> clearSecurityData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_passwordHashKey);
    await prefs.remove(_loginAttemptsKey);
    await prefs.remove(_lockoutTimeKey);
    await prefs.remove(_lastLoginKey);
  }
}