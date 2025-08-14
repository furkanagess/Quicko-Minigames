import 'package:flutter/material.dart';
import 'package:quicko_app/core/constants/app_icons.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/game_screen_base.dart';
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
          final isWin =
              gameState.gameOverReason == GameOverReason.timeUp &&
              gameState.score > 0;
          final isCivilianHit =
              gameState.gameOverReason == GameOverReason.civilianHit;

          gameResult = GameResult(
            isWin: isWin,
            score: gameState.score,
            title:
                isCivilianHit
                    ? AppLocalizations.of(context)!.missionFailed
                    : (isWin
                        ? AppLocalizations.of(context)!.congratulations
                        : AppLocalizations.of(context)!.gameOver),

            lossReason:
                isCivilianHit
                    ? AppLocalizations.of(context)!.greenTargetHit
                    : (isWin ? null : AppLocalizations.of(context)!.timeRanOut),
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
            value: '${gameState.timeLeft}s',
            color: colorScheme.primary,
          ),
          _InfoPill(
            icon: AppIcons.score,
            label: AppLocalizations.of(context)!.score,
            value: '${gameState.score}',
            color: colorScheme.primary,
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
                  left:
                      gameState.targetPosition.dx -
                      18, // Center the target (36px diameter)
                  top: gameState.targetPosition.dy - 18,
                  child: _buildTarget(context, gameState, provider),
                ),

              // Civilian target (green circle)
              if (gameState.isGameActive &&
                  gameState.showCivilian &&
                  gameState.civilianPosition != null)
                Positioned(
                  left: gameState.civilianPosition!.dx - 18,
                  top: gameState.civilianPosition!.dy - 18,
                  child: _buildCivilianTarget(context, gameState, provider),
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
        width: 36, // 18px radius * 2 (reduced from 48px)
        height: 36,
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

  Widget _buildCivilianTarget(
    BuildContext context,
    AimTrainerGameState gameState,
    AimTrainerProvider provider,
  ) {
    return GestureDetector(
      onTap: () => provider.onCivilianTap(),
      child: Container(
        width: 36, // Reduced from 48px
        height: 36,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.4),
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
