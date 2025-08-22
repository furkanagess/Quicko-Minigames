import 'package:flutter/material.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/game_slot.dart';
import '../../../shared/widgets/game_screen_base.dart';
import '../providers/blind_sort_provider.dart';
import '../../../shared/models/game_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';

class BlindSortScreen extends StatelessWidget {
  const BlindSortScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlindSortProvider(),
      child: const _BlindSortView(),
    );
  }
}

class _BlindSortView extends StatelessWidget {
  const _BlindSortView();

  @override
  Widget build(BuildContext context) {
    return Consumer<BlindSortProvider>(
      builder: (context, provider, child) {
        final gameState = provider.gameState;

        // Create game result when game is over
        GameResult? gameResult;
        if (gameState.showGameOver) {
          final isWin = gameState.status == GameStatus.won;
          gameResult = GameResult(
            isWin: isWin,
            score: gameState.score,

            title:
                isWin
                    ? AppLocalizations.of(context)!.congratulations
                    : AppLocalizations.of(context)!.gameOver,
            subtitle:
                isWin
                    ? AppLocalizations.of(
                      context,
                    )!.youSuccessfullySortedAllNumbers
                    : null,
            lossReason:
                isWin ? null : AppLocalizations.of(context)!.betterLuckNextTime,
          );
        }

        return GameScreenBase(
          title: 'blind_sort',
          descriptionKey: 'blind_sort_description',
          gameId: 'blind_sort',
          gameResult: gameResult,
          showCongratsOnWin: true,
          onTryAgain: () {
            provider.hideGameOver();
            provider.resetGame();
          },
          onContinueGame: () => provider.continueGame(),
          canContinueGame: () => provider.canContinueGame(),
          onBackToMenu: () {
            provider.hideGameOver();
            Navigator.of(context).pop();
          },
          onGameResultCleared: () => provider.cleanupGame(),
          onStartGame: () {
            provider.startGame();
            provider.startNumberAnimation();
          },
          onResetGame: () {
            provider.resetGame();
          },
          isWaiting: gameState.isWaiting,
          isGameInProgress: gameState.isGameActive,
          onPauseGame: () => provider.pauseGame(),
          onResumeGame: () => provider.resumeGame(),
          child: _buildGameContent(context, gameState, provider),
        );
      },
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    return Opacity(
      opacity: gameState.isWaiting ? 0.4 : 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sabit sayı gösterimi alanı
          _buildNumberDisplayArea(context, gameState, provider),

          const SizedBox(height: AppConstants.extraLargeSpacing),

          // Sabit oyun slotları alanı
          _buildGameSlots(context, gameState, provider),
        ],
      ),
    );
  }

  Widget _buildNumberDisplayArea(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300, // Maksimum genişlik
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skor rozeti - aydınlık tema için daha iyi kontrast
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15)
                      : Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark
                        ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2)
                        : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${AppLocalizations.of(context)!.score}: ${gameState.score}',
                  style: TextThemeManager.subtitleMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.mediumSpacing),

          // Modern sayı gösterimi - aydınlık tema için daha iyi kontrast
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getNumberDisplayColor(context, gameState),
                  _getNumberDisplayColor(
                    context,
                    gameState,
                  ).withValues(alpha: isDark ? 0.8 : 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              boxShadow: [
                BoxShadow(
                  color: _getNumberDisplayColor(
                    context,
                    gameState,
                  ).withValues(alpha: isDark ? 0.4 : 0.3),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: _getNumberDisplayColor(
                    context,
                    gameState,
                  ).withValues(alpha: isDark ? 0.2 : 0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _buildNumberContent(context, gameState, provider),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNumberDisplayColor(BuildContext context, GameState gameState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (gameState.isNextNumberUnplayable) {
      return isDark ? AppTheme.darkError : AppTheme.lightError;
    }
    return Theme.of(context).colorScheme.primary;
  }

  Widget _buildNumberContent(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (gameState.isWaiting) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 2000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(AppConstants.smallRadius),
              ),
              child: Icon(
                Icons.question_mark_rounded,
                size: 36,
                color: isDark ? Colors.white : Colors.white,
              ),
            ),
          );
        },
      );
    }

    if (gameState.isNextNumberUnplayable) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        ),
        child: Text(
          gameState.currentNumber.toString(),
          style: TextThemeManager.gameNumber.copyWith(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.7 + (0.3 * value),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            ),
            child: Text(
              provider.isAnimating
                  ? provider.animatedNumber.toString()
                  : gameState.currentNumber.toString(),
              style: TextThemeManager.gameNumber.copyWith(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameSlots(
    BuildContext context,
    GameState gameState,
    BlindSortProvider provider,
  ) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350, // Maksimum genişlik
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (1-5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return GameSlot(
                number: gameState.slots[index],
                position: index,
                isActive:
                    gameState.isGameActive &&
                    !provider.isAnimating &&
                    gameState.slots[index] == null,
                onTap:
                    gameState.isGameActive && !provider.isAnimating
                        ? () => provider.placeNumber(index)
                        : null,
              );
            }),
          ),

          const SizedBox(height: AppConstants.mediumSpacing),

          // Bottom Row (6-10)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final slotIndex = index + 5;
              return GameSlot(
                number: gameState.slots[slotIndex],
                position: slotIndex,
                isActive:
                    gameState.isGameActive &&
                    !provider.isAnimating &&
                    gameState.slots[slotIndex] == null,
                onTap:
                    gameState.isGameActive && !provider.isAnimating
                        ? () => provider.placeNumber(slotIndex)
                        : null,
              );
            }),
          ),
        ],
      ),
    );
  }
}
