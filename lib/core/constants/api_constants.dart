import '../config/env_config.dart';

class ApiConstants {
  // Get base URL from environment configuration
  static String get baseUrl => EnvConfig.apiBaseUrl;

  // Get health check URL from environment configuration
  static String get healthCheckUrl => EnvConfig.apiHealthCheckUrl;

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  // Schedule endpoints
  static const String schedules = '/schedules';
  static const String createSchedule = '/schedules';
  static const String scheduleById = '/schedules/{id}';
  static const String scheduleByDateRange = '/schedules/date-range';
  static const String scheduleByType = '/schedules/type/{type}';

  // System endpoints
  static const String health = '/health';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // Timeouts from environment configuration
  static int get connectTimeout => EnvConfig.apiConnectTimeout;
  static int get receiveTimeout => EnvConfig.apiReceiveTimeout;
  static int get sendTimeout => EnvConfig.apiSendTimeout;

  // API Features
  // - Relative time support: "in 2 minutes", "in 1 hour", "in 3 days", "in 1 week"
  // - Natural language processing with Google Gemini AI
  // - JWT authentication with 7-day expiry
  // - Rate limiting: 100 requests per 15 minutes
}
