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
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
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
                    ],
                  ),
                ],
              ),
            );
          } else if (state is SettingsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.round),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: AppSizes.iconXLarge,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Error loading settings',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<SettingsBloc>().add(LoadSettings()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppBorderRadius.large),
              border: Border.all(color: AppColors.cardBorder, width: 1),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: AppSizes.avatarMedium / 2,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    state.user.firstName[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user.fullName,
                        style: AppTextStyles.heading2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        state.user.email,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
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
