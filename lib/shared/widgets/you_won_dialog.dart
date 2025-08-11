import 'package:flutter/material.dart';
import 'package:quicko_app/l10n/app_localizations.dart';

import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../core/utils/sound_utils.dart';
import 'base_dialog.dart';

class YouWonDialog extends StatefulWidget {
  final int score;
  final VoidCallback onTryAgain;

  const YouWonDialog({
    super.key,
    required this.score,
    required this.onTryAgain,
  });

  @override
  State<YouWonDialog> createState() => _YouWonDialogState();
}

class _YouWonDialogState extends State<YouWonDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SoundUtils.playWinnerSound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      barrierDismissible: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          BaseDialogHeader(
            icon: const Icon(AppIcons.trophy),
            title: AppLocalizations.of(context)!.youWon,
            subtitle: AppLocalizations.of(context)!.congratulationsMessage,
            backgroundColor: AppTheme.darkSuccess.withValues(alpha: 0.1),
            iconColor: AppTheme.darkSuccess,
            titleColor: AppTheme.darkSuccess,
            subtitleColor: AppTheme.darkSuccess,
            iconSize: 32,
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
                    color: AppTheme.darkSuccess.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.darkSuccess.withValues(alpha: 0.1),
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
                            color: AppTheme.darkSuccess,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.finalScore,
                            style: TextThemeManager.bodyMedium.copyWith(
                              color: AppTheme.darkSuccess,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.score.toString(),
                        style: TextThemeManager.gameNumber.copyWith(
                          color: AppTheme.darkSuccess,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Celebration message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.darkSuccess.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.darkSuccess.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.celebration_rounded,
                        color: AppTheme.darkSuccess,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.excellentPerformance,
                          style: TextThemeManager.bodyMedium.copyWith(
                            color: AppTheme.darkSuccess,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          BaseDialogActions(
            children: [
              BaseDialogButton(
                text: AppLocalizations.of(context)!.playAgain,
                onPressed: widget.onTryAgain,
                isPrimary: true,
                icon: Icons.play_arrow_rounded,
                width: 140,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
