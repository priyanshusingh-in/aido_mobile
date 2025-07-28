import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String _environmentKey = 'ENVIRONMENT';
  static const String _apiBaseUrlDevKey = 'API_BASE_URL_DEVELOPMENT';
  static const String _apiBaseUrlProdKey = 'API_BASE_URL_PRODUCTION';
  static const String _apiHealthCheckKey = 'API_HEALTH_CHECK_URL';
  static const String _apiConnectTimeoutKey = 'API_CONNECT_TIMEOUT';
  static const String _apiReceiveTimeoutKey = 'API_RECEIVE_TIMEOUT';
  static const String _apiSendTimeoutKey = 'API_SEND_TIMEOUT';
  static const String _appNameKey = 'APP_NAME';
  static const String _appVersionKey = 'APP_VERSION';
  static const String _enableDebugLoggingKey = 'ENABLE_DEBUG_LOGGING';
  static const String _enableAnalyticsKey = 'ENABLE_ANALYTICS';

  // Initialize environment variables
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  // Environment
  static String get environment => dotenv.env[_environmentKey] ?? 'development';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  // API Configuration
  static String get apiBaseUrlDevelopment =>
      dotenv.env[_apiBaseUrlDevKey] ?? 'http://localhost:3000/api/v1';
  static String get apiBaseUrlProduction =>
      dotenv.env[_apiBaseUrlProdKey] ??
      'https://aido-backend.onrender.com/api/v1';
  static String get apiHealthCheckUrl =>
      dotenv.env[_apiHealthCheckKey] ??
      'https://aido-backend.onrender.com/health';

  // Dynamic API Base URL based on environment
  static String get apiBaseUrl =>
      isProduction ? apiBaseUrlProduction : apiBaseUrlDevelopment;

  // Timeouts
  static int get apiConnectTimeout =>
      int.tryParse(dotenv.env[_apiConnectTimeoutKey] ?? '30000') ?? 30000;
  static int get apiReceiveTimeout =>
      int.tryParse(dotenv.env[_apiReceiveTimeoutKey] ?? '30000') ?? 30000;
  static int get apiSendTimeout =>
      int.tryParse(dotenv.env[_apiSendTimeoutKey] ?? '30000') ?? 30000;

  // App Configuration
  static String get appName => dotenv.env[_appNameKey] ?? 'AIdo Mobile';
  static String get appVersion => dotenv.env[_appVersionKey] ?? '1.0.0';

  // Feature Flags
  static bool get enableDebugLogging =>
      dotenv.env[_enableDebugLoggingKey]?.toLowerCase() == 'true';
  static bool get enableAnalytics =>
      dotenv.env[_enableAnalyticsKey]?.toLowerCase() == 'true';

  // Validation
  static bool validate() {
    final requiredKeys = [
      _environmentKey,
      _apiBaseUrlDevKey,
      _apiBaseUrlProdKey,
      _apiHealthCheckKey,
    ];

    for (final key in requiredKeys) {
      if (dotenv.env[key] == null || dotenv.env[key]!.isEmpty) {
        throw Exception('Missing required environment variable: $key');
      }
    }

    return true;
  }

  // Debug information
  static Map<String, dynamic> get debugInfo => {
        'environment': environment,
        'apiBaseUrl': apiBaseUrl,
        'apiHealthCheckUrl': apiHealthCheckUrl,
        'timeouts': {
          'connect': apiConnectTimeout,
          'receive': apiReceiveTimeout,
          'send': apiSendTimeout,
        },
        'app': {
          'name': appName,
          'version': appVersion,
        },
        'features': {
          'debugLogging': enableDebugLogging,
          'analytics': enableAnalytics,
        },
      };
}
