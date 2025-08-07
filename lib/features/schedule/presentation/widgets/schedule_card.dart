import 'package:flutter/material.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../domain/entities/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.large),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: _getTypeColor().withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.medium),
                      ),
                      child: Icon(
                        _getTypeIcon(),
                        color: _getTypeColor(),
                        size: AppSizes.iconMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.title,
                            style: AppTextStyles.heading3.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (schedule.description?.isNotEmpty == true) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              schedule.description!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (onEdit != null || onDelete != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.medium),
                              ),
                              child: IconButton(
                                onPressed: onEdit,
                                icon: Icon(
                                  Icons.edit_outlined,
                                  size: AppSizes.iconSmall,
                                  color: AppColors.primary,
                                ),
                                splashRadius: 20,
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          if (onDelete != null) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.medium),
                              ),
                              child: IconButton(
                                onPressed: onDelete,
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: AppSizes.iconSmall,
                                  color: AppColors.error,
                                ),
                                splashRadius: 20,
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: AppSizes.iconSmall,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${date_utils.DateUtils.getRelativeDateString(schedule.dateTime)} at ${date_utils.DateUtils.formatDisplayTime(schedule.dateTime)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (schedule.duration != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.small),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    '${schedule.duration!} min',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (schedule.location?.isNotEmpty == true) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: AppSizes.iconSmall,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                schedule.location!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (schedule.participants?.isNotEmpty == true) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: AppSizes.iconSmall,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                schedule.participants!.join(', '),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (schedule.type) {
      case ScheduleType.meeting:
        return AppColors.meeting;
      case ScheduleType.reminder:
        return AppColors.reminder;
      case ScheduleType.task:
        return AppColors.task;
      case ScheduleType.appointment:
        return AppColors.appointment;
    }
  }

  IconData _getTypeIcon() {
    switch (schedule.type) {
      case ScheduleType.meeting:
        return Icons.people_outline;
      case ScheduleType.reminder:
        return Icons.notifications_outlined;
      case ScheduleType.task:
        return Icons.task_outlined;
      case ScheduleType.appointment:
        return Icons.event_outlined;
    }
  }
}
