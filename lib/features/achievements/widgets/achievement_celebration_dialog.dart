import 'dart:math';

import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../models/achievement.dart';

class AchievementCelebrationDialog extends StatefulWidget {
  final Achievement achievement;

  const AchievementCelebrationDialog({super.key, required this.achievement});

  static Future<void> show(BuildContext context, Achievement achievement) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Achievement',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration: const Duration(milliseconds: 550),
      transitionBuilder: (ctx, animation, _, child) {
        final bounceIn = CurvedAnimation(parent: animation, curve: Curves.elasticOut);
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.4, end: 1.0).animate(bounceIn),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(fadeIn),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, _, __) => AchievementCelebrationDialog(achievement: achievement),
    );
  }

  @override
  State<AchievementCelebrationDialog> createState() => _AchievementCelebrationDialogState();
}

class _AchievementCelebrationDialogState extends State<AchievementCelebrationDialog>
    with TickerProviderStateMixin {
  late final AnimationController _glowController;
  late final AnimationController _particleController;
  late final AnimationController _badgeScaleController;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _badgeScaleAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _glowAnimation = CurvedAnimation(parent: _glowController, curve: Curves.easeInOut);

    _badgeScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _badgeScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeScaleController, curve: Curves.elasticOut),
    );
    _badgeScaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        width: 300,
        child: Stack(
          alignment: .center,
          clipBehavior: .none,
          children: [
            Container(
              padding: const .all(
                AppSizes.spacing24,
              ),
              decoration: BoxDecoration(
                color: context.theme.colors.card,
                borderRadius: .circular(AppSizes.radiusL),
                border: Border.all(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.45),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.18),
                    blurRadius: 40,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: .min,
                spacing: AppSizes.spacing24,
                children: [
                  Container(
                    padding: const .symmetric(
                      horizontal: AppSizes.spacing12,
                      vertical: AppSizes.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.12),
                      borderRadius: .circular(100),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '★  Achievement Unlocked',
                      style: context.theme.typography.xs.copyWith(
                        color: const Color(0xFFD4A017),
                        fontWeight: .w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _badgeScaleAnimation,
                    child: AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (_, child) => Container(
                        padding: const .all(AppSizes.spacing12),
                        decoration: BoxDecoration(
                          shape: .circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFD700,
                              ).withValues(alpha: 0.15 + 0.3 * _glowAnimation.value),
                              blurRadius: 24 + 20 * _glowAnimation.value,
                              spreadRadius: 2 + 6 * _glowAnimation.value,
                            ),
                          ],
                        ),
                        child: child,
                      ),
                      child: Image.asset(widget.achievement.badgeAsset, width: 108, height: 108),
                    ),
                  ),
                  Column(
                    spacing: AppSizes.spacing8,
                    children: [
                      Text(
                        widget.achievement.name,
                        style: context.theme.typography.lg.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.achievement.description,
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Collect',
                        style: context.theme.typography.sm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _particleController.dispose();
    _badgeScaleController.dispose();
    super.dispose();
  }
}
