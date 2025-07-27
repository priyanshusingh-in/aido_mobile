import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final List<int> defaultReminderTimes; // minutes before event
  final bool soundEnabled;
  final String language;
  final bool biometricEnabled;

  const Settings({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.defaultReminderTimes = const [5, 15, 60], // 5min, 15min, 1hour
    this.soundEnabled = true,
    this.language = 'en',
    this.biometricEnabled = false,
  });

  Settings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    List<int>? defaultReminderTimes,
    bool? soundEnabled,
    String? language,
    bool? biometricEnabled,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultReminderTimes: defaultReminderTimes ?? this.defaultReminderTimes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  @override
  List<Object> get props => [
        themeMode,
        notificationsEnabled,
        defaultReminderTimes,
        soundEnabled,
        language,
        biometricEnabled,
      ];
}