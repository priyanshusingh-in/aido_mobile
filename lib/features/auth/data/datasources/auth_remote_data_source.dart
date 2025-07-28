import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<UserResponse> getUserProfile(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await apiClient.login(request);

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(message: response.error ?? 'Login failed');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await apiClient.register(request);

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(message: response.error ?? 'Registration failed');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserResponse> getUserProfile(String token) async {
    try {
      final response = await apiClient.getProfile('Bearer $token');

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to get user profile');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }
}
