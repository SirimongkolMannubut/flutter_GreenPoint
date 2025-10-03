class ApiConfig {
  static const String baseUrl = 'https://haruki-api.vercel.app';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  
  // User endpoints
  static const String users = '/users';
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  
  // Store endpoints
  static const String stores = '/stores';
  static const String addStore = '/stores';
  
  // Points endpoints
  static const String addPoints = '/users/points';
  static const String deductPoints = '/users/points/deduct';
  
  // Analytics endpoints
  static const String analytics = '/analytics';
  
  // Upload endpoints
  static const String uploadProfile = '/upload/profile';
  
  // Admin endpoints
  static const String adminLogin = '/admin/login';
  static const String adminUsers = '/admin/users';
  static const String adminAddPoints = '/admin/users/points';
  static const String adminDeductPoints = '/admin/users/points/deduct';
  
  // Waste endpoints
  static const String wasteEntries = '/waste';
  static const String addWasteEntry = '/waste';
  
  // Analytics endpoints
  static const String getAnalytics = '/analytics';
  
  // Settings endpoints
  static const String getSettings = '/settings';
  static const String updateSettings = '/settings';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}