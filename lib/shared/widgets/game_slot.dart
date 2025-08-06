import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/text_theme_manager.dart';

class GameSlot extends StatelessWidget {
  final int? number;
  final int position;
  final bool isActive;
  final VoidCallback? onTap;

  const GameSlot({
    super.key,
    this.number,
    required this.position,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: number != null ? 0.9 + (0.1 * value) : 1.0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color:
                    isDark ? AppTheme.darkSlotBackground : AppTheme.darkSurface,
                border: Border.all(
                  color: isDark ? AppTheme.darkSlotBorder : AppTheme.slotBorder,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                boxShadow:
                    isActive
                        ? [
                          BoxShadow(
                            color: (isDark
                                    ? AppTheme.darkSlotBorder
                                    : AppTheme.slotBorder)
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                        : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pozisyon numarası
                  Text(
                    '${position + 1}.',
                    style: TextThemeManager.gameSlotNumberOnSurface(context),
                  ),
                  const SizedBox(height: 4),
                  // Sayı veya boş alan
                  number != null
                      ? TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, scaleValue, child) {
                          return Transform.scale(
                            scale: scaleValue,
                            child: Text(
                              number.toString(),
                              style: TextThemeManager.gameSlotValuePrimary(
                                context,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
