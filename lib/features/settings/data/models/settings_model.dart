import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/settings.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel extends Settings {
  const SettingsModel({
    super.themeMode = ThemeMode.system,
    super.notificationsEnabled = true,
    super.defaultReminderTimes = const [5, 15, 60],
    super.soundEnabled = true,
    super.language = 'en',
    super.biometricEnabled = false,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  factory SettingsModel.fromEntity(Settings settings) {
    return SettingsModel(
      themeMode: settings.themeMode,
      notificationsEnabled: settings.notificationsEnabled,
      defaultReminderTimes: settings.defaultReminderTimes,
      soundEnabled: settings.soundEnabled,
      language: settings.language,
      biometricEnabled: settings.biometricEnabled,
    );
  }

  @override
  SettingsModel copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    List<int>? defaultReminderTimes,
    bool? soundEnabled,
    String? language,
    bool? biometricEnabled,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultReminderTimes: defaultReminderTimes ?? this.defaultReminderTimes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
