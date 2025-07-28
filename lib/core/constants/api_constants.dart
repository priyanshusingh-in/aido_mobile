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

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // Timeouts from environment configuration
  static int get connectTimeout => EnvConfig.apiConnectTimeout;
  static int get receiveTimeout => EnvConfig.apiReceiveTimeout;
  static int get sendTimeout => EnvConfig.apiSendTimeout;
}
