import 'package:flutter/material.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../domain/entities/schedule.dart';

class ScheduleFilterBar extends StatelessWidget {
  final String? selectedType;
  final String? selectedPriority;
  final Function({String? type, String? priority}) onFilterChanged;

  const ScheduleFilterBar({
    super.key,
    this.selectedType,
    this.selectedPriority,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Type',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All',
                  isSelected: selectedType == null,
                  onTap: () =>
                      onFilterChanged(type: null, priority: selectedPriority),
                ),
                const SizedBox(width: 8),
                ...ScheduleType.values.map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      label: _getTypeLabel(type),
                      isSelected: selectedType == type.name,
                      color: _getTypeColor(type),
                      onTap: () => onFilterChanged(
                        type: type.name,
                        priority: selectedPriority,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Filter by Priority',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All',
                  isSelected: selectedPriority == null,
                  onTap: () =>
                      onFilterChanged(type: selectedType, priority: null),
                ),
                const SizedBox(width: 8),
                ...Priority.values.map(
                  (priority) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      label: _getPriorityLabel(priority),
                      isSelected: selectedPriority == priority.name,
                      color: _getPriorityColor(priority),
                      onTap: () => onFilterChanged(
                        type: selectedType,
                        priority: priority.name,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.primary) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? (color ?? AppColors.primary) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isSelected ? Colors.white : (color ?? AppColors.textSecondary),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(ScheduleType type) {
    switch (type) {
      case ScheduleType.meeting:
        return 'Meeting';
      case ScheduleType.reminder:
        return 'Reminder';
      case ScheduleType.task:
        return 'Task';
      case ScheduleType.appointment:
        return 'Appointment';
    }
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  Color _getTypeColor(ScheduleType type) {
    switch (type) {
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

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }
}
