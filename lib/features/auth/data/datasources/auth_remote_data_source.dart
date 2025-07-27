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
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await apiClient.register(request);
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserResponse> getUserProfile(String token) async {
    try {
      final response = await apiClient.getProfile('Bearer $token');
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}