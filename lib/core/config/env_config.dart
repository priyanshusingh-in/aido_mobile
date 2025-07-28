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
    print('DEBUG: Loading .env file...');
    try {
      await dotenv.load(fileName: '.env');
      print(
          'DEBUG: .env file loaded. Available keys: ${dotenv.env.keys.toList()}');
      print('DEBUG: ENVIRONMENT value: "${dotenv.env[_environmentKey]}"');
    } catch (e) {
      print('ERROR: Failed to load .env file: $e');
      throw Exception('Failed to load environment configuration: $e');
    }
  }

  // Environment
  static String get environment {
    final env = dotenv.env[_environmentKey];
    if (env == null || env.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_environmentKey');
    }
    return env;
  }

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  // API Configuration
  static String get apiBaseUrlDevelopment {
    final url = dotenv.env[_apiBaseUrlDevKey];
    if (url == null || url.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_apiBaseUrlDevKey');
    }
    return url;
  }

  static String get apiBaseUrlProduction {
    final url = dotenv.env[_apiBaseUrlProdKey];
    if (url == null || url.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_apiBaseUrlProdKey');
    }
    return url;
  }

  static String get apiHealthCheckUrl {
    final url = dotenv.env[_apiHealthCheckKey];
    if (url == null || url.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_apiHealthCheckKey');
    }
    return url;
  }

  // Dynamic API Base URL based on environment
  static String get apiBaseUrl {
    final url = isProduction ? apiBaseUrlProduction : apiBaseUrlDevelopment;
    return url;
  }

  // Timeouts
  static int get apiConnectTimeout {
    final timeout = dotenv.env[_apiConnectTimeoutKey];
    if (timeout == null || timeout.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_apiConnectTimeoutKey');
    }
    final parsedTimeout = int.tryParse(timeout);
    if (parsedTimeout == null) {
      throw Exception(
          'Invalid timeout value for $_apiConnectTimeoutKey: $timeout');
    }
    return parsedTimeout;
  }

  static int get apiReceiveTimeout {
    final timeout = dotenv.env[_apiReceiveTimeoutKey];
    if (timeout == null || timeout.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_apiReceiveTimeoutKey');
    }
    final parsedTimeout = int.tryParse(timeout);
    if (parsedTimeout == null) {
      throw Exception(
          'Invalid timeout value for $_apiReceiveTimeoutKey: $timeout');
    }
    return parsedTimeout;
  }

  static int get apiSendTimeout {
    final timeout = dotenv.env[_apiSendTimeoutKey];
    if (timeout == null || timeout.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_apiSendTimeoutKey');
    }
    final parsedTimeout = int.tryParse(timeout);
    if (parsedTimeout == null) {
      throw Exception(
          'Invalid timeout value for $_apiSendTimeoutKey: $timeout');
    }
    return parsedTimeout;
  }

  // App Configuration
  static String get appName {
    final name = dotenv.env[_appNameKey];
    if (name == null || name.isEmpty) {
      throw Exception('Missing required environment variable: $_appNameKey');
    }
    return name;
  }

  static String get appVersion {
    final version = dotenv.env[_appVersionKey];
    if (version == null || version.isEmpty) {
      throw Exception('Missing required environment variable: $_appVersionKey');
    }
    return version;
  }

  // Feature Flags
  static bool get enableDebugLogging {
    final value = dotenv.env[_enableDebugLoggingKey];
    if (value == null || value.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_enableDebugLoggingKey');
    }
    return value.toLowerCase() == 'true';
  }

  static bool get enableAnalytics {
    final value = dotenv.env[_enableAnalyticsKey];
    if (value == null || value.isEmpty) {
      throw Exception(
          'Missing required environment variable: $_enableAnalyticsKey');
    }
    return value.toLowerCase() == 'true';
  }

  // Validation
  static bool validate() {
    final requiredKeys = [
      _environmentKey,
      _apiBaseUrlDevKey,
      _apiBaseUrlProdKey,
      _apiHealthCheckKey,
      _apiConnectTimeoutKey,
      _apiReceiveTimeoutKey,
      _apiSendTimeoutKey,
      _appNameKey,
      _appVersionKey,
      _enableDebugLoggingKey,
      _enableAnalyticsKey,
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
