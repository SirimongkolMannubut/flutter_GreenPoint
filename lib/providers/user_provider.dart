import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  
  int get totalPoints => _user?.totalPoints ?? 0;
  int get plasticReduced => _user?.plasticReduced ?? 0;
  int get level => _user?.level ?? 1;
  String get levelName => _getLevelName(level);

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadUser() async {
    setLoading(true);
    try {
      final userData = await StorageService.getUser();
      if (userData != null) {
        _user = User.fromJson(userData);
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> login(String email) async {
    setLoading(true);
    try {
      final userData = await StorageService.getUser();
      if (userData != null && userData['email'] == email) {
        _user = User.fromJson(userData);
      } else {
        _user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'ผู้ใช้งาน',
          email: email,
          totalPoints: 0,
          plasticReduced: 0,
          level: 1,
          joinDate: DateTime.now(),
          achievements: [],
        );
      }
      await saveUser();
    } catch (e) {
      debugPrint('Error logging in: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> register(String name, String email) async {
    setLoading(true);
    try {
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        totalPoints: 0,
        plasticReduced: 0,
        level: 1,
        joinDate: DateTime.now(),
        achievements: [],
      );
      await saveUser();
    } catch (e) {
      debugPrint('Error registering: $e');
    } finally {
      setLoading(false);
    }
  }

  bool get isLoggedIn => _user != null;

  Future<void> saveUser() async {
    if (_user != null) {
      await StorageService.saveUser(_user!.toJson());
    }
  }

  Future<void> addPoints(int points, int plasticReduction) async {
    if (_user != null) {
      final newPoints = _user!.totalPoints + points;
      final newPlasticReduced = _user!.plasticReduced + plasticReduction;
      final newLevel = _calculateLevel(newPoints);
      
      _user = _user!.copyWith(
        totalPoints: newPoints,
        plasticReduced: newPlasticReduced,
        level: newLevel,
      );
      
      await saveUser();
      notifyListeners();
    }
  }

  Future<void> updateProfile(String name, String email) async {
    if (_user != null) {
      _user = _user!.copyWith(name: name, email: email);
      await saveUser();
      notifyListeners();
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
    await StorageService.clearAll();
    notifyListeners();
  }

  List<Map<String, dynamic>> getActivityHistory() {
    return [
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'activity': 'ใช้ถุงผ้า',
        'points': 10,
        'icon': '🛍️',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'activity': 'ใช้กล่องอาหาร',
        'points': 15,
        'icon': '🍱',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'activity': 'ใช้หลอดไผ่',
        'points': 8,
        'icon': '🥤',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'activity': 'ไม่ใช้ถุงพลาสติก',
        'points': 20,
        'icon': '🚫',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'activity': 'ใช้ขวดน้ำส่วนตัว',
        'points': 12,
        'icon': '💧',
      },
    ];
  }
}