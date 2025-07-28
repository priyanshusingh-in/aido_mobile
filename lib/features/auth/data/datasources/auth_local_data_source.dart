import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../models/auth_models.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await SecureStorageService.saveAuthToken(token);
    } catch (e) {
      throw const CacheException(message: 'Failed to save auth token');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return await SecureStorageService.getAuthToken();
    } catch (e) {
      throw const CacheException(message: 'Failed to get auth token');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await SecureStorageService.saveUserData(
        userId: user.id,
        email: user.email,
        name: '${user.firstName} ${user.lastName}',
      );

      // Also save the full user object for backward compatibility
      final userJson = jsonEncode(user.toJson());
      await secureStorage.write(key: AppConstants.userDataKey, value: userJson);
    } catch (e) {
      throw const CacheException(message: 'Failed to save user data');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = await secureStorage.read(key: AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw const CacheException(message: 'Failed to get user data');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await SecureStorageService.clearAllData();
    } catch (e) {
      throw const CacheException(message: 'Failed to clear auth data');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await SecureStorageService.isLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
