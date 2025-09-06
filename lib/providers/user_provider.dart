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
      } else {
        _user = User(
          id: 'user_001',
          name: 'ผู้ใช้งาน',
          email: 'user@greenpoint.com',
          totalPoints: 0,
          plasticReduced: 0,
          level: 1,
          joinDate: DateTime.now(),
          achievements: [],
        );
        await saveUser();
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      setLoading(false);
    }
  }

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
}