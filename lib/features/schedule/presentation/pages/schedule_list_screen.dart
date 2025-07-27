import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../bloc/schedule_bloc.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_filter_bar.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedType;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadSchedules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    type: _selectedType,
                    priority: _selectedPriority,
                  ),
                );
          }
        },
      );
    }
  }

  void _onFilterChanged({String? type, String? priority}) {
    setState(() {
      _selectedType = type;
      _selectedPriority = priority;
    });
    _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'All'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          ScheduleFilterBar(
            selectedType: _selectedType,
            selectedPriority: _selectedPriority,
            onFilterChanged: _onFilterChanged,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleList(filter: 'today'),
                _buildScheduleList(filter: 'upcoming'),
                _buildScheduleList(filter: 'all'),
                _buildScheduleList(filter: 'completed'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create schedule screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildScheduleList({required String filter}) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SchedulesLoaded) {
          var schedules = state.schedules;

          // Apply filter
          switch (filter) {
            case 'today':
              schedules = schedules.where((s) => _isToday(s.dateTime)).toList();
              break;
            case 'upcoming':
              schedules = schedules
                  .where((s) => s.dateTime.isAfter(DateTime.now()))
                  .toList();
              break;
            case 'completed':
              schedules = schedules.where((s) => s.isPastDue).toList();
              break;
            case 'all':
            default:
              break;
          }

          if (schedules.isEmpty) {
            return _buildEmptyState(filter);
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadSchedules();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
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
                      // TODO: Navigate to edit schedule
                    },
                    onDelete: () async {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        final tokenResult =
                            await getIt<AuthRepository>().getAuthToken();
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
                    },
                  ),
                );
              },
            ),
          );
        } else if (state is ScheduleError) {
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
                  'Error loading schedules',
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
                  onPressed: _loadSchedules,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return _buildEmptyState(filter);
      },
    );
  }

  Widget _buildEmptyState(String filter) {
    String title;
    String subtitle;
    IconData icon;

    switch (filter) {
      case 'today':
        title = 'No schedules today';
        subtitle = 'Enjoy your free day!';
        icon = Icons.today_outlined;
        break;
      case 'upcoming':
        title = 'No upcoming schedules';
        subtitle = 'Create a new schedule to get started';
        icon = Icons.upcoming_outlined;
        break;
      case 'completed':
        title = 'No completed schedules';
        subtitle = 'Completed schedules will appear here';
        icon = Icons.check_circle_outline;
        break;
      default:
        title = 'No schedules';
        subtitle = 'Create your first schedule';
        icon = Icons.schedule_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showDeleteConfirmation(String scheduleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: const Text('Are you sure you want to delete this schedule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                final tokenResult =
                    await getIt<AuthRepository>().getAuthToken();
                tokenResult.fold(
                  (failure) => null,
                  (token) {
                    if (token != null) {
                      context.read<ScheduleBloc>().add(
                            DeleteScheduleRequested(
                              id: scheduleId,
                              authToken: 'Bearer $token',
                            ),
                          );
                    }
                  },
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
