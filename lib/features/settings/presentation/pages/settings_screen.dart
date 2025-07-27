import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserSection(context),
                  const SizedBox(height: 24),
                  SettingsSection(
                    title: 'Appearance',
                    children: [
                      SettingsTile(
                        title: 'Theme',
                        subtitle: _getThemeLabel(state.settings.themeMode),
                        leading: const Icon(Icons.palette_outlined),
                        onTap: () =>
                            _showThemeDialog(context, state.settings.themeMode),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSection(
                    title: 'Notifications',
                    children: [
                      SettingsTile(
                        title: 'Enable Notifications',
                        subtitle: 'Receive schedule reminders',
                        leading: const Icon(Icons.notifications_outlined),
                        trailing: Switch(
                          value: state.settings.notificationsEnabled,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                                  UpdateSettings(
                                    settings: state.settings.copyWith(
                                      notificationsEnabled: value,
                                    ),
                                  ),
                                );
                          },
                        ),
                      ),
                      SettingsTile(
                        title: 'Sound',
                        subtitle: 'Play sound for notifications',
                        leading: const Icon(Icons.volume_up_outlined),
                        trailing: Switch(
                          value: state.settings.soundEnabled,
                          onChanged: state.settings.notificationsEnabled
                              ? (value) {
                                  context.read<SettingsBloc>().add(
                                        UpdateSettings(
                                          settings: state.settings.copyWith(
                                            soundEnabled: value,
                                          ),
                                        ),
                                      );
                                }
                              : null,
                        ),
                      ),
                      SettingsTile(
                        title: 'Default Reminders',
                        subtitle: _getReminderTimesLabel(
                            state.settings.defaultReminderTimes),
                        leading: const Icon(Icons.access_time),
                        onTap: () => _showReminderTimesDialog(
                          context,
                          state.settings.defaultReminderTimes,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSection(
                    title: 'Account',
                    children: [
                      SettingsTile(
                        title: 'Sign Out',
                        subtitle: 'Sign out of your account',
                        leading: const Icon(Icons.logout),
                        onTap: () => _showSignOutDialog(context),
                        textColor: AppColors.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSection(
                    title: 'About',
                    children: [
                      const SettingsTile(
                        title: 'Version',
                        subtitle: '1.0.0',
                        leading: Icon(Icons.info_outline),
                      ),
                      SettingsTile(
                        title: 'Privacy Policy',
                        leading: const Icon(Icons.privacy_tip_outlined),
                        onTap: () {
                          // TODO: Open privacy policy
                        },
                      ),
                      SettingsTile(
                        title: 'Terms of Service',
                        leading: const Icon(Icons.description_outlined),
                        onTap: () {
                          // TODO: Open terms of service
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading settings',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(LoadSettings());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    state.user.firstName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.user.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _getThemeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getReminderTimesLabel(List<int> reminderTimes) {
    if (reminderTimes.isEmpty) return 'None';

    final labels = reminderTimes.map((minutes) {
      if (minutes < 60) {
        return '${minutes}m';
      } else {
        final hours = minutes ~/ 60;
        return '${hours}h';
      }
    }).toList();

    return labels.join(', ');
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSettings(
                          settings: (context.read<SettingsBloc>().state
                                  as SettingsLoaded)
                              .settings
                              .copyWith(themeMode: value),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSettings(
                          settings: (context.read<SettingsBloc>().state
                                  as SettingsLoaded)
                              .settings
                              .copyWith(themeMode: value),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSettings(
                          settings: (context.read<SettingsBloc>().state
                                  as SettingsLoaded)
                              .settings
                              .copyWith(themeMode: value),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderTimesDialog(BuildContext context, List<int> currentTimes) {
    final availableTimes = [
      5,
      15,
      30,
      60,
      120,
      1440
    ]; // 5m, 15m, 30m, 1h, 2h, 1d
    final selectedTimes = List<int>.from(currentTimes);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Default Reminder Times'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableTimes.map((minutes) {
              String label;
              if (minutes < 60) {
                label = '$minutes minutes before';
              } else if (minutes < 1440) {
                final hours = minutes ~/ 60;
                label = '$hours hour${hours > 1 ? 's' : ''} before';
              } else {
                final days = minutes ~/ 1440;
                label = '$days day${days > 1 ? 's' : ''} before';
              }

              return CheckboxListTile(
                title: Text(label),
                value: selectedTimes.contains(minutes),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedTimes.add(minutes);
                    } else {
                      selectedTimes.remove(minutes);
                    }
                    selectedTimes.sort();
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<SettingsBloc>().add(
                      UpdateSettings(
                        settings: (context.read<SettingsBloc>().state
                                as SettingsLoaded)
                            .settings
                            .copyWith(defaultReminderTimes: selectedTimes),
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
