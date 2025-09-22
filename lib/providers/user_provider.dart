import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/data/storage_service.dart';
import '../services/data/analytics_service.dart';


class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  
  int get totalPoints => _user?.totalPoints ?? 0;
  int get plasticReduced => _user?.plasticReduced ?? 0;
  int get level => _user?.level ?? 1;
  String get levelName => _getLevelName(level);
  String get userId => _user?.id ?? '';
  int get totalActivities => _user?.totalActivities ?? 0;
  int get qrScans => _user?.qrScans ?? 0;

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
        _user = null;
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
      _user = null;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    try {
      debugPrint('Login attempt: $email');
      
      // Initialize demo users if no users exist
      await _initializeDemoUsers();
      
      // Get all users from storage
      final allUsers = await StorageService.getAllUsers();
      debugPrint('Total users in storage: ${allUsers.length}');
      
      // Debug: Print all users (without passwords)
      for (var user in allUsers) {
        debugPrint('User: ${user['email']} - ${user['name']}');
      }
      
      // Find user with matching email and password
      final matchingUser = allUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => <String, dynamic>{},
      );
      
      if (matchingUser.isNotEmpty) {
        debugPrint('Login successful for: ${matchingUser['email']}');
        _user = User.fromJson(matchingUser);
        await StorageService.setCurrentUser(matchingUser);
        await AnalyticsService.incrementLogin();
        notifyListeners(); // แจ้งให้ UI อัปเดต
        return true;
      } else {
        debugPrint('Login failed: No matching user found');
        
        // Fallback: Create temporary user for any login attempt
        if (email.isNotEmpty && password.isNotEmpty) {
          debugPrint('Creating temporary user for login');
          final tempUser = {
            'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
            'name': 'ผู้ใช้ชั่วคราว',
            'email': email,
            'password': password,
            'totalPoints': 0,
            'plasticReduced': 0,
            'level': 1,
            'joinDate': DateTime.now().toIso8601String(),
            'achievements': [],
            'profileImagePath': '',
          };
          
          _user = User.fromJson(tempUser);
          await StorageService.addUser(tempUser);
          await StorageService.setCurrentUser(tempUser);
          notifyListeners(); // แจ้งให้ UI อัปเดต
          return true;
        }
        
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error logging in: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    } finally {
      setLoading(false);
    }
  }

  String _generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'GP${timestamp.toString().substring(8)}$random';
  }

  Future<void> _initializeDemoUsers() async {
    try {
      final allUsers = await StorageService.getAllUsers();
      if (allUsers.isEmpty) {
        // Add demo user
        final demoUser = {
          'id': _generateUserId(),
          'name': 'ผู้ใช้ทดสอบ',
          'email': 'test@greenpoint.com',
          'password': '123456',
          'totalPoints': 150,
          'plasticReduced': 25,
          'level': 2,
          'joinDate': DateTime.now().toIso8601String(),
          'achievements': [],
          'profileImagePath': '',
        };
        await StorageService.addUser(demoUser);
      }
    } catch (e) {
      debugPrint('Error initializing demo users: $e');
    }
  }

  Future<bool> register(String name, String email, String password) async {
    setLoading(true);
    try {
      // Check if user already exists
      final allUsers = await StorageService.getAllUsers();
      final existingUser = allUsers.firstWhere(
        (user) => user['email'] == email,
        orElse: () => <String, dynamic>{},
      );
      
      if (existingUser.isNotEmpty) {
        return false; // User already exists
      }
      
      _user = User(
        id: _generateUserId(),
        name: name,
        email: email,
        totalPoints: 0,
        plasticReduced: 0,
        level: 1,
        joinDate: DateTime.now(),
        achievements: [],
      );
      
      // Save user with password
      final userDataWithPassword = _user!.toJson();
      userDataWithPassword['password'] = password;
      
      await StorageService.addUser(userDataWithPassword);
      await StorageService.setCurrentUser(userDataWithPassword);
      await AnalyticsService.incrementUserCount();
      await AnalyticsService.incrementRegistration();
      notifyListeners(); // แจ้งให้ UI อัปเดต
      
      return true;
    } catch (e) {
      debugPrint('Error registering: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> loginWithGoogle(String name, String email, String googleId) async {
    setLoading(true);
    try {
      // Check if Google user already exists
      final allUsers = await StorageService.getAllUsers();
      final existingUser = allUsers.firstWhere(
        (user) => user['email'] == email || user['id'] == googleId,
        orElse: () => <String, dynamic>{},
      );
      
      if (existingUser.isNotEmpty) {
        // User exists, login
        _user = User.fromJson(existingUser);
        await StorageService.setCurrentUser(existingUser);
      } else {
        // New Google user, create account
        _user = User(
          id: googleId,
          name: name,
          email: email,
          totalPoints: 0,
          plasticReduced: 0,
          level: 1,
          joinDate: DateTime.now(),
          achievements: [],
        );
        
        final userDataWithPassword = _user!.toJson();
        userDataWithPassword['password'] = 'google_auth'; // Special marker for Google users
        
        await StorageService.addUser(userDataWithPassword);
        await StorageService.setCurrentUser(userDataWithPassword);
      }
      
      await AnalyticsService.incrementLogin();
      notifyListeners(); // แจ้งให้ UI อัปเดต
      return true;
    } catch (e) {
      debugPrint('Google login error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  bool get isLoggedIn => _user != null;

  Future<void> saveUser() async {
    if (_user != null) {
      await StorageService.setCurrentUser(_user!.toJson());
      await StorageService.updateUser(_user!.toJson());
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

  Future<bool> deductPoints(int points) async {
    if (_user != null && _user!.totalPoints >= points) {
      final newPoints = _user!.totalPoints - points;
      final newLevel = _calculateLevel(newPoints);
      
      _user = _user!.copyWith(
        totalPoints: newPoints,
        level: newLevel,
      );
      
      await saveUser();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateProfile(String name, String email) async {
    if (_user != null) {
      _user = _user!.copyWith(name: name, email: email);
      await saveUser();
      notifyListeners();
    }
  }

  Future<void> updateUserName(String name) async {
    if (_user != null) {
      _user = _user!.copyWith(name: name);
      await saveUser();
      notifyListeners();
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    if (_user != null) {
      _user = _user!.copyWith(profileImagePath: imagePath);
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
    // ลบเฉพาะ current user ไม่ลบข้อมูลผู้ใช้ทั้งหมด
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
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