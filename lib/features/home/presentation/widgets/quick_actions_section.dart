import 'package:flutter/material.dart';

import '../../../../core/constants/theme_constants.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.round),
              ),
              child: Icon(
                Icons.flash_on,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Quick Actions',
              style: AppTextStyles.heading4.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              icon: Icons.people_outline,
              title: 'Meeting',
              subtitle: 'Schedule a meeting',
              color: AppColors.accent,
              gradient: AppColors.primaryGradient,
              onTap: () {
                // TODO: Navigate to meeting creation
              },
            ),
            _buildActionCard(
              icon: Icons.notifications_outlined,
              title: 'Reminder',
              subtitle: 'Set a reminder',
              color: AppColors.accentLight,
              gradient: AppColors.accentGradient,
              onTap: () {
                // TODO: Navigate to reminder creation
              },
            ),
            _buildActionCard(
              icon: Icons.task_outlined,
              title: 'Task',
              subtitle: 'Add a task',
              color: AppColors.primaryDark,
              gradient: AppColors.primaryGradient,
              onTap: () {
                // TODO: Navigate to task creation
              },
            ),
            _buildActionCard(
              icon: Icons.event_outlined,
              title: 'Appointment',
              subtitle: 'Book appointment',
              color: AppColors.accent,
              gradient: AppColors.accentGradient,
              onTap: () {
                // TODO: Navigate to appointment creation
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.large),
          boxShadow: AppShadows.medium,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.95),
            borderRadius: BorderRadius.circular(AppBorderRadius.large),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
