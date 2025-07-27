import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';
import '../../../schedule/presentation/widgets/schedule_card.dart';

class RecentSchedulesSection extends StatelessWidget {
  const RecentSchedulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Schedules',
              style: AppTextStyles.heading3,
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full schedule list
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return _buildLoadingState();
            } else if (state is SchedulesLoaded) {
              if (state.schedules.isEmpty) {
                return _buildEmptyState();
              }

              // Show only upcoming schedules, limited to 3
              final upcomingSchedules = state.schedules
                  .where((schedule) => !schedule.isPastDue)
                  .take(3)
                  .toList();

              if (upcomingSchedules.isEmpty) {
                return _buildNoUpcomingState();
              }

              return Column(
                children: upcomingSchedules
                    .map((schedule) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ScheduleCard(
                            schedule: schedule,
                            onTap: () {
                              // TODO: Navigate to schedule detail
                            },
                          ),
                        ))
                    .toList(),
              );
            } else if (state is ScheduleError) {
              return _buildErrorState(state.message);
            }

            return _buildEmptyState();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 48,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No schedules yet',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the AI assistant above to create your first schedule',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoUpcomingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppColors.success.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No upcoming schedules for now',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading schedules',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
