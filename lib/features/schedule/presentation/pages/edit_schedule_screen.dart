import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/schedule.dart';
import '../bloc/schedule_bloc.dart';

class EditScheduleScreen extends StatefulWidget {
  final Schedule schedule;

  const EditScheduleScreen({
    super.key,
    required this.schedule,
  });

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _durationController;
  late TextEditingController _locationController;
  late TextEditingController _participantsController;
  late TextEditingController _categoryController;

  late ScheduleType _selectedType;
  late Priority _selectedPriority;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.schedule.title);
    _descriptionController =
        TextEditingController(text: widget.schedule.description ?? '');
    _dateController = TextEditingController(text: widget.schedule.date);
    _timeController = TextEditingController(text: widget.schedule.time);
    _durationController =
        TextEditingController(text: widget.schedule.duration?.toString() ?? '');
    _locationController =
        TextEditingController(text: widget.schedule.location ?? '');
    _participantsController = TextEditingController(
        text: widget.schedule.participants?.join(', ') ?? '');
    _categoryController =
        TextEditingController(text: widget.schedule.category ?? '');

    _selectedType = widget.schedule.type;
    _selectedPriority = widget.schedule.priority;

    // Parse date and time
    final dateParts = widget.schedule.date.split('-');
    _selectedDate = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );

    final timeParts = widget.schedule.time.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _participantsController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _saveSchedule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final tokenResult = await getIt<AuthRepository>().getAuthToken();
      tokenResult.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication error: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (token) async {
          if (token != null) {
            // Create updated schedule
            final updatedSchedule = Schedule(
              id: widget.schedule.id,
              type: _selectedType,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              date: _dateController.text,
              time: _timeController.text,
              duration: _durationController.text.isEmpty
                  ? null
                  : int.tryParse(_durationController.text),
              participants: _participantsController.text.trim().isEmpty
                  ? null
                  : _participantsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
              location: _locationController.text.trim().isEmpty
                  ? null
                  : _locationController.text.trim(),
              priority: _selectedPriority,
              category: _categoryController.text.trim().isEmpty
                  ? null
                  : _categoryController.text.trim(),
              metadata: widget.schedule.metadata,
              userId: widget.schedule.userId,
              aiPrompt: widget.schedule.aiPrompt,
              aiResponse: widget.schedule.aiResponse,
              createdAt: widget.schedule.createdAt,
              updatedAt: DateTime.now(),
            );

            context.read<ScheduleBloc>().add(
                  UpdateScheduleRequested(
                    id: widget.schedule.id!,
                    schedule: updatedSchedule,
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
        title: const Text('Edit Schedule'),
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
        actions: [
          BlocListener<ScheduleBloc, ScheduleState>(
            listener: (context, state) {
              if (state is ScheduleUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Schedule updated successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.of(context).pop();
              } else if (state is ScheduleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Type Selection
                            Text(
                              'Type',
                              style: AppTextStyles.heading4.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.medium),
                                border:
                                    Border.all(color: AppColors.borderLight),
                              ),
                              child: DropdownButtonFormField<ScheduleType>(
                                value: _selectedType,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.md),
                                ),
                                items: ScheduleType.values.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getTypeIcon(type),
                                          color: _getTypeColor(type),
                                          size: AppSizes.iconSmall,
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(_getTypeName(type)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedType = value;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Title
                            Text(
                              'Title',
                              style: AppTextStyles.heading4.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: 'Enter schedule title',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.medium),
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Description
                            Text(
                              'Description',
                              style: AppTextStyles.heading4.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter description (optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.medium),
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Date and Time Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date',
                                        style: AppTextStyles.heading4.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: TextFormField(
                                          controller: _dateController,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            suffixIcon: const Icon(
                                                Icons.calendar_today),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppBorderRadius.medium),
                                            ),
                                            filled: true,
                                            fillColor: AppColors.surface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: AppTextStyles.heading4.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      GestureDetector(
                                        onTap: () => _selectTime(context),
                                        child: TextFormField(
                                          controller: _timeController,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            suffixIcon:
                                                const Icon(Icons.access_time),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppBorderRadius.medium),
                                            ),
                                            filled: true,
                                            fillColor: AppColors.surface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Duration and Priority Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Duration (minutes)',
                                        style: AppTextStyles.heading4.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      TextFormField(
                                        controller: _durationController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '60',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppBorderRadius.medium),
                                          ),
                                          filled: true,
                                          fillColor: AppColors.surface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Priority',
                                        style: AppTextStyles.heading4.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.md),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(
                                              AppBorderRadius.medium),
                                          border: Border.all(
                                              color: AppColors.borderLight),
                                        ),
                                        child:
                                            DropdownButtonFormField<Priority>(
                                          value: _selectedPriority,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: AppSpacing.md),
                                          ),
                                          items:
                                              Priority.values.map((priority) {
                                            return DropdownMenuItem(
                                              value: priority,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: _getPriorityColor(
                                                          priority),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width: AppSpacing.sm),
                                                  Text(_getPriorityName(
                                                      priority)),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedPriority = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Location
                            Text(
                              'Location',
                              style: AppTextStyles.heading4.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                hintText: 'Enter location (optional)',
                                prefixIcon:
                                    const Icon(Icons.location_on_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.medium),
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Participants
                            Text(
                              'Participants',
                              style: AppTextStyles.heading4.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _participantsController,
                              decoration: InputDecoration(
                                hintText:
                                    'Enter participants separated by commas (optional)',
                                prefixIcon: const Icon(Icons.people_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.medium),
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // Category
                            Text(
                              'Category',
                              style: AppTextStyles.heading4.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _categoryController,
                              decoration: InputDecoration(
                                hintText: 'Enter category (optional)',
                                prefixIcon: const Icon(Icons.category_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.medium),
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            // Save Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state is ScheduleUpdating
                                    ? null
                                    : _saveSchedule,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textInverse,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.lg),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppBorderRadius.medium),
                                  ),
                                ),
                                child: state is ScheduleUpdating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.textInverse),
                                        ),
                                      )
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (state is ScheduleUpdating)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  IconData _getTypeIcon(ScheduleType type) {
    switch (type) {
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

  String _getTypeName(ScheduleType type) {
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

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return AppColors.success;
      case Priority.medium:
        return AppColors.warning;
      case Priority.high:
        return AppColors.error;
    }
  }

  String _getPriorityName(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }
}
