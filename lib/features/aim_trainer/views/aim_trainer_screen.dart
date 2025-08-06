import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../../../shared/widgets/time_up_dialog.dart';
import '../../../shared/models/aim_trainer_game_state.dart';
import '../providers/aim_trainer_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/text_theme_manager.dart';

class AimTrainerScreen extends StatelessWidget {
  const AimTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AimTrainerProvider(),
      child: const _AimTrainerView(),
    );
  }
}

class _AimTrainerView extends StatelessWidget {
  const _AimTrainerView();

  @override
  Widget build(BuildContext context) {
    return Consumer<AimTrainerProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Show game over or time up dialog when needed
        if (gameState.showGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (gameState.timeLeft == 0) {
              _showTimeUpDialog(context, gameState, provider);
            } else {
              _showGameOverDialog(context, gameState, provider);
            }
          });
        }

        return GameScreenBase(
          title: 'aim_trainer',
          descriptionKey: 'aim_trainer_description',
          gameId: 'aim_trainer',
          bottomActions: _buildBottomActions(context, gameState, provider),
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Score and time display
        _buildScoreTimeDisplay(context, gameState),

        const SizedBox(height: AppConstants.extraLargeSpacing),

        // Game area with target
        _buildGameArea(context, gameState, provider),
      ],
    );
  }

  Widget _buildScoreTimeDisplay(
    BuildContext context,
    AimTrainerGameState gameState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largeSpacing,
        vertical: AppConstants.mediumSpacing,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${'time'.tr()}: ${gameState.timeLeft}s',
            style: TextThemeManager.gameScorePrimary(context),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Icon(
            Icons.score_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${'score'.tr()}: ${gameState.score}',
            style: TextThemeManager.gameScorePrimary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gameAreaWidth =
            constraints.maxWidth - AppConstants.mediumSpacing * 2;
        final gameAreaHeight = 300.0; // Fixed height as requested

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
              // Target
              if (gameState.isGameActive)
                Positioned(
                  left: gameState.targetPosition.dx - 24, // Center the target
                  top: gameState.targetPosition.dy - 24,
                  child: _buildTarget(context, gameState, provider),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTarget(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    return GestureDetector(
      onTap: () => provider.onTargetTap(),
      child: Container(
        width: 48, // 24px radius * 2
        height: 48,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  void _showGameOverDialog(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    // Ensure we have the final score
    final finalScore = gameState.score;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: GameOverDialog(
            title: 'game_over'.tr(),
            score: finalScore,
            isWin: false,
            onTryAgain: () {
              Navigator.of(context).pop();
              provider.hideGameOver();
              provider.resetGame();
            },
          ),
        );
      },
    );
  }

  void _showTimeUpDialog(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    final finalScore = gameState.score;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: TimeUpDialog(
            score: finalScore,
            onTryAgain: () {
              Navigator.of(context).pop();
              provider.hideGameOver();
              provider.resetGame();
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                gameState.isWaiting
                    ? [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ]
                    : [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.6),
                    ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(
                alpha: gameState.isWaiting ? 0.4 : 0.2,
              ),
              blurRadius: gameState.isWaiting ? 16 : 8,
              offset: Offset(0, gameState.isWaiting ? 6 : 3),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(
                alpha: gameState.isWaiting ? 0.2 : 0.1,
              ),
              blurRadius: gameState.isWaiting ? 32 : 16,
              offset: Offset(0, gameState.isWaiting ? 12 : 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (gameState.isWaiting) {
                provider.startGame();
              } else {
                provider.resetGame();
              }
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withValues(alpha: 0.3),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      gameState.isWaiting
                          ? Icons.play_arrow_rounded
                          : Icons.refresh_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextThemeManager.buttonLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                    child: Text(
                      gameState.isWaiting ? 'Start Game' : 'Restart Game',
                    ),
                  ),
                  if (gameState.isWaiting) ...[
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
