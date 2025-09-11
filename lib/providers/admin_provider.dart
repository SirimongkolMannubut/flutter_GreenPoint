import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin.dart';

class AdminProvider with ChangeNotifier {
  Admin? _currentAdmin;
  bool _isLoading = false;
  String? _error;

  Admin? get currentAdmin => _currentAdmin;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdminLoggedIn => _currentAdmin != null;

  Future<bool> loginAdmin(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate admin login - replace with actual API call
      if (email == 'admin@greenpoint.com' && password == 'admin123') {
        _currentAdmin = Admin(
          id: 'admin_001',
          email: email,
          name: 'ผู้ดูแลระบบ',
          role: 'super_admin',
          createdAt: DateTime.now(),
        );
        
        await _saveAdminSession();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logoutAdmin() async {
    _currentAdmin = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_session');
    notifyListeners();
  }

  Future<void> loadAdminSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final adminData = prefs.getString('admin_session');
      
      if (adminData != null) {
        // In real app, validate session with server
        _currentAdmin = Admin(
          id: 'admin_001',
          email: 'admin@greenpoint.com',
          name: 'ผู้ดูแลระบบ',
          role: 'super_admin',
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Error loading admin session: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAdminSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_session', _currentAdmin!.id);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}