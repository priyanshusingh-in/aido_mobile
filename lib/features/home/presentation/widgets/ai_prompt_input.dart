import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';

class AIPromptInput extends StatefulWidget {
  const AIPromptInput({super.key});

  @override
  State<AIPromptInput> createState() => _AIPromptInputState();
}

class _AIPromptInputState extends State<AIPromptInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final prompt = _controller.text.trim();
    if (prompt.isNotEmpty) {
      final authState = context.read<AuthBloc>().state;
      String? authToken;

      if (authState is AuthAuthenticated) {
        final tokenResult = await getIt<AuthRepository>().getAuthToken();
        tokenResult.fold(
          (failure) => null,
          (token) {
            if (token != null) {
              authToken = 'Bearer $token';
            }
          },
        );
      }

      context.read<ScheduleBloc>().add(
            CreateScheduleRequested(
              aiPrompt: prompt,
              authToken: authToken,
            ),
          );

      _controller.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleCreated) {
          final schedule = state.schedule;
          final usedRelativeTime =
              app_date_utils.DateUtils.containsRelativeTime(schedule.aiPrompt);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Schedule created: ${schedule.title}'),
                  if (usedRelativeTime)
                    Text(
                      '⏰ Relative time detected and calculated',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
              ),
            ),
          );
        } else if (state is ScheduleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppBorderRadius.large),
          border: Border.all(color: AppColors.cardBorder, width: 1),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.round),
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
                        'AI Scheduling Assistant',
                        style: AppTextStyles.heading2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Tell me what you want to schedule',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 3,
                minLines: 1,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      'e.g., "Meeting with John tomorrow at 3 PM" or "remind me to call mom in 2 minutes"',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                  suffixIcon: _controller.text.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.medium),
                            boxShadow: AppShadows.button,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.textInverse,
                              size: 18,
                            ),
                            onPressed: _handleSubmit,
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                            ),
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (_) => _handleSubmit(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
