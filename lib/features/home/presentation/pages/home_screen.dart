import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';
import '../widgets/ai_prompt_input.dart';
import '../widgets/recent_schedules_section.dart';
import '../widgets/quick_actions_section.dart';

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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadSchedules();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                const AIPromptInput(),
                const SizedBox(height: 32),
                const QuickActionsSection(),
                const SizedBox(height: 32),
                const RecentSchedulesSection(),
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hello, $userName!',
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date_utils.DateUtils.formatDisplayDate(DateTime.now()),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
