import 'package:flutter/material.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../../../shared/models/game_state.dart';
import '../models/aim_trainer_game_state.dart';
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

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          gameResult = GameResult(
            isWin: gameState.status == GameStatus.won,
            score: gameState.score,
            title:
                gameState.status == GameStatus.won
                    ? 'Congratulations!'
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                gameState.status == GameStatus.won
                    ? 'You hit all targets!'
                    : 'Time ran out!',
          );
        }

        return GameScreenBase(
          title: 'aim_trainer',
          descriptionKey: 'aim_trainer_description',
          gameId: 'aim_trainer',
          gameResult: gameResult,
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
          isWaiting: gameState.isWaiting,
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
            AppIcons.timer,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${AppLocalizations.of(context)!.time}: ${gameState.timeLeft}s',
            style: TextThemeManager.gameScorePrimary(context),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Icon(
            AppIcons.score,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Text(
            '${AppLocalizations.of(context)!.score}: ${gameState.score}',
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
          color: AppTheme.darkError,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkError.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
