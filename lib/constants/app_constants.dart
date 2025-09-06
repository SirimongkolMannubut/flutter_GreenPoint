import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'GreenPoint';
  static const String appVersion = '1.0.0';
  
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF81C784);
  
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  
  static const List<String> activityCategories = [
    'ถุงผ้า',
    'กล่องอาหาร',
    'หลอดไผ่',
    'ขวดน้ำ',
    'การรีไซเคิล',
    'การแยกขยะ',
  ];
  
  static const Map<String, int> levelThresholds = {
    'Bronze': 0,
    'Silver': 100,
    'Gold': 500,
    'Platinum': 1000,
    'Diamond': 2500,
  };
  
  static const List<String> achievements = [
    'เริ่มต้นดี',
    'นักรักษ์โลก',
    'ผู้เชี่ยวชาญ',
    'นักสู้พลาสติก',
    'ฮีโร่สิ่งแวดล้อม',
  ];
}