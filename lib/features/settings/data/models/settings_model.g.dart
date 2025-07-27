// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      defaultReminderTimes: (json['defaultReminderTimes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [5, 15, 60],
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'notificationsEnabled': instance.notificationsEnabled,
      'defaultReminderTimes': instance.defaultReminderTimes,
      'soundEnabled': instance.soundEnabled,
      'language': instance.language,
      'biometricEnabled': instance.biometricEnabled,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
