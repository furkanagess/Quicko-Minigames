import 'package:flutter/material.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../models/reaction_time_game_state.dart';
import '../providers/reaction_time_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/text_theme_manager.dart';

class ReactionTimeScreen extends StatelessWidget {
  const ReactionTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReactionTimeProvider(),
      child: const _ReactionTimeView(),
    );
  }
}

class _ReactionTimeView extends StatelessWidget {
  const _ReactionTimeView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ReactionTimeProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          final isCompleted = gameState.nextTarget > 12;
          final finalScore = provider.calculateScore();

          gameResult = GameResult(
            isWin: isCompleted, // Win only if completed all targets
            score: finalScore,
            title:
                isCompleted
                    ? AppLocalizations.of(context)!.congratulations
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                isCompleted
                    ? _getTimePerformanceMessage(
                      context,
                      provider.getTimePerformanceMessage(),
                    )
                    : AppLocalizations.of(context)!.wrongSequence,
            lossReason:
                isCompleted
                    ? null
                    : AppLocalizations.of(context)!.wrongSequence,
          );
        }

        return GameScreenBase(
          title: 'reaction_time',
          descriptionKey: 'reactionTimeDescription',
          gameId: 'reaction_time',
          gameResult: gameResult,
          showCongratsOnWin: true,
          onTryAgain: () {
            provider.hideGameOver();
            provider.resetGame();
          },
          onBackToMenu: () {
            provider.hideGameOver();
            Navigator.of(context).pop();
          },
          onStartGame: () {
            provider.startGame();
          },
          onResetGame: () {
            provider.resetGame();
          },
          onContinueGame: () async {
            return await provider.continueGame();
          },
          canContinueGame: () async {
            return await provider.canContinueGame();
          },
          isWaiting: gameState.isWaiting,
          isGameInProgress: gameState.isGameActive,
          onPauseGame: () => provider.pauseGame(),
          onResumeGame: () => provider.resumeGame(),
          onGameResultCleared: () => provider.cleanupGame(),
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  String _getTimePerformanceMessage(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'perfectTime':
        return localizations.perfectTime;
      case 'goodTime':
        return localizations.goodTime;
      case 'averageTime':
        return localizations.averageTime;
      case 'slowTime':
        return localizations.slowTime;
      case 'verySlowTime':
        return localizations.verySlowTime;
      default:
        return key;
    }
  }

  Widget _buildGameContent(
    BuildContext context,
    ReactionTimeGameState gameState,
    ReactionTimeProvider provider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Status display
        _buildStatusDisplay(context, gameState, provider),

        const SizedBox(height: AppConstants.extraLargeSpacing),

        // Game area with targets
        _buildGameArea(context, gameState, provider),
      ],
    );
  }

  Widget _buildStatusDisplay(
    BuildContext context,
    ReactionTimeGameState gameState,
    ReactionTimeProvider provider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumSpacing,
        vertical: AppConstants.smallSpacing,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppConstants.mediumSpacing,
        runSpacing: AppConstants.smallSpacing,
        children: [
          _InfoPill(
            icon: AppIcons.timer,
            label: AppLocalizations.of(context)!.time,
            value: '${gameState.elapsedTime.toStringAsFixed(1)}s',
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(
    BuildContext context,
    ReactionTimeGameState gameState,
    ReactionTimeProvider provider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gameAreaWidth =
            constraints.maxWidth - AppConstants.mediumSpacing * 2;
        final gameAreaHeight = 300.0; // Match Aim Trainer area height

        // Update provider with game area size
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.setGameAreaSize(Size(gameAreaWidth, gameAreaHeight));
        });

        return Container(
          width: gameAreaWidth,
          height: gameAreaHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Targets - only show if game is active and not completed
              if (gameState.isGameActive &&
                  gameState.targetPositions.isNotEmpty)
                ...gameState.targetPositions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final position = entry.value;
                  final targetNumber = index + 1;
                  final isNextTarget = targetNumber == gameState.nextTarget;
                  final isCompleted = gameState.completedTargets.contains(
                    targetNumber,
                  );

                  // Don't show completed targets (they disappear)
                  if (isCompleted) return const SizedBox.shrink();

                  return Positioned(
                    left: position.dx - 20, // Center the target (40px diameter)
                    top: position.dy - 20,
                    child: _buildTarget(
                      context,
                      targetNumber,
                      isNextTarget,
                      provider,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTarget(
    BuildContext context,
    int targetNumber,
    bool isNextTarget,
    ReactionTimeProvider provider,
  ) {
    // All targets look the same
    final targetColor = Theme.of(context).colorScheme.primary;
    final textColor = Colors.white;

    return GestureDetector(
      onTap: () => provider.onTargetTap(targetNumber),
      child: Container(
        width: 40, // 40px diameter (reduced from 56px)
        height: 40,
        decoration: BoxDecoration(
          color: targetColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: targetColor.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            targetNumber.toString(),
            style: TextThemeManager.gameScorePrimary(context).copyWith(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            '$label:',
            style: TextThemeManager.bodySmall.copyWith(
              color: onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextThemeManager.subtitleMedium.copyWith(
              color: onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
