class ApiConfig {
  static const String baseUrl = 'https://api.greenpoint.app/v1';
  static const String localUrl = 'http://localhost:3000/api/v1';
  
  // ใช้ local สำหรับ development
  static String get currentUrl => localUrl;
  
  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/user/profile';
  static const String addPoints = '/user/points';
  static const String stores = '/stores';
  static const String redeemReward = '/rewards/redeem';
  static const String adminUsers = '/admin/users';
  static const String adminStores = '/admin/stores';
  
  // Request timeout
  static const Duration timeout = Duration(seconds: 30);
}