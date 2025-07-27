import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final settingsJson =
          sharedPreferences.getString(AppConstants.settingsKey);
      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        return SettingsModel.fromJson(settingsMap);
      }
      return const SettingsModel(); // Return default settings
    } catch (e) {
      throw const CacheException(message: 'Failed to get settings');
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final settingsJson = jsonEncode(settings.toJson());
      await sharedPreferences.setString(AppConstants.settingsKey, settingsJson);
    } catch (e) {
      throw const CacheException(message: 'Failed to save settings');
    }
  }
}
