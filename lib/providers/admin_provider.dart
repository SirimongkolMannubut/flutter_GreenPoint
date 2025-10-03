import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api/admin_api_service.dart';
import '../services/data/storage_service.dart';

class AdminProvider with ChangeNotifier {
  Admin? _currentAdmin;
  List<User> _allUsers = [];
  bool _isLoading = false;
  String? _error;
  bool _rememberMe = false;
  String _savedEmail = '';
  String _savedPassword = '';

  Admin? get currentAdmin => _currentAdmin;
  List<User> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdminLoggedIn => _currentAdmin != null;
  bool get rememberMe => _rememberMe;
  String get savedEmail => _savedEmail;
  String get savedPassword => _savedPassword;

  Future<bool> loginAdmin(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try API login first
      try {
        final response = await AdminApiService.login(email, password);
        if (response['admin'] != null) {
          _currentAdmin = Admin.fromJson(response['admin']);
          await _saveAdminSession();
          await loadAllUsers();
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } catch (apiError) {
        debugPrint('API admin login failed: $apiError');
      }
      
      // Fallback to local admin
      if (email == 'admin@greenpoint.com' && password == 'admin123') {
        _currentAdmin = Admin(
          id: 'admin_001',
          email: email,
          name: 'ผู้ดูแลระบบ',
          role: 'super_admin',
          createdAt: DateTime.now(),
        );
        
        await _saveAdminSession();
        await loadAllUsers();
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

  Future<void> loadAllUsers() async {
    try {
      // Try API first
      try {
        final usersData = await AdminApiService.getAllUsers();
        _allUsers = usersData.map((userData) => User.fromJson(userData)).toList();
        
        // Save to local storage
        for (var userData in usersData) {
          await StorageService.updateUser(userData);
        }
      } catch (apiError) {
        debugPrint('API load users failed: $apiError');
        // Fallback to local storage
        final localUsers = await StorageService.getAllUsers();
        _allUsers = localUsers.map((userData) => User.fromJson(userData)).toList();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading users: $e');
    }
  }
  
  Future<bool> addPointsToUser(String userId, int points, String reason) async {
    try {
      // Try API first
      try {
        await AdminApiService.addPointsToUser(userId, points, reason);
      } catch (apiError) {
        debugPrint('API add points failed: $apiError');
      }
      
      // Update local user
      final userIndex = _allUsers.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        final user = _allUsers[userIndex];
        final updatedUser = user.copyWith(
          totalPoints: user.totalPoints + points,
        );
        _allUsers[userIndex] = updatedUser;
        
        // Save to local storage
        await StorageService.updateUser(updatedUser.toJson());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding points: $e');
      return false;
    }
  }
  
  Future<bool> deductPointsFromUser(String userId, int points, String reason) async {
    try {
      // Try API first
      try {
        await AdminApiService.deductPointsFromUser(userId, points, reason);
      } catch (apiError) {
        debugPrint('API deduct points failed: $apiError');
      }
      
      // Update local user
      final userIndex = _allUsers.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        final user = _allUsers[userIndex];
        if (user.totalPoints >= points) {
          final updatedUser = user.copyWith(
            totalPoints: user.totalPoints - points,
          );
          _allUsers[userIndex] = updatedUser;
          
          // Save to local storage
          await StorageService.updateUser(updatedUser.toJson());
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error deducting points: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) {
    try {
      // Try API delete first
      // TODO: Add API call when available
      
      // Remove from local list
      _allUsers.removeWhere((user) => user.id == userId);
      
      // Remove from local storage
      StorageService.deleteUser(userId);
      
      notifyListeners();
      return Future.value(true);
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return Future.value(false);
    }
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_saved_email', email);
    await prefs.setString('admin_saved_password', password);
    await prefs.setBool('admin_remember_me', true);
    _savedEmail = email;
    _savedPassword = password;
    _rememberMe = true;
  }

  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('admin_remember_me') ?? false;
    if (_rememberMe) {
      _savedEmail = prefs.getString('admin_saved_email') ?? '';
      _savedPassword = prefs.getString('admin_saved_password') ?? '';
    }
    notifyListeners();
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_saved_email');
    await prefs.remove('admin_saved_password');
    await prefs.remove('admin_remember_me');
    _savedEmail = '';
    _savedPassword = '';
    _rememberMe = false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}