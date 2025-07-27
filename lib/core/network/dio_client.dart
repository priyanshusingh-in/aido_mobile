import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeout),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token =
              await _secureStorage.read(key: AppConstants.authTokenKey);
          if (token != null) {
            options.headers[ApiConstants.authorization] =
                '${ApiConstants.bearer} $token';
          }

          // Log request
          debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
          debugPrint('Headers: ${options.headers}');
          if (options.data != null) {
            debugPrint('Data: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          debugPrint(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          debugPrint('Data: ${response.data}');

          handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          debugPrint(
              'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          debugPrint('Message: ${error.message}');

          // Handle different error types
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: const NetworkException(message: 'Connection timeout'),
              ),
            );
          } else if (error.type == DioExceptionType.connectionError) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error:
                    const NetworkException(message: 'No internet connection'),
              ),
            );
          } else if (error.response?.statusCode == 401) {
            // Handle unauthorized - clear token and redirect to login
            _secureStorage.delete(key: AppConstants.authTokenKey);
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                error: const AuthenticationException(
                    message: 'Authentication failed'),
              ),
            );
          } else if (error.response?.statusCode == 403) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                error: const AuthorizationException(message: 'Access denied'),
              ),
            );
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  Dio get dio => _dio;
}
