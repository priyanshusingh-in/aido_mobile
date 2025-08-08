import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';
import '../widgets/ai_prompt_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final tokenResult = await getIt<AuthRepository>().getAuthToken();
      tokenResult.fold(
        (failure) => null,
        (token) {
          if (token != null) {
            context.read<ScheduleBloc>().add(
                  GetSchedulesRequested(authToken: 'Bearer $token'),
                );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadSchedules();
          },
          child: Scrollbar(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: AppSpacing.xl),
                            const AIPromptInput(),
                            const SizedBox(height: AppSpacing.xxl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String greeting = _getGreeting();
        String userName = 'User';
        if (state is AuthAuthenticated) {
          userName = state.user.firstName;
        }
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppBorderRadius.large),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.round),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: AppSizes.iconMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Hello, $userName!',
                          style: AppTextStyles.heading1.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.medium),
                      border:
                          Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AppSizes.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          date_utils.DateUtils.formatDisplayDate(
                              DateTime.now()),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}
