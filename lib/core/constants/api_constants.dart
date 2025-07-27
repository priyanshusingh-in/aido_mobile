class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  
  // Schedule endpoints
  static const String schedules = '/schedules';
  static const String createSchedule = '/schedules';
  
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  
  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}