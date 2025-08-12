class ApiConstants {
  static const String baseUrl = 'http://localhost:3200';
  
  // Health endpoints
  static const String health = '/health';
  static const String apiInfo = '/';
  
  // Authentication endpoints
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String checkEmail = '/auth/check-email';
  static const String getSession = '/auth/session';
  static const String signOut = '/auth/signout';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String userPreferences = '/user/preferences';
  
  // Content endpoints
  static const String content = '/content';
  static String contentById(String id) => '/content/$id';
  static String contentChapters(String id) => '/content/$id/chapters';
  static String contentBookmark(String id) => '/content/$id/bookmark';
  
  // Authors endpoints
  static const String authors = '/authors';
  static String authorById(String id) => '/authors/$id';
  static String followAuthor(String id) => '/authors/$id/follow';
  
  // Categories endpoints
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';
  
  // Bookmarks endpoints
  static const String bookmarks = '/bookmarks';
  static String bookmarkById(String id) => '/bookmarks/$id';
  
  // HTTP Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  static const String userAgentHeader = 'User-Agent';
  static const String acceptLanguageHeader = 'Accept-Language';
  static const String deviceTypeHeader = 'X-Device-Type';
  
  // Content Types
  static const String applicationJson = 'application/json';
  static const String applicationFormUrlEncoded = 'application/x-www-form-urlencoded';
  
  // Auth
  static const String bearerPrefix = 'Bearer ';
  
  // Pagination defaults
  static const int defaultPage = 1;
  static const int defaultLimit = 20;
  static const int maxLimit = 100;
}