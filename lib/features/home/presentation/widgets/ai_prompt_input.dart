import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/theme_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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

  void _handleSubmit() {
    final prompt = _controller.text.trim();
    if (prompt.isNotEmpty) {
      final authState = context.read<AuthBloc>().state;
      String? authToken;

      if (authState is AuthAuthenticated) {
        authToken = 'Bearer token_here'; // Get actual token
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Schedule created: ${state.schedule.title}'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is ScheduleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Scheduling Assistant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tell me what you want to schedule',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'e.g., "Meeting with John tomorrow at 3 PM"',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildExampleChip('Team meeting at 2 PM'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildExampleChip('Remind me to call mom'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is ScheduleCreating ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is ScheduleCreating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          )
                        : const Text(
                            'Create Schedule',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleChip(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
