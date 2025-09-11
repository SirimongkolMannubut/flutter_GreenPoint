import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

class ApiUserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  
  int get totalPoints => _user?.totalPoints ?? 0;
  int get plasticReduced => _user?.plasticReduced ?? 0;
  int get level => _user?.level ?? 1;
  String get levelName => _getLevelName(level);
  String get userId => _user?.id ?? '';

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadUser() async {
    setLoading(true);
    try {
      // ลองโหลดจาก API ก่อน
      final apiUser = await ApiService.getProfile();
      if (apiUser != null) {
        _user = apiUser;
        await StorageService.saveUser(_user!.toJson());
      } else {
        // Fallback ไปใช้ local storage
        final userData = await StorageService.getUser();
        if (userData != null) {
          _user = User.fromJson(userData);
        }
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    try {
      final result = await ApiService.login(email, password);
      if (result != null && result['user'] != null) {
        _user = User.fromJson(result['user']);
        await StorageService.saveUser(_user!.toJson());
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    setLoading(true);
    try {
      final result = await ApiService.register(name, email, password);
      if (result != null && result['user'] != null) {
        _user = User.fromJson(result['user']);
        await StorageService.saveUser(_user!.toJson());
        return true;
      }
    } catch (e) {
      debugPrint('Register error: $e');
    } finally {
      setLoading(false);
    }
    return false;
  }

  Future<void> addPoints(int points, int plasticReduction, String activity) async {
    if (_user != null) {
      try {
        final success = await ApiService.addPoints(points, plasticReduction, activity);
        if (success) {
          // อัปเดต local data
          final newPoints = _user!.totalPoints + points;
          final newPlasticReduced = _user!.plasticReduced + plasticReduction;
          final newLevel = _calculateLevel(newPoints);
          
          _user = _user!.copyWith(
            totalPoints: newPoints,
            plasticReduced: newPlasticReduced,
            level: newLevel,
          );
          
          await StorageService.saveUser(_user!.toJson());
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Add points error: $e');
      }
    }
  }

  Future<bool> deductPoints(int points) async {
    if (_user != null && _user!.totalPoints >= points) {
      try {
        // ใช้ API สำหรับ redeem
        final success = await ApiService.redeemReward('', points);
        if (success) {
          final newPoints = _user!.totalPoints - points;
          final newLevel = _calculateLevel(newPoints);
          
          _user = _user!.copyWith(
            totalPoints: newPoints,
            level: newLevel,
          );
          
          await StorageService.saveUser(_user!.toJson());
          notifyListeners();
          return true;
        }
      } catch (e) {
        debugPrint('Deduct points error: $e');
      }
    }
    return false;
  }

  Future<void> updateProfile(String name, String email) async {
    if (_user != null) {
      try {
        final success = await ApiService.updateProfile(name, email);
        if (success) {
          _user = _user!.copyWith(name: name, email: email);
          await StorageService.saveUser(_user!.toJson());
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Update profile error: $e');
      }
    }
  }

  int _calculateLevel(int points) {
    if (points >= 2500) return 5;
    if (points >= 1000) return 4;
    if (points >= 500) return 3;
    if (points >= 100) return 2;
    return 1;
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1: return 'Bronze';
      case 2: return 'Silver';
      case 3: return 'Gold';
      case 4: return 'Platinum';
      case 5: return 'Diamond';
      default: return 'Bronze';
    }
  }

  double getLevelProgress() {
    final currentPoints = totalPoints;
    final currentLevel = level;
    
    if (currentLevel >= 5) return 1.0;
    
    final thresholds = [0, 100, 500, 1000, 2500];
    final currentThreshold = thresholds[currentLevel - 1];
    final nextThreshold = thresholds[currentLevel];
    
    return (currentPoints - currentThreshold) / (nextThreshold - currentThreshold);
  }

  Future<void> logout() async {
    _user = null;
    ApiService.logout();
    await StorageService.clearAll();
    notifyListeners();
  }
}