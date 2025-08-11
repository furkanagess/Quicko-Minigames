import 'package:flutter/material.dart';
import '../../core/constants/app_icons.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../core/utils/sound_utils.dart';
import 'base_dialog.dart';

class GameOverDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final int score;
  final bool isWin;
  final String? losingNumber;
  final VoidCallback onTryAgain;

  const GameOverDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.score,
    required this.isWin,
    this.losingNumber,
    required this.onTryAgain,
  });

  @override
  State<GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {
  @override
  void initState() {
    super.initState();
    // Play game over sound when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SoundUtils.playGameOverSound();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWin = widget.isWin;
    final accentColor = isWin ? AppTheme.darkSuccess : AppTheme.darkError;
    final icon = isWin ? AppIcons.trophy : Icons.sentiment_dissatisfied_rounded;

    return BaseDialog(
      barrierDismissible: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          BaseDialogHeader(
            icon: Icon(icon),
            title: widget.title,
            subtitle: widget.subtitle,
            backgroundColor: accentColor.withValues(alpha: 0.1),
            iconColor: accentColor,
            titleColor: accentColor,
            subtitleColor: accentColor,
          ),

          // Content
          BaseDialogContent(
            child: Column(
              children: [
                // Score display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            AppIcons.trophy,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.score,
                            style: TextThemeManager.bodyMedium.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.score.toString(),
                        style: TextThemeManager.gameNumber.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Losing number (if provided)
                if (widget.losingNumber != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.lastNumber,
                          style: TextThemeManager.bodySmall.copyWith(
                            color: accentColor.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.losingNumber!,
                          style: TextThemeManager.subtitleMedium.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          BaseDialogActions(
            children: [
              BaseDialogButton(
                text: AppLocalizations.of(context)!.tryAgain,
                onPressed: widget.onTryAgain,
                isPrimary: true,
                icon: Icons.refresh_rounded,
                width: 140,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
