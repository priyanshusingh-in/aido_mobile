import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/theme_constants.dart';

class AuthAnimatedBackground extends StatefulWidget {
  const AuthAnimatedBackground({super.key});

  @override
  State<AuthAnimatedBackground> createState() => _AuthAnimatedBackgroundState();
}

class _AuthAnimatedBackgroundState extends State<AuthAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseBg =
        isDark ? AppColors.backgroundSecondary : AppColors.background;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final dx1 = math.sin(t * math.pi * 2) * 40;
        final dy1 = math.cos(t * math.pi * 2) * 30;
        final dx2 = math.cos(t * math.pi * 2) * 50;
        final dy2 = math.sin(t * math.pi * 2) * 40;
        final dx3 = math.sin(t * math.pi * 2 + 1) * 35;
        final dy3 = math.cos(t * math.pi * 2 + 1) * 45;

        return Container(
          color: baseBg,
          child: Stack(
            children: [
              // Soft gradient backdrop
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(isDark ? 0.10 : 0.08),
                        AppColors.accent.withOpacity(isDark ? 0.10 : 0.06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Floating blobs
              _AnimatedBlob(
                offset: Offset(40 + dx1, 120 + dy1),
                size: 220,
                color: AppColors.primary.withOpacity(0.22),
              ),
              _AnimatedBlob(
                offset: Offset(-20 + dx2, 440 + dy2),
                size: 260,
                color: AppColors.accent.withOpacity(0.20),
              ),
              _AnimatedBlob(
                offset: Offset(220 + dx3, 680 + dy3),
                size: 240,
                color: AppColors.success.withOpacity(0.14),
              ),

              // Global subtle blur to soften shapes
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: const SizedBox(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedBlob extends StatelessWidget {
  final Offset offset;
  final double size;
  final Color color;

  const _AnimatedBlob(
      {required this.offset, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }
}
