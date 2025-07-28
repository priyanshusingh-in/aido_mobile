import 'package:dio/dio.dart';
import '../utils/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding auth header for login and register endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/health')) {
      return handler.next(options);
    }

    // Add authorization header if token exists
    final authHeader = await SecureStorageService.getAuthorizationHeader();
    if (authHeader != null) {
      options.headers['Authorization'] = authHeader;
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Token might be expired, clear it
      SecureStorageService.deleteAuthToken();
      // You could also trigger a logout event here
    }

    return handler.next(err);
  }
}
