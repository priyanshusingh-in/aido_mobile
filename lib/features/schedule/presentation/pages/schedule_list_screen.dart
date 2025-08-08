import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../bloc/schedule_bloc.dart';
import '../widgets/schedule_card.dart';
import 'edit_schedule_screen.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
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
                  GetSchedulesRequested(
                    authToken: 'Bearer $token',
                  ),
                );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
      ),
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Schedule deleted successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is ScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            } else if (state is SchedulesLoaded) {
              var schedules = state.schedules;
              if (schedules.isEmpty) {
                return _buildEmptyState();
              }
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _loadSchedules();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ScheduleCard(
                              schedule: schedule,
                              onTap: () {
                                // TODO: Navigate to schedule detail
                              },
                              onEdit: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditScheduleScreen(
                                      schedule: schedule,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () async {
                                // Show confirmation dialog
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Schedule'),
                                      content: Text(
                                        'Are you sure you want to delete "${schedule.title}"? This action cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColors.error,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (shouldDelete == true &&
                                    schedule.id != null) {
                                  final authState =
                                      context.read<AuthBloc>().state;
                                  if (authState is AuthAuthenticated) {
                                    final tokenResult =
                                        await getIt<AuthRepository>()
                                            .getAuthToken();
                                    tokenResult.fold(
                                      (failure) => null,
                                      (token) {
                                        if (token != null) {
                                          context.read<ScheduleBloc>().add(
                                                DeleteScheduleRequested(
                                                  id: schedule.id!,
                                                  authToken: 'Bearer $token',
                                                ),
                                              );
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is ScheduleError) {
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
                        'Error loading schedules',
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
                        onPressed: _loadSchedules,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return _buildEmptyState();
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.large),
          boxShadow: AppShadows.large,
        ),
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to create schedule screen
          },
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.round),
              ),
              child: Icon(
                Icons.schedule_outlined,
                size: AppSizes.iconXLarge,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No schedules yet',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create your first schedule using the AI assistant',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
